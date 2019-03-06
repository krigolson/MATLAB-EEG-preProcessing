[y, Fs] = audioread('mozart.wav');
yshort = y(5000000:5500000);
sound(yshort, Fs);

subplot(2,2,1);
plot(yshort);

subplot(2,2,2);

L = length(yshort);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(yshort,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1)));
ylim([0 1.4e-3]);
xlabel('Frequency (Hz)');

data_length = size(yshort,2);
nyquist_freq = 0.5*Fs; % half sample rate 

[b,a] = butter(2,(0.8),'high');
filtery = filtfilt(b,a, yshort);
filtery = filtery*10000;

pause;

subplot(2,2,3);
plot(filtery);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(filtery,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
subplot(2,2,4);
plot(f,2*abs(Y(1:NFFT/2+1)));
ylim([0 1.4e-3]);
xlabel('Frequency (Hz)');

pause;
sound(filtery, Fs);