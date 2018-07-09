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



v1=[-qd1*(c1*cos(q1) - a1*sin(q1))
  qd1*(a1*cos(q1) - c1*sin(q1))
                              0];
h=[ -qd1*(d2*cos(q1) + a1*sin(q1))
  qd1*(a1*cos(q1) - d2*sin(q1))
                              0];
                                     
        p=[-25;40;50];                             
        disp(v1)                      
        disp(h+v1-p)