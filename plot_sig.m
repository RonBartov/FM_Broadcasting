function plot_sig(signal,Fs,big_title)
% plot time domain
figure;

subplot(1,2,1);
t_ax = (1/Fs)*(1:length(signal));
plot(t_ax,real(signal));
xlabel('time [sec]');
ylabel('signal');
title('Time Domain');
grid on;

% plot freq domain
fft_signal = fft(signal);
len_f = length(fft_signal);
f = linspace(-Fs/2,Fs/2,len_f);
subplot(1,2,2);
plot(f/1e3,20*log10(abs(fftshift(fft_signal))));
xlabel('f [KHz]');
ylabel('signal [dB]');
title('Frequency Domain');
grid on;

sgtitle(big_title);
end

