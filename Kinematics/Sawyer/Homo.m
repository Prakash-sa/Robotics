%Homogeneous transformation

syms a1 d1 d2 q1 q2

% provide your answer in terms of the symbolic variables above

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
    
    
%inverse homogenous

syms a1 d1 d2 q1 q2

% provide your answer in terms of the symbolic variables above

R = [ cos(q1)*cos(q2),  sin(q1), -cos(q1)*sin(q2) 
                                             
 cos(q2)*sin(q1), -cos(q1), -sin(q1)*sin(q2) 
                                             
     -sin(q2),        0,        -cos(q2)     ];


d=[a1*cos(q1) - d2*sin(q1)
   d2*cos(q1) + a1*sin(q1)
                     d1];


T20 = [R' , -R'*d
    [0 0 0],1];