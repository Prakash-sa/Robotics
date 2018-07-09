syms a c d e single;
q=[a, 0,1/(2^0.5),1/(2^0.5)];
r=[2/3 c 1/2^0.5
    1/3 d 0
    2/3 e -1/2^0.5];
q=rotm2quat(r);
r=quat2rotm(q);
disp(a,c,d,e);