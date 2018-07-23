
%file data_impulses.mat : use the impulse response to identify the
%parameters. if choose response to impulsive force, due to the
%approximation of the force estimation, you can consider the
%voltage-to-force coefficient as one of the parameters to be estimeted.

% file request: error.m , input_data_impulses
clear all; 
close all; 
clc;
% Load data
load input_data_impulses;

%% plot input data
figure
plot(t,v)
xlabel('t (s)');ylabel('volt (V)');
grid
title('voltage data steps')

%% set up
%visto che utilizzo solo i dati impulsivi settiamo come variabili globali
global v t x1_disp x2_disp x3_disp;

x1_disp = x1_i ;
x2_disp = x2_i ;
x3_disp = x3_i ;

%% First test with first guest parameters 

% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
g_v=1.2;
f1=(ka*kt*kmp)*g_v*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f= horzcat(f1,f2,f3);

figure(1)
plot(t,f1,'LineWidth',1.5)
xlabel('t (s)');ylabel('force (N)');
grid
title('force')

%% transfer function 
m1=1; %kg
m2=1;
m3=1;

k1=800; %N/m
k2=800;
k3=400;

c1=2;  %N/s
c2=2;
c3=2;
c12=0.1
c23=0.1

Ts=0.005;

s = tf('s');
%Mass Matrix
M=[m1 0 0;
    0 m2 0;
    0 0 m3];
%Damping Matrix
C = [+c1+c12   -c12        0;
      -c12  +c2+c12+c23     -c23;
        0        -c23      +c3+c23];
%Stiffness Matrix
K=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];

D=M*s^2+C*s+K;

%D = [m1*s^2+c1*s+k1     -k1                            0;
%           -k1           m2*s^2+c2*s+k1+k2            -k2;
%            0          -k2                m3*s^2+c3*s+k2+k3]

G = inv(D)

X = lsim(G,f,t);

% plot output data
figure(1)
plot(t,x1_disp,t,X(:,1))
xlabel('t (s)');ylabel('x (m)');
grid
title('comparision')

% compare
cost_func = 'NRMSE';
fit = goodnessOfFit(X(:,1),x1_disp,cost_func);

%% optimatization
P = [1.5 1.5 1.5 1 2 2 0.001 0.001 6];
%P = [m1,m2,m3,c1,c2,c3,c12,c23,g_v];

%options = optimset('PlotFcns',@optimplotfval);
%opt = fminsearch(@Obj_f_residual,P,options);

A = [];
b = [];
Aeq = [];
beq = [];

lb = [0,0,0,0,0,0,0,0,0];
ub = [2,2,2,5,5,5,5,5,7];

opt = fmincon(@Obj_f_residual,P,A,b,Aeq,beq,lb,ub)

%% control 
% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
g_v= opt(1,9);
f1=(ka*kt*kmp)*g_v*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));

f= horzcat(f1,f2,f3);

% transfer function 
m1=opt(1,1); %kg
m2=opt(1,2);
m3=opt(1,3);

c1=opt(1,4);  %N/s
c2=opt(1,5);
c3=opt(1,6);
c12=opt(1,7);
c23=opt(1,8);

Ts=0.005;

s = tf('s');
%Mass Matrix
M=[m1 0 0;
    0 m2 0;
    0 0 m3];
%Damping Matrix
C = [+c1+c12   -c12        0;
      -c12  +c2+c12+c23     -c23;
        0        -c23      +c3+c23];
%Stiffness Matrix
K=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];

D=M*s^2+C*s+K;

%D = [m1*s^2+c1*s+k1     -k1                            0;
%           -k1           m2*s^2+c2*s+k1+k2            -k2;
%            0          -k2                m3*s^2+c3*s+k2+k3]

G = inv(D)

X_opt = lsim(G,f,t);
%% compare
cost_func = 'NRMSE';
fit_opt1 = goodnessOfFit(X_opt(:,1),x1_disp,cost_func);
fit_opt2 = goodnessOfFit(X_opt(:,2),x2_disp,cost_func);
fit_opt3 = goodnessOfFit(X_opt(:,3),x3_disp,cost_func);

% plot output data
figure
plot(t,x1_disp,t,X_opt(:,1))
xlabel('t (s)');ylabel('x1 (m)');
grid
title('comparision opt x1')

figure
plot(t,x2_disp,t,X_opt(:,2))
xlabel('t (s)');ylabel('x2 (m)');
grid
title('comparision opt x2')

figure
plot(t,x3_disp,t,X_opt(:,3))
xlabel('t (s)');ylabel('x3 (m)');
grid
title('comparision opt x3')

%save data 
save('opt_data_impulses.mat', 'opt' )
%P = [m1,m2,m3,c1,c2,c3,c12,c23,g_v]
