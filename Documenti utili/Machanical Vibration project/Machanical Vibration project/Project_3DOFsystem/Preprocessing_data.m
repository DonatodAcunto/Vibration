%% Data steps Pre-processing 
clear all; 
close all; 
clc;

load data_steps;

% data 
k1=800;
k2=800;
k3=400;

% converision encoder to displacement 
x1_s = (0.0706/16000)*x1;
x2_s = (0.0706/16000)*x2;
x3_s = (0.0706/16000)*x3;

% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
f1=(ka*kt*kmp)*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f= horzcat(f1,f2,f3);

% save 
save input_data_steps

clear all; 
close all; 
clc;
%% data impulses pre-processing 
load data_impulses;

% data 
k1=800;
k2=800;
k3=400;
% converision encoder to displacement 
x1_i = (0.0706/16000)*x1;
x2_i = (0.0706/16000)*x2;
x3_i = (0.0706/16000)*x3;

% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
f1=(ka*kt*kmp)*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f= horzcat(f1,f2,f3);

% save 
save input_data_impulses

clear all; 
close all; 
clc;
%% data sine sweep slow pre-processing 
load data_sine_sweep_slow;

% data 
k1=800;
k2=800;
k3=400;
% converision encoder to displacement 
x1_sss = (0.0706/16000)*x1;
x2_sss = (0.0706/16000)*x2;
x3_sss = (0.0706/16000)*x3;

%time 
t_sss=t;

%voltage
v_sss=v;

% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
f1=(ka*kt*kmp)*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f_sss= horzcat(f1,f2,f3);

% save 
save input_data_sine_s_slow

clear all; 
close all; 
clc;
%% data sine sweep fast pre-processing 
load data_sine_sweep_fast;

% data 
k1=800;
k2=800;
k3=400;

% converision encoder to displacement 
x1_ssf = (0.0706/16000)*x1;
x2_ssf = (0.0706/16000)*x2;
x3_ssf = (0.0706/16000)*x3;

%time
t_ssf=t;

%voltage
v_ssf=v;

% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
f1=(ka*kt*kmp)*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f_ssf= horzcat(f1,f2,f3);

% save 
save input_data_sine_s_fast

clear all; 
close all; 
clc;



