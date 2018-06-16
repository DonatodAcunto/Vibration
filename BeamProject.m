clc;
clear all;
close all;

%% Mechanical Vibration Project
%% ======= LATERAL VIBRATIONS OF A BEAM =======
% Data:
E = 206;    %  Young Modulus E:GPa
rho = 7850; %Mass Density: kg/m^3
A = 111;    %Area of the beam cross-section: mm^2
J = 6370;   % Moment of inertia of the beam cross-section, mm^4 (da verificare, secondo me bisogna trovare la I dividendo ulteriormente per l'area
L = 0.7;    %Length of the beam:m

% Damping ratio values 
csi_1 = 0.05;
csi_2 = 0.01;
csi_3 = 0.01;
csi_4 = 0.01;
% Sound velocity in the Material
c = rad((E*J)/(rho*A));
%IC
%w(0,t)=0,w(l,t)=0
%EI * d²w(0,t)=0,EI * d²w(l,t)=0
% Ci ho provato 
beta = @(omega) rad(omega/c);
alpha =  @(omega) -(cos(beta*L)- cosh(beta*L))/(sin(beta*L)-sinh(beta*L));

C2 = @(C1) alpha * C1;
w = @(x) C1*(cos(beta*x) - cosh(beta*x)) + C2 * (sin(beta * x) - sinh(beta*x));
q = @(t, omega_n) A*cos(omega_n*t) + B*sin(omega_n*t);

%% Trovate le costanti c1n e c2n per i 4 modi si può procedere a trovare W(x,t) 
% e di conseguenza trovare le frequenze naturali per i primi 4 modi e
% quindi plottare

%% Matrix form


