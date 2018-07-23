
function [U_MIM,w_MIM]=Matrix_iteration_method(n,K,M)

%definiamo la matrice 
D1 = K^-1*M;

% Empty arrays and matrices to store results in.
v1         = zeros(3,n);
lambda1    = zeros(1,n);
omega1     = zeros(1,n);
%first guess
v1(:,1)=[1;1;1];

% definiamo il vettore
for i=1:n
v1(:,i+1)=D1*v1(:,i);
lambda1(:,i) = v1(3,i+1)./v1(3,i) %for any row
omega1(:,i)=sqrt(1/lambda1(:,i));
end 

% 2nd Mode
syms a1;
tmp1 = a1.*v1(:,n);
A1 = vpasolve( transpose(tmp1)*M*tmp1 == 1, a1); %numeric solve
A1 = double(A1(2,1))

D2=D1-lambda1(n)*A1*v1(:,n)*A1*transpose(v1(:,n))*M;
 
% Empty arrays and matrices to store results in.
v2         = zeros(3,n);
lambda2    = zeros(1,n);
omega2    = zeros(1,n);
%first guess
v2(:,1)=[1;1;1];

for i=1:n
v2(:,i+1)=D2*v2(:,i);
lambda2(:,i) = v2(3,i+1)./v2(3,i); %for any row
omega2(:,i)=sqrt(1/lambda2(:,i));
end 

% 3nd Mode
%Normalized mass matrix respect eigenvectors
syms a2;
tmp2 = a2.*v2(:,n);
A2 = vpasolve( transpose(tmp2)*M*tmp2 == 1, a2); %numeric solve 
A2 = double(A2(2,1));

D3=D2-lambda2(n)*A2*v2(:,n)*A2*transpose(v2(:,n))*M;
 
% Empty arrays and matrices to store results in.
v3         = zeros(3,n);
lambda3    = zeros(1,n);
omega3    = zeros(1,n);
%first guess
v3(:,1)=[1;1;1];

for i=1:n
v3(:,i+1)=D3*v3(:,i);
lambda3(:,i) = v3(3,i+1)./v3(3,i); %for any row
omega3(:,i)=sqrt(1/lambda3(:,i));
end 

syms a3;
tmp3 = a3.*v3(:,n);
A3 = vpasolve( transpose(tmp3)*M*tmp3 == 1, a3);
A3 = double(A3(2,1));
 
% Results
U1t = A1*v1(:,n);
U1 = U1t/U1t(1,1);
 
U2t = A2*v2(:,n);
U2 = U2t/U2t(1,1);
 
U3t = A3*v3(:,n);
U3 = U3t/U3t(1,1);

U_MIM  = [U1, U2, U3]

w_MIM= [omega1(:,n),omega2(:,n),omega3(:,n)]

end