clear
clc
% 1. Checking the Audio Data
% (a) Read and listen to the given original audio data using audioread function.
[y, Fs] = audioread("PianoSound-44.1kHz.wav");
sound(y, Fs);

% (b) Convert the original audio data (result from 1(a)) from time domain to frequency domain using fast fourier transform (FFT). 
L = length(y); 
Y_org = fft(y);
P2 = abs(Y_org); 
P1 = P2(1:L/2+1); 
P1(2:end-1) = 2*P1(2:end-1);
f = Fs * (0:(L/2)) / L;
figure;
plot(f, P1);
title('Frequency Domain of Audio Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 2000]);

%%%%%
%%%%%
%%%%%
%%%%%
%%%%%
%%%%%

% 2. Design Low Pass Filter
% (a) Add noise with a frequency of 1500 Hz and a magnitude of 5000
freq_noise = 1500;
amp_noise = 5000;
Y_noise = Y_org;
idx = round(freq_noise * L / Fs);
Y_noise(idx) = Y_noise(idx) + amp_noise; 


% (b) Plot the noisy signal in the frequency domain
P2_noise = abs(Y_noise);
P1_noise = P2_noise(1:L/2+1);
P1_noise(2:end-1) = 2*P1_noise(2:end-1);
figure;
plot(f, P1_noise);
title('Frequency Domain of Noisy Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 2000]); 

% (c) Perform inverse FFT and listen to the resulting sound
audio_noisy = real(ifft(Y_noise)); 
sound(audio_noisy, Fs); 

% (d) Design a Low Pass Filter
cutoff_freq = 1400; 
lpf = designfilt('lowpassiir', 'FilterOrder', 64, ...
    'HalfPowerFrequency', cutoff_freq, 'SampleRate', Fs);
audio_filtered = filter(lpf, audio_noisy);
sound(audio_filtered, Fs);
fvtool(lpf); 

% (e) Plot the filtered audio in the frequency domain 
P2_filtered = abs(fft(audio_filtered));
P1_filtered = P2_filtered(1:L/2+1);
P1_filtered(2:end-1) = 2*P1_filtered(2:end-1);
figure;
plot(f, P1_filtered);
title('Frequency Domain of Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 2000]);

%%%%%
%%%%%
%%%%%
%%%%%
%%%%%
%%%%%

% 3. Design Band Pass Filter
% (a) Add two noises with frequencies of 150 Hz and 1500 Hz and a magnitude of 5000
freq_noise1 = 150; 
freq_noise2 = 1500; 
amp_noise = 5000; 
Y_band = Y_org;
idx1 = round(freq_noise1 * L / Fs); 
idx2 = round(freq_noise2 * L / Fs); 
Y_band(idx1) = Y_band(idx1) + amp_noise;
Y_band(idx2) = Y_band(idx2) + amp_noise;

% (b) Plot the noisy signal in the frequency domain
P2_band_noise = abs(Y_band);
P1_band_noise = P2_band_noise(1:L/2+1);
P1_band_noise(2:end-1) = 2*P1_band_noise(2:end-1);
figure;
plot(f, P1_band_noise);
title('Frequency Domain of Signal with Two Noises');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 2000]);

% (c) Perform inverse FFT and listen to the resulting sound
audio_band_noisy = real(ifft(Y_band));
sound(audio_band_noisy, Fs);

% (d) Design a Band Pass Filter
passband_freq = [160 1400]; 
bpf = designfilt('bandpassiir', 'FilterOrder', 64, ...
    'HalfPowerFrequency1', passband_freq(1), ...
    'HalfPowerFrequency2', passband_freq(2), ...
    'SampleRate', Fs);
fvtool(bpf);
audio_band_filtered = filter(bpf, audio_band_noisy);
sound(audio_band_filtered, Fs);

% (e) Plot the filtered audio in the frequency domain
Y_band_filtered = fft(audio_band_filtered); 
P2_band_filtered = abs(Y_band_filtered);
P1_band_filtered = P2_band_filtered(1:L/2+1);
P1_band_filtered(2:end-1) = 2*P1_band_filtered(2:end-1);
figure;
plot(f, P1_band_filtered);
title('Frequency Domain of Filtered Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
xlim([0 2000]);
