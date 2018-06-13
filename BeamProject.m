clc;
clear all;
close all;

%% Mechanical Vibration Project
%% ======= LATERAL VIBRATIONS OF A BEAM =======
% Data:
% Young Modulus E
E = 206;    % GPa
% Mass Density
d = 7850;   % kg/m^3
% Area of the beam cross-section
A = 111;    % mm^2
% Moment of inertia of the beam cross-section
J = 6370    % mm^4
% Length of the beam 
L = 0.7     % m
% Damping ratio values 
csi_1 = 0.05;
csi_2 = 0.01;
csi_3 = 0.01;
csi_4 = 0.01;

