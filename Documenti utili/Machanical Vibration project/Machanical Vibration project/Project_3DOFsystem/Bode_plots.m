
clear all; 
close all; 
clc;
% Load data
load input_data_impulses;

%FREE DAMPING 
load opt_data_impulses
opt_f=opt;
%opt_f= [m1,m2,m3,c1,c2,c3,c12,c23,g_v]

m1=opt_f(1);
m2=opt_f(2);
m3=opt_f(3);

c1=opt_f(4);  %N/s
c2=opt_f(5);
c3=opt_f(6);
c12=opt_f(7);
c23=opt_f(8);

g_v_f=opt_f(9);

%Mass Matrix
M_f=[m1 0 0;
    0 m2 0;
    0 0 m3];

%Stiffness Matrix
K_f=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];

%Damping Matrix
C_f= [+c1+c12   -c12        0;
      -c12  +c2+c12+c23     -c23;
        0        -c23      +c3+c23];
    
%% PPROPORTIONAL DAMPING 
load opt_data_impulses_prop
opt_p=opt;
%opt_p = [m1,m2,m3,alpha,beta,g_v];

m1=opt_p(1);
m2=opt_p(2);
m3=opt_p(3);

alpha=opt_p(4);  %N/s
beta=opt_p(5);

g_v_p=opt_p(6);

%Mass Matrix
M_p=[m1 0 0;
    0 m2 0;
    0 0 m3];

%Stiffness Matrix
K_p=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];

C_p = alpha*M_p + beta*K_p;
    
%% Transfert function plot

Ts=0.005;
s = tf('s');

%free damping
D_f=M_f*s^2+C_f*s+K_f;

G_f =g_v_f*inv(D_f);

%proportional damping
D_p=M_p*s^2+C_p*s+K_p;

G_p =g_v_p*inv(D_p);

%plot BODE DIAGRAM

h1 = bodeplot(G_f(:,1),G_p(:,1));
h2 = bodeplot(G_f(:,2),G_p(:,2));
h3 = bodeplot(G_f(:,3),G_p(:,3));
 