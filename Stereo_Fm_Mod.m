clear 
close all
clc

%% 5.2
[y_1,Fs_1] = audioread('music1.wav');               
[y_2,Fs_2] = audioread('piano2.wav');  

% Play audio
% soundsc(y_1,Fs_1);                                  
% soundsc(y_2,Fs_2);                                  

% Create left and right channels
y_left = y_1(:,1)+y_1(:,2);                         
y_left = y_left./max(y_left(:));                    

y_right = y_2(:,1)+y_2(:,2);                       
y_right = y_right./max(y_right(:));                 

plot_sig(y_left,Fs_1,'Left Channel');
plot_sig(y_right,Fs_2,'Right Channel');

%% Upsample and lowpass
up_freq = 200e3;

y_l_up_samp = resample(y_left,up_freq,Fs_1);              % upsample
y_l_up_filt = lowpass(y_l_up_samp,15e3,up_freq);          % LPF

y_r_up_samp = resample(y_right,up_freq,Fs_2);             % upsample
y_r_up_filt = lowpass(y_r_up_samp,15e3,up_freq);          % LPF

plot_sig(y_l_up_filt,up_freq,'Left Channel - Upsampled and Filtered');
plot_sig(y_r_up_filt,up_freq,'Right Channel - Upsampled and Filtered');

%% Create Stereo Stream
y_l_up_filt = y_l_up_filt(1:length(y_r_up_filt));         % cut length to equal right channel's length
f_p = 19e3;                                               % pilot tone frequency
f_delta = 75e3 ;                                          % frequency deviation


t = (1/up_freq)*(1:length(y_l_up_filt)).';
x_t = 0.5*(y_l_up_filt + y_r_up_filt);
x_t = x_t + 0.5*(y_l_up_filt - y_r_up_filt).*sin(4*pi*f_p*t);
x_t = 0.9*x_t;
x_t = x_t + 0.1*sin(2*pi*f_p*t);

plot_sig(x_t,up_freq,'Stereo Signal (Base Band)');
%% Modulate the stereo signal
y_integral = (1/up_freq) * cumsum(x_t);                   % integrate
y_mod = exp(2*pi*1j*f_delta*y_integral);                  % modulate

plot_sig(y_mod,up_freq,'Modulated Stereo Signal');

%% Upsample and LPF for USRP transmission
up_freq2 = 1e6;
y_mod_up_samp = resample(y_mod,up_freq2,up_freq);          % upsample
y_mod_up_filt = lowpass(y_mod_up_samp,128e3,up_freq2);     % LPF to BW according to carson rule (signal BW = max(f) = 53kHz

plot_sig(y_mod_up_filt,up_freq2,'Up Sampled and Filtered Modulated Signal');

%% save data
WR_bin_file('stereo_fm.bin',y_mod_up_filt);