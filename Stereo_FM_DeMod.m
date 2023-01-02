clear 
close all
clc

%% Initialize necessary parameters
Fmax = 1e6;
f_delta = 75e3;
BW = 128e3; % FM stereo signal BW according to carson rule
Fs_down = 200e3; % baseband sample rate
my_sig = true ; % in order to choose the input demodulated stereo signal
lpf_steepness = 0.99 ;
if my_sig
    signal = RD_bin_file('stereo_fm_rx.bin',6306500);
    Fs_L = 44.1e3;
    Fs_R = 48e3;
else
    signal = RD_bin_file('rx_data_4MSamples1Msps_978MHz.bin',4e6) ;
    Fs_L = 10e3 ;
    Fs_R = Fs_L ;
end

plot_sig(signal,Fmax,'Received Signal')

%% Remove initial samples 
% num_of_bad_samples = 5e4 ;
% signal = signal(num_of_bad_samples:end); 

%% Filtering and downsampling the received signal
% LPF to the carson BW 
filtered_signal = lowpass(signal,BW,Fmax,Steepness=lpf_steepness); 

% Down sample to 200kHz
down_sig = resample(signal,Fs_down,Fmax);
down_sig = down_sig/max(abs(down_sig));
plot_sig(down_sig,Fs_down,'filtered and down sampled signal')

%% Stereo Signal Demodulation 
demod_sig = diff(unwrap(angle(down_sig)))*Fs_down/(2*pi*f_delta); 
plot_sig(demod_sig,Fs_down,'demodulated signal') ;

% Filtering out the mono signal from frequencies 0-15kHz
demod_mono = lowpass(demod_sig,15e3,Fs_down,Steepness=lpf_steepness);
plot_sig(demod_mono,Fs_down,'filtered mono') ;

% Phase recovery according to pilot tone
f_pilot = 19e3 ;
t_ax = (1/Fs_down)*(1:length(demod_sig)) ;

demod_complex = demod_sig.*cos(2*pi*f_pilot*t_ax) + 1i*demod_sig.*sin(2*pi*f_pilot*t_ax); % shifting to f_p
demod_complex = lowpass(demod_complex,4e3,Fs_down,Steepness=lpf_steepness); % 4e3 in order to filter only the pilot tone
phase = angle(demod_complex);

% Filtering out the stereo data from frequencies 23kHz-53kHz
demod_stereo_data = demod_sig.*sin(4*pi*f_pilot*t_ax+phase);
plot_sig(demod_stereo_data,Fs_down,'Stereo signal in base band');

filt_demod_stereo_data = 2*lowpass(demod_stereo_data,15e3,Fs_down,Steepness=lpf_steepness);
plot_sig(filt_demod_stereo_data,Fs_down,'filtered stereo');

%% Recover L and R channelc from the mono and stereo data according to Quadraphonic FM method
R = demod_mono - filt_demod_stereo_data;
L = demod_mono + filt_demod_stereo_data;

%% Resample each channel to its original samplig freq
R = resample(R,Fs_R,Fs_down);
R = lowpass(R,15e3,Fs_R,Steepness=lpf_steepness) ;
plot_sig(R,Fs_R,'demodulated down sampled R channel');

L = resample(L,Fs_L,Fs_down);
L = lowpass(L,15e3,Fs_L,Steepness=lpf_steepness) ;
plot_sig(L,Fs_L,'demodulated down sampled L channel');

%% Play left and right channels
%soundsc(L,Fs_L)
%pause(length(L)*Fs_L^-1)
%soundsc(R,Fs_R)









