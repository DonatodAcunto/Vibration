clear all; 
close all; 
clc;

% Load data
load input_data_impulses;

%% FREE DAMPING 
load opt_data_impulses
opt_f=opt;
%opt_f= [m1,m2,m3,c1,c2,c3,c12,c23,g_v

m1=opt_f(1);
m2=opt_f(2);
m3=opt_f(3);
g_v_f=opt_f(9);

%Mass Matrix
M_f=[m1 0 0;
    0 m2 0;
    0 0 m3];

%Stiffness Matrix
K_f=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];

%% PROPORTIONAL DAMPING 
load opt_data_impulses_prop
opt_p=opt;
%opt_p = [m1,m2,m3,alpha,beta,g_v];

m1=opt_p(1);
m2=opt_p(2);
m3=opt_p(3);

g_v_p=opt_p(6);

%Mass Matrix
M_p=[m1 0 0;
    0 m2 0;
    0 0 m3];

%Stiffness Matrix
K_p=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];


%% Eigen value problem 
 
%U= MODAL MATRIX
%O= Eigenvalue MATRIX ovvero le radici del problema o=w^2
%dove w sono le frequenze di risonanza

[U_f,O_f] = eig(K_f,M_f); %free damp
[U_p,O_p] = eig(K_p,M_p); %prop damp

U1_e_f=U_f(:,1)/U_f(1,1);
U2_e_f=U_f(:,2)/U_f(1,2);
U3_e_f=U_f(:,3)/U_f(1,3);

U1_e_p=U_p(:,1)/U_p(1,1);
U2_e_p=U_p(:,2)/U_p(1,2);
U3_e_p=U_p(:,3)/U_p(1,3);

%results 
display 'EIGEN VALUE RESULTS'
display 'free damped'
U_eig_f=[U1_e_f,U2_e_f,U3_e_f]
w_eig_f=sqrt(O_f)
display 'proportional damped'
U_eig_p=[U1_e_p,U2_e_p,U3_e_p]
w_eig_p=sqrt(O_p)


%% RAILEIGHT Quotient
display 'RAILEIGHT'
%free damped
syms alpha beta

R_q = ( [1; alpha; beta].' * K_f * [1; alpha; beta] )  /  ( [1; alpha; beta].' * M_f * [1; alpha; beta] );

D1R_q = diff(R_q,alpha);
D2R_q = diff(R_q,beta);

assume(alpha, 'real');
assume(beta, 'real');
%solve the equation 
sol = vpasolve([ D1R_q == 0, D2R_q==0],[alpha beta]);

%recostruction MODAL MATRIX
display 'free damping'
U_Ray_f = double([ [1 sol.alpha(1) sol.beta(1) ].' ...
                    [1 sol.alpha(2) sol.beta(2) ].' ...
                    [1 sol.alpha(3) sol.beta(3) ].'])

%ricalcolo quoziente di Raleyght 
fun_R_q = @(aaa,bbb) ( [1; aaa; bbb].' * K_f * [1; aaa; bbb] )  /  ( [1; aaa; bbb].' * M_f * [1; aaa; bbb] ) ;

%quindi le freq di risonaza w 
for i = 1:3
    w_RAY_f(i)     = sqrt(fun_R_q(U_Ray_f(2,i),U_Ray_f(3,i)))  ;        
end
w_RAY_f

%proportional damped-------------------------------------------------------------------------------------------
syms alpha beta

R_q_p = ( [1; alpha; beta].' * K_p * [1; alpha; beta] )  /  ( [1; alpha; beta].' * M_p * [1; alpha; beta] );

D1R_q_p = diff(R_q_p,alpha);
D2R_q_p = diff(R_q_p,beta);

assume(alpha, 'real');
assume(beta, 'real');
%solve the equation 
sol_p = vpasolve([ D1R_q_p == 0, D2R_q_p==0],[alpha beta]);

%recostruction MODAL MATRIX
display 'proporional damping'
U_Ray_p = double([ [1 sol_p.alpha(1) sol_p.beta(1) ].' ...
                    [1 sol_p.alpha(2) sol_p.beta(2) ].' ...
                    [1 sol_p.alpha(3) sol_p.beta(3) ].'])

%ricalcolo quoziente di Raleyght 
fun_R_q_p = @(aaa,bbb) ( [1; aaa; bbb].' * K_p * [1; aaa; bbb] )  /  ( [1; aaa; bbb].' * M_p * [1; aaa; bbb] ) ;

%quindi le freq di risonaza w 
for i = 1:3
    w_RAY_p(i)     = sqrt(fun_R_q_p(U_Ray_p(2,i),U_Ray_p(3,i)))  ;        
end
w_RAY_p

% Raileight quotient to plot
%verificare che la prima e l'ultima frequenza siano rispettivamente il
%massimo e il minimo della superficie alpha-beta
R_q_plot = @(x,y) ( [1; x; y].' * K_f * [1; x; y] )  /  ( [1; x; y].' * M_f * [1; x; y] ) ;

figure(1);
fcontour(R_q_plot,[-3 3 -2.5 2.5],'LevelList',[logspace(-3,6,300)]); 
hold on;
grid minor;
    xlabel('$\alpha$','interpreter','latex');
    ylabel('$\beta$','interpreter','latex')
    
figure(1); h = plot(U_Ray_f(2,1),U_Ray_f(3,1),'+',U_Ray_f(2,2),U_Ray_f(3,2),'X',U_Ray_f(2,3),U_Ray_f(3,3),'*');
set(h,'MarkerSize',14);
set(h,'linewidth',2);
hold off;

%% Matrix Iteration Method
display 'MATRIX ITERATION METHOD'

display 'free damping'
Matrix_iteration_method(50,K_f,M_f);

display 'proportional damping'
Matrix_iteration_method(50,K_p,M_p);

