function [badChannels,REPORT] = doFindBadChannels(EEG,maximumPercent,varargin)
%doFindBadChannels Finds the channels that cost too many epochs at artifact
%   rejection, so they can be removed and interpolated on a second pass.
%
%   [badChannels,REPORT] = doFindBadChannels(EEG,maximumPercent)
%
%   This is the first pass of a two-pass pipeline, used in place of
%   clean_rawdata:
%
%     Pass 1  Run the pipeline as normal (filter, re-reference, ICA, epoch,
%             baseline, doArtifactRejection) but do NOT remove any epochs.
%             Call doFindBadChannels on the result.
%     Pass 2  Start again from the filtered data. Remove badChannels before
%             the re-reference and the ICA, and interpolate them back after
%             the ICA (doInterpolateChannels). Then epoch and reject as
%             normal.
%
%   A channel is bad if it fails artifact rejection in more than
%   maximumPercent of the epochs, or if it is flat. This function does not
%   change the data; it only reports.
%
%   AVERAGE REFERENCE. With an average reference a very bad channel leaks
%   into every other channel (each one carries 1/N of it), so one bad
%   channel can make all of them fail. To stop that, when the data are
%   average referenced the channels are found one at a time: of the
%   channels over the limit, the one with the largest amplitude is flagged,
%   the data are re-referenced to the average of the channels that are left
%   (which is what the second pass will do), the artifact checks are run
%   again, and so on until no channel is over the limit. Only a copy of the
%   data is re-referenced.
%
% INPUTS
%   EEG            : epoched data that has been through doArtifactRejection
%                    one or more times (EEG.artifact). An epoch counts
%                    against a channel if the channel fails any of the
%                    checks in it.
%   maximumPercent : a channel is bad if it fails in more than this
%                    percentage of the epochs (for example 10).
%
% NAME-VALUE PAIRS
%   'MaximumChannels' : the most channels that may be interpolated. Default
%                       is 10% of the channels, rounded down. If more are
%                       bad, the worst ones up to this number are returned,
%                       REPORT.capExceeded is true and the rest are listed
%                       in REPORT.notInterpolated, so you can decide whether
%                       to keep the participant.
%   'FlatCheckData'   : the same recording BEFORE re-referencing (an EEG
%                       structure or a channels x time matrix, with the
%                       channels in the same order as EEG). Used to find
%                       flat (dead) channels. A flat channel passes artifact
%                       rejection and stops being flat once the data are
%                       re-referenced, so it can only be found here. Default
%                       is to check EEG itself, which is only meaningful if
%                       the data were not re-referenced.
%   'FlatCriterion'   : a channel is flat if its standard deviation is below
%                       this, in the units of the data. Default 0.5.
%   'WarnChannels'    : channels you care about, for example {'FCz'}. If
%                       one of them is bad it is still returned, but it is
%                       listed in REPORT.warnChannelsBad and a warning is
%                       printed.
%   'AverageReference': 'auto' (default), true or false. Whether to correct
%                       for the leak described above. 'auto' corrects if
%                       the data are average referenced (the channels sum
%                       to zero at every sample).
%   'Neighbours'      : two bad channels are reported as neighbours if one
%                       is among this many nearest channels of the other.
%                       Interpolation is poor when neighbours are both bad.
%                       Default 4.
%   'Verbose'         : true (default) prints a summary.
%
% OUTPUTS
%   badChannels : labels of the channels to remove and interpolate
%   REPORT      : a record to save with the participant's data
%       .badChannels, .badChannelIndex   the channels to interpolate
%       .reason             'flat' or 'artifacts', one per bad channel
%       .channelTable       one row per channel: label, percent of epochs
%                           failed (as recorded, and after the average
%                           reference correction), standard deviation,
%                           flat, bad, interpolate
%       .percentBad         percent of epochs each channel failed, as
%                           recorded by doArtifactRejection
%       .percentCorrected   the same with the data referenced to the
%                           average of the good channels only. This is the
%                           number compared with maximumPercent.
%       .averageReferenceCorrected   true if the correction was used
%       .percentByCheck     the same for each artifact check separately
%       .checks             the type of each artifact check
%       .maximumPercent, .maximumChannels, .flatCriterion   the settings
%       .capExceeded        true if more channels were bad than allowed
%       .notInterpolated    bad channels left in because of the cap
%       .neighbouringBadChannels   pairs of bad channels that are neighbours
%       .warnChannelsBad    channels from 'WarnChannels' that are bad
%       .numberOfEpochs
%       .epochsRejected            epochs that fail with every channel in
%       .epochsRejectedWithout     epochs that would still fail without the
%                                  bad channels. This is an estimate: on
%                                  the second pass the ICA changes too.
%
% EXAMPLE
%   EEG = doArtifactRejection(EEG,'Gradient',30);
%   EEG = doArtifactRejection(EEG,'Difference',150);
%   [badChannels,REPORT] = doFindBadChannels(EEG,10,'FlatCheckData',filteredEEG,'WarnChannels',{'FCz'});
%
% See also doArtifactRejection, doInterpolateChannels

%% Inputs

if ~isfield(EEG,'artifact') || isempty(EEG.artifact)
    error('EEG.artifact is missing. Run doArtifactRejection before doFindBadChannels.');
end
if ~isnumeric(maximumPercent) || ~isscalar(maximumPercent) || maximumPercent < 0 || maximumPercent > 100
    error('maximumPercent must be a number from 0 to 100.');
end

numberOfChannels = size(EEG.data,1);
numberOfEpochs = size(EEG.data,3);

parser = inputParser;
addParameter(parser,'MaximumChannels',floor(0.10*numberOfChannels),@(x) isnumeric(x) && isscalar(x) && x >= 0);
addParameter(parser,'FlatCheckData',[],@(x) isempty(x) || isstruct(x) || isnumeric(x));
addParameter(parser,'FlatCriterion',0.5,@(x) isnumeric(x) && isscalar(x) && x >= 0);
addParameter(parser,'WarnChannels',{},@(x) iscell(x) || ischar(x) || isstring(x));
addParameter(parser,'AverageReference','auto',@(x) islogical(x) || isnumeric(x) || any(strcmpi(x,{'auto'})));
addParameter(parser,'Neighbours',4,@(x) isnumeric(x) && isscalar(x) && x >= 0);
addParameter(parser,'Verbose',true,@(x) islogical(x) || isnumeric(x));
parse(parser,varargin{:});
settings = parser.Results;
settings.WarnChannels = cellstr(settings.WarnChannels);

if isfield(EEG,'chanlocs') && numel(EEG.chanlocs) == numberOfChannels
    labels = {EEG.chanlocs.labels};
else
    labels = arrayfun(@(x) sprintf('Channel %d',x),1:numberOfChannels,'UniformOutput',false);
end
labels = labels(:)';

%% Percent of epochs each channel fails

numberOfChecks = numel(EEG.artifact);
failed = false(numberOfChannels,numberOfEpochs);
percentByCheck = zeros(numberOfChannels,numberOfChecks);
checks = cell(1,numberOfChecks);

for checkCounter = 1:numberOfChecks
    badSegments = EEG.artifact(checkCounter).badSegments;
    if ~isequal(size(badSegments),[numberOfChannels numberOfEpochs])
        error('EEG.artifact(%d).badSegments does not match the data (channels x epochs). Call doFindBadChannels before any epochs or channels are removed.',checkCounter);
    end
    failed = failed | badSegments > 0;
    percentByCheck(:,checkCounter) = 100 * mean(badSegments > 0,2);
    checks{checkCounter} = EEG.artifact(checkCounter).type;
end

percentBad = 100 * mean(failed,2);   % as recorded by doArtifactRejection

%% Flat channels

if isempty(settings.FlatCheckData)
    flatData = EEG.data;
    flatCheckedOn = 'EEG';
elseif isstruct(settings.FlatCheckData)
    flatData = settings.FlatCheckData.data;
    flatCheckedOn = 'FlatCheckData';
    if isfield(settings.FlatCheckData,'chanlocs') && numel(settings.FlatCheckData.chanlocs) == numberOfChannels ...
            && ~isequal({settings.FlatCheckData.chanlocs.labels},{EEG.chanlocs.labels})
        error('The channels in FlatCheckData are not in the same order as the channels in EEG.');
    end
else
    flatData = settings.FlatCheckData;
    flatCheckedOn = 'FlatCheckData';
end
if size(flatData,1) ~= numberOfChannels
    error('FlatCheckData has %d channels but EEG has %d.',size(flatData,1),numberOfChannels);
end

standardDeviation = std(double(reshape(flatData,numberOfChannels,[])),0,2,'omitnan');
flat = standardDeviation < settings.FlatCriterion | ~isfinite(standardDeviation);

%% Is the average reference correction needed?

data = double(EEG.data);

if ischar(settings.AverageReference) || isstring(settings.AverageReference)
    % average referenced data sum to zero across channels at every sample
    channelMean = mean(data,1);
    correctReference = sqrt(mean(channelMean(:).^2)) < 1e-3 * sqrt(mean(data(:).^2));
else
    correctReference = logical(settings.AverageReference);
end

knownChecks = {'Gradient','Difference','Max','Min','Variance'};
if correctReference && ~all(ismember(checks,knownChecks))
    warning('doFindBadChannels:unknownCheck','An artifact check is not one doFindBadChannels can run again, so the average reference correction is off.');
    correctReference = false;
end

%% Find the bad channels
% Flat channels go first. Without the correction, every channel over the
% limit is bad. With it, one channel at a time is flagged and taken out of
% the reference before the others are judged again. The channel flagged is
% the one with the largest amplitude among those over the limit, because a
% channel that leaks into the others is always larger than its leak.

bad = flat;

if correctReference
    while nnz(~bad) > 2
        [currentPercent,amplitude] = judge(data,~bad,EEG.artifact);
        candidates = currentPercent > maximumPercent & ~bad;
        if ~any(candidates)
            break
        end
        amplitude(~candidates) = -Inf;
        [~,worst] = max(amplitude);
        bad(worst) = true;
    end
    % a channel flagged early may be fine once the others are out
    percentCorrected = judge(data,~bad,EEG.artifact);
    bad(~flat & percentCorrected <= maximumPercent) = false;
    percentCorrected = judge(data,~bad,EEG.artifact);
else
    percentCorrected = percentBad;
    bad = bad | percentBad > maximumPercent;
end

% worst first: flat channels, then the channels that fail most often
ranking = percentCorrected;
ranking(flat) = Inf;
[~,order] = sort(ranking,'descend');
order = order(bad(order))';

%% Apply the cap

maximumChannels = floor(settings.MaximumChannels);
capExceeded = numel(order) > maximumChannels;
interpolate = false(numberOfChannels,1);
interpolate(order(1:min(numel(order),maximumChannels))) = true;

badChannelIndex = find(interpolate)';
badChannels = labels(badChannelIndex);
reason = repmat({'artifacts'},1,numel(badChannelIndex));
reason(flat(badChannelIndex)) = {'flat'};
notInterpolated = labels(bad & ~interpolate);

% epochs that would still be rejected with the interpolated channels gone
if correctReference
    [~,~,remainingFailed] = judge(data,~interpolate,EEG.artifact);
else
    remainingFailed = failed;
end
epochsRejectedWithout = sum(any(remainingFailed(~interpolate,:),1));

%% Neighbouring bad channels

neighbouringBadChannels = cell(0,2);
haveLocations = isfield(EEG,'chanlocs') && numel(EEG.chanlocs) == numberOfChannels && all(isfield(EEG.chanlocs,{'X','Y','Z'})) ...
    && ~any(cellfun(@isempty,{EEG.chanlocs.X}));
if haveLocations && numel(badChannelIndex) > 1 && settings.Neighbours > 0
    positions = [[EEG.chanlocs.X]' [EEG.chanlocs.Y]' [EEG.chanlocs.Z]'];
    for first = badChannelIndex
        distance = sqrt(sum((positions - positions(first,:)).^2,2));
        distance(first) = Inf;
        [~,nearest] = sort(distance);
        nearest = nearest(1:min(settings.Neighbours,numberOfChannels-1))';
        for second = intersect(nearest,badChannelIndex)
            pair = sort([first second]);
            if ~any(strcmp(neighbouringBadChannels(:,1),labels{pair(1)}) & strcmp(neighbouringBadChannels(:,2),labels{pair(2)}))
                neighbouringBadChannels(end+1,:) = labels(pair); %#ok<AGROW>
            end
        end
    end
end

warnChannelsBad = intersect(settings.WarnChannels,labels(bad),'stable');

%% Report

REPORT.badChannels = badChannels;
REPORT.badChannelIndex = badChannelIndex;
REPORT.reason = reason;
REPORT.channelTable = table(labels',percentBad,percentCorrected,standardDeviation,flat,bad,interpolate, ...
    'VariableNames',{'channel','percentOfEpochsFailed','percentAfterCorrection','standardDeviation','flat','bad','interpolate'});
REPORT.percentBad = percentBad;
REPORT.percentCorrected = percentCorrected;
REPORT.averageReferenceCorrected = correctReference;
REPORT.percentByCheck = percentByCheck;
REPORT.checks = checks;
REPORT.maximumPercent = maximumPercent;
REPORT.maximumChannels = maximumChannels;
REPORT.flatCriterion = settings.FlatCriterion;
REPORT.flatCheckedOn = flatCheckedOn;
REPORT.capExceeded = capExceeded;
REPORT.notInterpolated = notInterpolated;
REPORT.neighbouringBadChannels = neighbouringBadChannels;
REPORT.warnChannelsBad = warnChannelsBad;
REPORT.numberOfChannels = numberOfChannels;
REPORT.numberOfEpochs = numberOfEpochs;
REPORT.epochsRejected = sum(any(failed,1));
REPORT.epochsRejectedWithout = epochsRejectedWithout;

%% Summary

if settings.Verbose
    if isempty(badChannels)
        fprintf('doFindBadChannels: no bad channels (limit %g%% of %d epochs).\n',maximumPercent,numberOfEpochs);
    else
        fprintf('doFindBadChannels: %d channel(s) to interpolate (limit %g%% of %d epochs):\n',numel(badChannels),maximumPercent,numberOfEpochs);
        for counter = 1:numel(badChannelIndex)
            fprintf('    %-6s %5.1f%% of epochs failed (%s)\n',badChannels{counter},percentCorrected(badChannelIndex(counter)),reason{counter});
        end
        fprintf('    Epochs rejected: %d of %d now, about %d without these channels.\n', ...
            REPORT.epochsRejected,numberOfEpochs,REPORT.epochsRejectedWithout);
    end
    if correctReference
        fprintf('    (Percentages are after correcting for the average reference.)\n');
    end
    if capExceeded
        fprintf('    WARNING: %d channels are bad but only %d may be interpolated. Left in: %s\n', ...
            numel(order),maximumChannels,strjoin(notInterpolated,', '));
    end
    for counter = 1:size(neighbouringBadChannels,1)
        fprintf('    WARNING: %s and %s are neighbours, so their interpolation will be poor.\n', ...
            neighbouringBadChannels{counter,1},neighbouringBadChannels{counter,2});
    end
    if ~isempty(warnChannelsBad)
        fprintf('    WARNING: channel(s) of interest are bad: %s\n',strjoin(warnChannelsBad,', '));
    end
end

end

%% Local functions

function [percent,amplitude,failed] = judge(data,inReference,artifact)
% Re-references a copy of the data to the average of the channels in
% inReference and runs the artifact checks again. Returns the percent of
% epochs each channel fails and its mean peak-to-peak amplitude.
data = data - mean(data(inReference,:,:),1);
failed = runChecks(data,artifact);
percent = 100 * mean(failed,2);
amplitude = mean(reshape(max(data,[],2) - min(data,[],2),size(data,1),[]),2);
end

function failed = runChecks(data,artifact)
% Runs the checks recorded in EEG.artifact again on data (channels x time x
% epochs), with the same criteria as doArtifactRejection. Returns channels x
% epochs, true where a channel fails any check.
failed = false(size(data,1),size(data,3));
for checkCounter = 1:numel(artifact)
    criteria = artifact(checkCounter).criteria;
    switch artifact(checkCounter).type
        case 'Gradient'    % the criteria is stored per sample
            value = max(abs(diff(data,1,2)),[],2);
            failed = failed | reshape(value > criteria,size(data,1),[]);
        case 'Difference'
            value = max(data,[],2) - min(data,[],2);
            failed = failed | reshape(value > criteria,size(data,1),[]);
        case 'Max'
            failed = failed | reshape(max(data,[],2) > criteria,size(data,1),[]);
        case 'Min'
            failed = failed | reshape(min(data,[],2) < criteria,size(data,1),[]);
        case 'Variance'
            failed = failed | reshape(var(data,0,2) > criteria,size(data,1),[]);
    end
end
end
