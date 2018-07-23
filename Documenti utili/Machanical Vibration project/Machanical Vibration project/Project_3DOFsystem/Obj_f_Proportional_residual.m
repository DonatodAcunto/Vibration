
function [E] = Obj_f_Proportional_residual(P)

global v t x1_disp x2_disp x3_disp;


% transfer function 
m1=P(1); %kg
m2=P(2);
m3=P(3);

k1=800; %N/m
k2=800;
k3=400;

s = tf('s');
%Mass Matrix
M=[m1 0 0;
    0 m2 0;
    0 0 m3];
%Stiffness Matrix
K=[k1 -k1 0;
    -k1 k1+k2 -k2;
    0 -k2 k2+k3];
%proportional Damping Matrix
alpha=P(4);  %N/s
beta=P(5);

C = alpha*M + beta*K;

D=M*s^2+C*s+K;

G = inv(D);

% force 
ka=2;% [A/V]
kt=0.1; %[Nm/A]
kmp=26.25; %[1/m]
g_v= P(6);
f1=(ka*kt*kmp)*g_v*v; %N
f2= zeros(size(f1));
f3= zeros(size(f1));
f= horzcat(f1,f2,f3);

X_sim = lsim(G,f,t);

%error
e1=0;
e2=0;
e3=0;
for i=1:length(t)
    e1=e1+(x1_disp(i) - X_sim(i,1))^2;
    e2=e2+(x2_disp(i) - X_sim(i,2))^2;
    e3=e3+(x3_disp(i) - X_sim(i,3))^2;
end

E =rms(e1+e2+e3);

end