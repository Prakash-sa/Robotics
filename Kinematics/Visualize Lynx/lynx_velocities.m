clear all;
clc

thetas=[pi/2,-pi/2,pi/2,pi/3,pi/2];
thetadot=[.1,.3,.2,-.1,.6];
%thetas=[0 -2.0943951023932 3.14159265358979 1.5707963267949 -3.14159265358979];
%thetadot=[0.9 -0.6 -0.2 0.1 -0.3];
%LYNX_VELOCITIES The input to the function will be:
%    thetas: The joint angles of the robot in radians - 1x5 matrix
%    thetadot: The rate of change of joint angles of the robot in radians/sec - 1x5 matrix
%    The output has 2 parts:
%    v05 - The linear velocity of frame 5 with respect to frame 0, expressed in frame 0.
%    w05 - The angular velocity of frame 5 with respect to frame 0, expressed in frame 0.
%    They are both 1x3 matrices of the form [x y z] for a vector xi + yj + zk

    %% YOUR CODE GOES HERE
    t1=thetas(1);t2=thetas(2);t3=thetas(3);t4=thetas(4);t5=thetas(5);
   A1 = [ cos(t1),  0, -sin(t1), 0
 sin(t1),  0,  cos(t1), 0
       0, -1,        0, 3
       0,  0,        0, 1];

A2 = [  sin(t2), cos(t2), 0, 5.75*sin(t2)
 -cos(t2), sin(t2), 0, -5.75*cos(t2)
        0,       0, 1,   0
        0,       0, 0,   1];

A3 = [ -sin(t3), -cos(t3), 0, -7.375*sin(t3 )
  cos(t3), -sin(t3), 0, 7.375*cos(t3)
        0,        0, 1,  0
        0,        0, 0,   1];

A4 = [  sin(t4),  0, cos(t4), 0
 -cos(t4),  0, sin(t4), 0
        0, -1,       0, 0
        0,  0,       0, 1];
 
 
A5 = [ cos(t5), -sin(t5), 0,  0
      sin(t5),  cos(t5), 0,  0
        0,        0, 1, 3
        0,        0, 0,     1];
    

T01=A1;
T02=T01*A2;
T03=T02*A3;
T04=T03*A4;
T05=T04*A5;
Z0=[0;0;1];
P0=[0;0;0];
Z1=T01(1:3,3);
Z2=T02(1:3,3);
Z3=T03(1:3,3);
Z4=T04(1:3,3);
P1=T01(1:3,4);
P2=T02(1:3,4);
P3=T03(1:3,4);
P4=T04(1:3,4);
P5=T05(1:3,4);    

w1=Z0*thetadot(1);
w2=Z1*thetadot(2);
w3=Z2*thetadot(3);
w4=Z3*thetadot(4);
w5=Z4*thetadot(5);

%{
d1=T05;
d2=A2*A3*A4*A5;
d3=A3*A4*A5;
d4=A4*A5;
d5=A5;

P05=T01(1:3,1:3)*d1(1:3,4);
P15=T02(1:3,1:3)*d2(1:3,4);
P25=T03(1:3,1:3)*d3(1:3,4);
P35=T04(1:3,1:3)*d4(1:3,4);
P45=T05(1:3,1:3)*d5(1:3,4);


JV1=cross(Z0,P05);
JV2=cross(Z1,P15);
JV3=cross(Z2,P25);
JV4=cross(Z3,P35);
JV5=cross(Z4,P45);


jv=[JV1 JV2 JV3 JV4 JV5];
th=[thetadot(1)
    thetadot(2)
    thetadot(3)
    thetadot(4)
    thetadot(5)];

v=jv*th;
%}

d1=diff(T05,t1)*thetadot(1);

d2=diff(T05,t2)*thetadot(2);

d3=diff(T05,t3)*thetadot(3);

d4=diff(T05,t4)*thetadot(4);

d5=diff(T05,t5)*thetadot(5);

d_sum=d1+d2+d3+d4+d5;
invt=inv(A5)*inv(A4)*inv(A3)*inv(A2)*inv(A1);

v=d_sum*invt;






sumw=w1+w2+w3+w4+w5;

    %v05 = v5';
    w05 = sumw';
   % disp(v05);
    disp(w05)
    
v05=v';

    %{
  JV1=cross(w1,P1);
JV2=cross(w2,P2);
JV3=cross(w3,P3);
JV4=cross(w4,P4);
JV5=cross(w5,P5);
  sunv=JV1+JV2+JV3+JV4+JV5;
  v05=sunv';
  %}
    
