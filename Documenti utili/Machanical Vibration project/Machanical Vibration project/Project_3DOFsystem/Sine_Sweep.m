clear all; 
close all; 
clc;

% Load data
load input_data_sine_s_slow;
load input_data_sine_s_fast;

%plot sine sweep slow 
figure
plot(t_sss,x1_sss,t_sss,x2_sss,t_sss,x3_sss)
xlabel('t (s)');ylabel('x (m)');
grid
title('sine sweep slow')

%plot sine sweep fast
figure
plot(t_ssf,x1_ssf,t_ssf,x2_ssf,t_ssf,x3_ssf)
xlabel('t (s)');ylabel('x (m)');
grid
title('sine sweep fast')

figure
plot(t_ssf,v_ssf,t_sss,v_sss)
xlabel('t (s)');ylabel('v (V)');
grid
title('voltage')


%% Transfer function estimate

Ts_ssf         = t_ssf(1000) - t_ssf(999);
data_ssf_1      = iddata( [ x1_ssf  ] , v_ssf, Ts_ssf )
TF_fast_11     = tfest(data_ssf_1,[ 6 ],[ 4 ]);

Ts_sss         = t_sss(1000) - t_sss(999);
data_sss_1       = iddata( [ x1_sss  ] , v_sss, Ts_sss )
TF_slow_11     = tfest(data_sss_1,[ 6 ],[ 4 ]);

b1 = bodeplot(TF_fast_11,TF_slow_11);


Ts_ssf         = t_ssf(1000) - t_ssf(999);
data_ssf_2       = iddata( [ x2_ssf  ] , v_ssf, Ts_ssf )
TF_fast_12 = tfest(data_ssf_2,[ 6 ],[ 3 ])

Ts_sss         = t_sss(1000) - t_sss(999);
data_sss_2      = iddata( [ x2_sss  ] , v_sss, Ts_sss )
TF_slow_12 = tfest(data_sss_2,[6 ],[ 3 ])

b2 = bodeplot(TF_fast_12,TF_slow_12);


Ts_ssf         = t_ssf(1000) - t_ssf(999);
data_ssf_3       = iddata( [ x3_ssf  ] , v_ssf, Ts_ssf )
TF_fast_13 = tfest(data_ssf_3,[ 6 ],[ 2 ])

Ts_sss         = t_sss(1000) - t_sss(999);
data_sss_3      = iddata( [ x3_sss  ] , v_sss, Ts_sss )
TF_slow_13 = tfest(data_sss_3,[6 ],[ 2 ])

b3 = bodeplot(TF_fast_13,TF_slow_13);

%% FFT
Fs_ssf = 1/Ts_ssf;            % Sampling frequency

N_ssf = length(t_ssf);             % Length of signal L=T*Fs

FTT_ssf = fft(v_ssf);

M2_ssf = abs(FTT_ssf.*Ts_ssf);
M1_ssf = M2_ssf(1:N_ssf/10+1);
f_ssf = Fs_ssf*(0:N_ssf/10)/N_ssf;

plot(f_ssf,M1_ssf)

%slow
Fs_sss = 1/Ts_sss;            % Sampling frequency
N_sss = length(t_sss);             % Length of signal L=T*Fs

FTT_sss = fft(v_sss);

M2_sss = abs(FTT_sss.*Ts_sss);
M1_sss = M2_sss(1:N_sss/8+1);
f_sss = Fs_sss*(0:(N_sss/8))/N_sss;

plot(f_sss,M1_sss)

%compare
plot(f_ssf,M1_ssf,f_sss,M1_sss)

