%file data_steps: use the step response data to vefify the ratio between
%the stiffness of the springs. compute a new estimation for the
%voltage-to-force coeff. 

clear all; 
close all; 
clc;
% load data
load input_data_steps

%% plot input data
figure
plot(t,v)
xlabel('t (s)');ylabel('volt (V)');
grid
title('voltage data steps')

%% plot output data
figure
plot(t,x1_s,t,x2_s,t,x3_s)
xlabel('t (s)');ylabel('x (m)');
grid
title('displacement data steps')
legend('x1(t)','x2(t)','x3(t)')
%% compute displacemnt staty state 
%intervallo stady state assunto è dal tempo t=2+(10*n)[s] fino a t=4+(10*n)[s] 
% (10*n) indica la ripetizione con n=1..3
Ts=0.005;
% time_sample=N_sample*Ts quindi 
%N_sample= time_sample/Ts 

for n=0:3
    x_stady_state(1,1) = mean(x1_s( ((2+(10*n))/Ts ):( ((4+(10*n))/Ts) )));
    x_stady_state(1,2) = mean(x2_s( ((2+(10*n))/Ts ):( ((4+(10*n))/Ts) )));
    x_stady_state(1,3) = mean(x3_s( ((2+(10*n))/Ts ):( ((4+(10*n))/Ts) )));
end

%dati staty state
v_stady_state = 0.5 %[V];
%assumiamo k3 nominale come corretto
k3=400;

% partendo dall'eq in stady state quindi 
%[K]x = g_v * V  allora

% [ x1;          [ (1+k3/k2+k3/k1)*g_v;
%   x2; * k3/v =   (1+k3/k2)*g_v;
%   x3 ]                  g_v            ];

%                 [ (1+K32+K31)*g_v;
%   H           =   (1+K32)*g_v;
%                        g_v            ];    

H = x_stady_state*k3/v_stady_state;

% force-to-voltage coeff
g_v = H(3); 
g_v_nom = (ka*kmp*kt);
%% k3/k2
%syms k32
%K32_exp = double(solve (H(2) == g_v + (g_v*k32), k32 ) );
K32_exp = (H(2)-g_v)/g_v; 
% k3/k1
%syms k31
%K31_exp = solve (H(1) == g_v + g_v*K32_exp + g_v*k31,k31 ) ;
K31_exp = H(1)/g_v - K32_exp -1 ;

%compute nomial ratio 
k1=800; %N/m
k2=800;

K32_nom = k3/k2;
K31_nom = k3/k1;

% compute error percent
e31 = abs(((K31_exp - K31_nom) / K31_nom)*100);
e32 = abs(((K32_exp - K32_nom) / K32_nom)*100);
eg_v = abs(((g_v - g_v_nom) / g_v_nom)*100);

