clear all;


% rand(3,1) generates a random 3 by one column vector. We use this u to plot
u=rand(3,1)*2-1;

% plot the origin
plot3(0,0,0,'.k')

% axis setting
axis vis3d
axis off

%%%%% your code starts here %%%%%
% generate a random rotation matrix R
a=pi*randn;
c1=cos(a);
s1=sin(a);
R=[c1 -s1 0;s1 c1 0; 0 0 1];

hold on
% plot the x axis 
plot3([0,1],[0,0],[0,0],'r');
text(1,0,0,'x')
hold on
% plot the y axis 
plot3([0,0],[0,1],[0,0],'g');
text(0,1,0,'y')
hold on
% plot the z axis 
plot3([0,0],[0,0],[0,1],'b');
text(0,0,1,'z')
ut='areu';
u1=u(1);
u2=u(2);
u3=u(3);

% plot the original vector u
hold on;
plot3([0,u(1)],[0,u(2)],[0,u(3)],'--k')
text(String,['(',num2str(u1,'%.3f'),',',num2str(u2,'%.3f'),',',num2str(u3,'%.3f'),')'],ut);


% apply rotation and calcuate v plot the vector after rotation v
v=R*u;

hold on;
% plot the new vector v
plot3([0,v(1)],[0,v(2)],[0,v(3)],':k')

%%%%% your code ends here %%%%%