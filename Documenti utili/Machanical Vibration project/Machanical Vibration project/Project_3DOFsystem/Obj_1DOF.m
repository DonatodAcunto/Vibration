function [E] = Obj_1DOF(P)

global zeta x1_N t_N;

c = P(1);
m = P(2);

o_n= c/(2*zeta*m);

X_0=P(3);
phi=zeros(length(t_N));


x = X_0*exp(-zeta*o_n*t_N).*sin(o_n*sqrt(1-zeta^2)*t_N)

%error
E=0;

for i=1:length(t_N)
    E=E+(x1_N(i) - x(i))^2
end

end