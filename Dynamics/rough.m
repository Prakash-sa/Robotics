clear all;
clc


syms d11 d12 d21 d22 c121 c211 c221 c112 g1 g2 tau1 tau2 x1 x2 x3 x4 real


a=d11;b=d12;l=d21;m=d22;
c=tau1-g1-c221*x4^2-(c121+c211)*x3*x4;

n=tau2-g2-c112*x2^2;


f1=-(b*n - c*m)/(a*m - b*l);


f2=(a*n - c*l)/(a*m - b*l);

f_x_tau = [x2,x4
    f1,f2];
disp(f_x_tau)