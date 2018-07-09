function [ v05, w05 ] = PUMA( thetas, thetadot )
%LYNX_VELOCITIES The input to the function will be:
%    thetas: The joint angles of the robot in radians - 1x5 matrix
%    thetadot: The rate of change of joint angles of the robot in radians/sec - 1x5 matrix
%    The output has 2 parts:
%    v05 - The linear velocity of frame 5 with respect to frame 0, expressed in frame 0.
%    w05 - The angular velocity of frame 5 with respect to frame 0, expressed in frame 0.
%    They are both 1x3 matrices of the form [x y z] for a vector xi + yj + zk

    %% YOUR CODE GOES HERE
    
    %{
    [v06, w06] = PUMA([pi/2,-pi/2,pi/4,-pi/6,pi/8,-pi/3],[.1,-.2,.3,.1,.4,-.6])

v06 =

-1.0495 -3.8056 0.9994

w06 =

0.5612   -0.3221   -0.2204
    
    
    
    puma_velocities([-3.14159265358979 -2.61799387799149 -0.523598775598299 2.0943951023932 0.523598775598299 -2.61799387799149], [0.3 0.1 0.9 -0.6 -0.6 -0.6])
    v06 =

  -10.6889    1.5160   -2.0678


w06 =

   -0.6696    1.0402    1.4196

    %}
    
    
    
    
    t1=thetas(1);t2=thetas(2);t3=thetas(3);t4=thetas(4);t5=thetas(5);t6=thetas(6);
 A1 =[ cos(t1), 0,  sin(t1),  0
 sin(t1), 0, -cos(t1),  0
       0, 1,        0, 13
       0, 0,        0,  1];
 
A2 =[ -cos(t2),  sin(t2), 0, -8*cos(t2)
 -sin(t2), -cos(t2), 0, -8*sin(t2)
        0,        0, 1,       -2.5
        0,        0, 0,          1];
 
    
A3 =[ -cos(t3),  0,  sin(t3),    0
 -sin(t3),  0, -cos(t3),    0
        0, -1,        0, -2.5
        0,  0,        0,    1];
 
A4 =[ cos(t4), 0,  sin(t4), 0
 sin(t4), 0, -cos(t4), 0
       0, 1,        0, 8
       0, 0,        0, 1];
  
 
A5 =[ cos(t5),  0, -sin(t5), 0
 sin(t5),  0,  cos(t5), 0
       0, -1,        0, 0
       0,  0,        0, 1];
 
 
A6 =[ cos(t6), -sin(t6), 0,   0
 sin(t6),  cos(t6), 0,   0
       0,        0, 1, 2.5
       0,        0, 0,   1];


T01=A1;
T02=T01*A2;
T03=T02*A3;
T04=T03*A4;
T05=T04*A5;
T06=T05*A6;
Z0=[0;0;1];
P0=[0;0;0];
Z1=T01(1:3,3);
Z2=T02(1:3,3);
Z3=T03(1:3,3);
Z4=T04(1:3,3);
Z5=T05(1:3,3);
P1=T01(1:3,4);
P2=T02(1:3,4);
P3=T03(1:3,4);
P4=T04(1:3,4);
P5=T05(1:3,4);
P6=T06(1:3,4);                                                        


w1=Z0*thetadot(1);
w2=Z1*thetadot(2);
w3=Z2*thetadot(3);
w4=Z3*thetadot(4);
w5=Z4*thetadot(5);
w6=Z5*thetadot(6);

JV1=cross(Z1,P6-P1);
JV2=cross(Z2,P6-P2);
JV3=cross(Z3,P6-P3);
JV4=cross(Z4,P6-P4);
JV5=cross(Z5,P6-P4);
JV6=cross(Z0,P6-P0);
  
J=[JV6(1),JV1(1),JV2(1),JV3(1),JV4(1),JV5(1)
    JV6(2),JV1(2),JV2(2),JV3(2),JV4(2),JV5(2)
    JV6(3),JV1(3),JV2(3),JV3(3),JV4(3),JV5(3)];

v5=J*thetadot';
v06=v5';

sumw=w1+w2+w3+w4+w5+w6;

    
    w05 = sumw';
    disp(v05)
    disp(w05)
end