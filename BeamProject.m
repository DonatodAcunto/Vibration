clc;
clear all;
close all;

%% Mechanical Vibration Project
%% ======= LATERAL VIBRATIONS OF A BEAM =======
% Data:
E = 206;    %Young Modulus E:GPa
geometry.E=E;
rho = 7850; %Mass Density: kg/m^3
geometry.rho=rho;
A = 111;    %Area of the beam cross-section: mm^2
geometry.A=A;
I = 6370;   %Moment of inertia of the beam cross-section, mm^4 (da verificare, secondo me bisogna trovare la I dividendo ulteriormente per l'area
geometry.I=I;
L = 0.7;    %Length of the beam:m
geometry.L=L;

m=rho*A*L ; %mass of the beam
geometry.m=m;

geometry.y = linspace(0,geometry.L ,100); % number of discretisation points for the beam
% Damping ratio values 
csi_1 = 0.05;
csi_2 = 0.01;
csi_3 = 0.01;
csi_4 = 0.01;
% Sound velocity in the Material
c = sqrt((E*I)/(rho*A));
%IC
%w(0,t)=0,w(l,t)=0
%EI * d²w(0,t)=0,EI * d²w(l,t)=0

% Ci ho provato 
beta = @(omega) rad(omega/c);
alpha =  @(omega) -(cos(beta*L)- cosh(beta*L))/(sin(beta*L)-sinh(beta*L));

C2 = @(C1) alpha * C1;
w = @(x) C1*(cos(beta*x) - cosh(beta*x)) + C2 * (sin(beta * x) - sinh(beta*x));
q = @(t, omega_n) A*cos(omega_n*t) + B*sin(omega_n*t);

%Apply BC

%% Trovate le costanti c1n e c2n per i 4 modi si può procedere a trovare W(x,t) 
% e di conseguenza trovare le frequenze naturali per i primi 4 modi e
% quindi plottare

%% modal analysis: Case 1
% pinned-pinned
% Number of modes
Nmodes =4; % number of mode wanted

[phi,wn] = eigenModes(geometry,4);

figure
for ii=1:Nmodes,
    subplot(Nmodes,1,ii)
    box on;grid on
    plot(geometry.y,phi(ii,:));
    ylabel(['\phi_',num2str(ii)])
    title(['w_',num2str(ii),' = ',num2str(wn(ii),3),' rad/s']); 
end
set(gcf,'color','w')
xlabel('y (m)');



