clear 
close all
clc

%% Reading bin file
signal=RD_bin_file('mono_fm_rx.bin',6306500); %6306500
%signal=RD_bin_file('rx_data_4MSamples1MsPs_978MHz.bin',4000000);
%signal=RD_bin_file('mono_RY.bin',62052980);

%% Initialize necessary parameters
Fmax = 1e6; % USRP sample rate
f_delta = 75e3; % frequency deviation
Fs = 48e3; % sample rate of the audio
BW = 90e3; % FM signal BW according to carson rule
Fs_down = 200e3; % baseband sample rate

% plot received signal
plot_sig(signal,Fmax,'Received Signal')

%% Demodulate the signal

% Remove initial samples 
% num_of_bad_samples = 1e4 ;
% signal = signal(num_of_bad_samples:end); 

% LPF to the carson BW
filtered_signal = lowpass(signal,BW,Fmax);

% Down sample
down_sig = resample(filtered_signal,Fs_down,Fmax);
down_sig = down_sig/max(abs(down_sig));
plot_sig(down_sig,Fs_down,'filtered and down sampled signal')

% Demodulation
demod_sig = diff(unwrap(angle(down_sig)))*Fs_down/(2*pi*f_delta); % Fs_down due to numerical diff
plot_sig(demod_sig,Fs_down,'demodulated signal');

% Filtering the sound level
demod_filt_sig = lowpass(demod_sig,15e3,Fs_down);

% Last downsample
demod_down_filt_sig = resample(demod_filt_sig,Fs,Fs_down);
plot_sig(demod_down_filt_sig,Fs,'Demodulated down sampled filterd signal');

% Play audio
soundsc(demod_down_filt_sig,Fs)

