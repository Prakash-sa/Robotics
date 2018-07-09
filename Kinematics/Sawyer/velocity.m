% qd1 and qd2 are the time derivatives of q1 and q2 respectively
syms a1 d1 d2 q1 q2 c1 c2 c3 qd1 qd2 real

%{
a1 = 81; % mm
d1 = 317; % mm
d2 = 193; % mm
q1 = 0; % rad
q2 = 3*pi/2; % rad
c1 = 75; % mm
c2 = 50; % mm
c3 = 50; % mm
qd1 = 1; % rad / s
qd2 = 1; % rad / s

%}
% provide your answer in terms of the above syms
T01 =[ cos(q1),  0, -sin(q1), a1*cos(q1)
 sin(q1),  0,  cos(q1), a1*sin(q1)
       0, -1,        0,         d1
       0,  0,        0,          1];

T12 =[ cos(q2),  0, -sin(q2),  0
 sin(q2),  0,  cos(q2),  0
       0, -1,        0, d2
       0,  0,        0,  1];

T02 =[ cos(q1)*cos(q2),  sin(q1), -cos(q1)*sin(q2), a1*cos(q1) - d2*sin(q1) 
                                                                      
 cos(q2)*sin(q1), -cos(q1), -sin(q1)*sin(q2), d2*cos(q1) + a1*sin(q1) 
                                                                      
     -sin(q2),        0,        -cos(q2),                d1           
                                                                      
        0,            0,            0,                   1            ];
    
    z0=[0;0;1];
    z1=T01(1:3,3);
    z2=T02(1:3,3);
    p0=[0;0;0];
    p11=T01(1:3,4);
    p2=T02(1:3,4);
    p1 = [a1*cos(q1)-c1*sin(q1)
        c1*cos(q1)-a1*sin(q1)
            d1];

       
       p23=[a1*cos(q1) - d2*sin(q1)+c2
 d2*cos(q1) + a1*sin(q1)+c3
                      d1];
    
    w1=z0*qd1;
    w2=z1*qd2;
    
    p2d1=diff(p23);
    
    p2d=p2d1;
    vp22=p2d*q2;
    %{
    R=T02(1:3,1:3);
    rd1=diff(R,q1);
    rd2=diff(R,q2);
    Rd=rd1+rd2;
    rr=[c2;c3;0];
    v3=Rd*rr;
    %}
    
    p2d=diff(p2,q1);
    v5=p2d*qd1;
    
    
    %vp1 is correct 
    
    vp1=cross(w1,p1-p0);
    v2=cross(w2,p23);
    vp2=vp1+v2;
    
    
    disp(vp1);
    disp(vp2);