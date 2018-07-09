%{
r - the length of the common normal
alpha - angle about common normal from old z to new z
d - offset along previous z to the common normal
theta - angle about previous z, from old x to new x
%}


function A = dhrun(r, alpha, d, theta)
Rq=eye(4,4);
Rq(1:2,1:2)=[cos(theta),-sin(theta);sin(theta),cos(theta)];
trd=eye(4,4);
trd(3,4)=d;
tra=eye(4,4);
tra(1,4)=r;
rw=eye(4,4);
rw(2:3,2:3)=[cos(alpha) -sin(alpha);sin(alpha) cos(alpha)];
A=Rq*trd*tra*rw;

    
end