%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
%% Load data

load data_steps;
%load data_sine_sweep_slow;

%% plot input data
figure
plot(t,v,'LineWidth',1.5)
xlabel('t (s)');ylabel('v (v)');
grid
title('input')

%% plot output data
figure
plot(t,x1)
xlabel('t (s)');ylabel('x (m)');
grid
title('output')

%% converision encoder to displacement 
x1_spost = (0.0706/16000)*x1;

figure
plot(t,x1_spost)
xlabel('t (s)');ylabel('x (m)');
grid
title('output')

%% converision encoder to displacement 
time= t(2:end,:); %il tempo parte alla fine del primo intervallo 
%disp mass 1 
for i=2:length(x1)
    x1_disp(i-1,1)= ((x1(i)-x1(i-1))/16000)*0.0706; %[m] 
end
%disp mass 2 
for i=2:length(x2)
    x2_disp(i-1,1)= ((x2(i)-x2(i-1))/16000)*0.0706; %[m] 
end
%disp mass 3 
for i=2:length(x3)
    x3_disp(i-1,1)= ((x3(i)-x3(i-1))/16000)*0.0706; %[m] 
end

%% plot output data
figure
plot(time,x1_disp,time,x2_disp,time,x3_disp)
xlabel('t (s)');ylabel('x (m)');
grid
title('output')

%% force 
ka=2% [A/V]
kt=0.1 %[Nm/A]
kmp=1/26.25 %[1/m]

f1=(ka*kt*kmp)*v*10; %N
f2= zeros(size(f1));
f3= zeros(size(f1));

f= horzcat(f1,f2,f3);

figure
plot(t,f1,'LineWidth',1.5)
xlabel('t (s)');ylabel('force (N)');
grid
title('input force')

%% transfer function 
m1=2; %kg
m2=1;
m3=2;

k1=800; %N/m
k2=800;
k3=400;

c1=5;  %N/s
c2=5;
c3=5;

x_0=[1 0 0];

s = tf('s');
D = [m1*s^2+c1*s+k1     -k1                            0;
           -k1           m2*s^2+c2*s+k1+k2            -k2;
             0          -k2                m3*s^2+c3*s+k2+k3]
G=inv(D)

X = lsim(G,f,t,x_0);

%% plot output data
figure
plot(time,x1_disp,t,X(:,1))
xlabel('t (s)');ylabel('x (m)');
grid
title('output')



