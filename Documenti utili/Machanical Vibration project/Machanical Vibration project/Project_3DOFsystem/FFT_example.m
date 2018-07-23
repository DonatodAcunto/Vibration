clear all; 
close all; 
clc;

tc=0.01;         %sampling period
fc=1/tc;        %sempling frequency
t = 0:tc:10; %time domain

w =  2*pi*1 ;    %pulsazione segnale
fs = w/2*pi  ;   %frequenza del segnale

w2 =  2*pi*10 ;    %pulsazione segnale
fs2 = w/2*pi  ;   %frequenza del segnale

x = sin(w*t)+0.1*sin(w2*t) ; 

plot(t,x)
%%
y = fft(x);
m = abs(y/length(y));
p = angle(y);

f = (0:length(y)-1)*fc/length(y);

subplot(2,1,1)
plot(f,m)
title('Magnitude')

subplot(2,1,2)
plot(f,rad2deg(p))
title('Phase')