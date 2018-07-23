%in order 

clear all; 
close all; 
clc;

load input_data_steps;


Ts=0.005;
x_stady_state(1,1) = x1_s(4/Ts);
x_stady_state(1,2) = x2_s(4/Ts);
x_stady_state(1,3) = x3_s(4/Ts);

f_stady_state = f1(4/Ts)

K1_staty_state= f_stady_state/x_stady_state(1,1)
K2_staty_state= f_stady_state/x_stady_state(1,2)
K3_staty_state= f_stady_state/x_stady_state(1,3)

%% firt 1DOF system 
load input_data_impulses;

figure
plot(t,x1_i)
xlabel('t (s)');ylabel('x (m)');
grid
title('x1')

%cut data time 4 [s]
t_N=t(1:3/Ts);
x1_N=x1_i(1:3/Ts);

figure
plot(t_N,x1_N)
xlabel('t (s)');ylabel('x (m)');
grid
title('x1')

%% Logharitm decrement 
findpeaks(x1_N,t_N)
[pks,locs] = findpeaks(x1_N,t_N)
% peak 2 and peak 5 
delta= log(pks(2)/pks(5))

zeta = delta/(sqrt(4*pi^2+delta^2))

%%
global zeta x1_N t_N;

P=[1,1,1];

%
A = [];
b = [];
Aeq = [];
beq = [];

lb = [-10,-10,-10];
ub = [10,10,10];

opt = fmincon(@Obj_1DOF,P,A,b,Aeq,beq,lb,ub)

%options = optimset('PlotFcns',@optimplotfval);
%opt = fminsearch(@Obj_1DOF,P,options);

%% control 

c = opt(1);
m = opt(2);

o_n= c/(2*zeta*m);

X_0=opt(3);
phi=zeros(length(t_N));


x_C = X_0*exp(-zeta*o_n*t_N).*sin(o_n*sqrt(1-zeta^2)*t_N);

figure
plot(t_N,x1_N,t_N,x_C)
xlabel('t (s)');ylabel('x (m)');
grid
title('x1')


