Fs = 1000;                    %// Sampling frequency
freq = 5;
T = 1/Fs;                     %// Sample time
L = 1000;                     %// Length of signal
t = (0:L-1)*T;                %// Time vector
A = 10;                       %// Amplitude

y = A*(sin(2*pi*freq*t) > 0); %// Make a square wave


plot(Fs*t,y)
xlabel('time (milliseconds)')
%%
NFFT = 2^nextpow2(L);         %// Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

%// Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)') %// probably would be more meaningful if you convert this to radians per second, check out the xtickmark and xtickmarklabel properties of plot
ylabel('|Y(f)|')