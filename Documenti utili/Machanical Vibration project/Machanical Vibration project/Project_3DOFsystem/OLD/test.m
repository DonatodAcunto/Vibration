%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; 
close all; 
clc;
%% Load data

load data_steps;
%load data_sine_sweep_slow;
%load data_impulses;

%% plot data
%plot voltage
figure
plot(t,v,'LineWidth',1.5)
xlabel('t (s)');ylabel('v (v)');
grid
title('voltage')

% plot count data
figure
plot(t,x1,t,x2,t,x3)
xlabel('t (s)');ylabel('x (m)');
grid
title('count data')

%% converision encoder to displacement 
x1_disp = (0.0706/16000)*x1;
x2_disp = (0.0706/16000)*x2;
x3_disp = (0.0706/16000)*x3;

% plot output data
figure
plot(t,x1_disp,t,x2_disp,t,x3_disp)
xlabel('t (s)');ylabel('x (m)');
grid
title('displacement')

%% data
opt=[1.56483445633787 1.46129302395633 1.14572039215691 2.92303836642247 1.80534485104446 2.00428483595999 0.000574920346837634 0.000860953021574664 6.1456];

%force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=26.25 %[1/m]
g_v= opt(9);
f1=(ka*kt*kmp)*g_v*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));

f= horzcat(f1,f2,f3);

figure
plot(t,f1,'LineWidth',1.5)
xlabel('t (s)');ylabel('force (N)');
grid
title('force')

%% transfer function 
m1=opt(1,1); %kg
m2=opt(1,2);
m3=opt(1,3);

k1=774; %N/m
k2=770;
k3=396;

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

X = lsim(G,f,t);

%% plot output data
figure
plot(t,x1_disp,t,X(:,1))
xlabel('t (s)');ylabel('x (m)');
grid
title('comparision')

%% compare
cost_func = 'NRMSE';
fit = goodnessOfFit(X(:,1),x1_disp,cost_func);
%%
g_dc = K\[g_v; 0; 0]