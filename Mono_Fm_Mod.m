clear 
close all
clc

%% 4.1.1-2 
[y,Fs] = audioread('piano2.wav');           % Fs is the sample rate (calculated by nyquist theorem
% plot_sig(y,Fs,'Input Audio FFT') % to compare to Fs value according Nyquist theorem

% soundsc(y,Fs);                            % play the audio
y_mono = y(:,1)+y(:,2);                     % create mono channel
%soundsc(y_mono,10000); 
y_mono = y_mono./max(y_mono(:));            % normalize
%soundsc(y_mono,Fs);                       % play the audio

% Plot the audio signal
plot_sig(y_mono,Fs,'Piano2 Mono Input')

%% 4.1.3
up_freq = 200e3;

y_up_samp = resample(y_mono,up_freq,Fs);            % upsample
y_up_filt = lowpass(y_up_samp,15e3,up_freq);        % LPF

% Plot the upsampled and filteres signal
plot_sig(y_up_filt,up_freq,'Upsampled signal to 200KHz and filtered in 15KHz')

%% 4.1.4
f_delta = 75e3;                                     % frequency deviation
y_integral = (1/up_freq) * cumsum(y_up_filt);       % integrate
y_mod = exp(2*pi*1j*f_delta*y_integral);            % modulate

% Plot the modulated signal
plot_sig(y_mod,up_freq,'Modulated Signal')

%% 4.1.5 - Upsample and LPF for USRP transmission
up_freq2 = 1e6;
y_mod_up_samp = resample(y_mod,up_freq2,up_freq);           % upsample
y_mod_up_filt = lowpass(y_mod_up_samp,90e3,up_freq2);       % LPF according carson rule 

% Plot the modulated upsmpled and filtered signal for USRP
plot_sig(y_mod_up_filt,up_freq2,'Upsampled modulated signal to 1MHz and filtered in 90KHz')

%% 4.1.6
% save data
WR_bin_file('mono_fm.bin',y_mod_up_filt);

%WR_bin_file('mono_RY.bin',y_mod_up_filt);
