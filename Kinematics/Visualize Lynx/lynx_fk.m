function [ pos ] = lynx_fk( t1, t2, t3, t4, t5, g )


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
    
    
    
    %four end points
    
    A6 = [1,0, 0,  g/2
      0, 1, 0,  0
        0,        0, 1, 0
        0,        0, 0,     1];
    A7 = [1, 0, 0,  -g/2
      0, 1, 0,  0
        0,        0, 1, 0
        0,        0, 0,     1];
    A8 = [ 1, 0, 0,  g/2
      0,  1, 0,  0
        0,        0, 1, 1.125
        0,        0, 0,     1];
    A9 = [ 1, 0, 0,  -g/2
      0, 1, 0,  0
        0,        0, 1, 1.125
        0,        0, 0,     1];


T1=A1(1:3,4);
T0=T1-[0;0;3];
t2=A1*A2;

T2=t2(1:3,4);

t3=A1*A2*A3;
T3=t3(1:3,4);

t4=t3*A4;
T4=t4(1:3,4);

t5=t4*A5;
T5=t5(1:3,4);

%end point mupltiply by t5 individually
t6=t5*A6;
T6=t6(1:3,4);

t7=t5*A7;
T7=t7(1:3,4);

t8=t5*A8;
T8=t8(1:3,4);

t9=t5*A9;
T9=t9(1:3,4);


pos=[T0';T1';T2';T3';T4';T5';T6';T7';T8';T9'];


end
