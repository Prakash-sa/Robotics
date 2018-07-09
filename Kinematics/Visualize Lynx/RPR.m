
close all
pause on;  % Set this to on if you want to watch the animation
GraphingTimeDelay = 0.05; % The length of time that Matlab should pause between positions when graphing, if at all, in seconds.
totalTimeSteps = 100; % Number of steps in the animation

% Generate the starting and final joint angles, and gripper distance
% Set values manually, or randomise as shown below
q01 = 0;
q02 = 5;
q03 = 0;
q04 = 0;
q05 = 0;
g0 = 2;

q11 = 0;
q12 = 5;
q13 = 0;
q14 = 0;
q15 = 0;
g1 = 0;

% Use below code if you want to randomise
% q01 = rand(1) * 2 * pi;
% q02 = rand(1) * 2 * pi;
% q03 = rand(1) * 2 * pi;
% q04 = rand(1) * 2 * pi;
% q05 = rand(1) * 2 * pi;
% g0 = rand(1) * 2;
% 
% q11 = rand(1) * 2 * pi;
% q12 = rand(1) * 2 * pi;
% q13 = rand(1) * 2 * pi;
% q14 = rand(1) * 2 * pi;
% q15 = rand(1) * 2 * pi;
% g1 = 0;

% Setup plot
figure
scale_f = 20;
axis vis3d
axis(scale_f*[-1 1 -1 1 -1 1])
grid on
view(70,10)
xlabel('X (in.)')
ylabel('Y (in.)')
zlabel('Z (in.)')

% Plot robot initially
hold on
hrobot = plot3([0 0 10], [0 0 0], [0 6 6],'k.-','linewidth',2,'markersize',10);

% Animate the vector
pause(GraphingTimeDelay);
for i = 1:totalTimeSteps
   
    t = i/totalTimeSteps;
    
    %pos = RPR1(q01*(1-t) + q11*(t), q02*(1-t) + q12*(t), q03*(1-t) + q13*(t));
    pos=RPR1(0,5,0);
   
    set(hrobot,'xdata',[pos(1, 1) pos(2, 1) pos(3, 1) pos(4, 1) ]',...
        'ydata',[pos(1, 2) pos(2, 2) pos(3, 2) pos(4, 2) ]',...
        'zdata',[pos(1, 3) pos(2, 3) pos(3, 3) pos(4, 3) ]');
    
    pause(GraphingTimeDelay);
end





function [ pos, R ] = RPR1( t1, d2, t3 )


A1 = [ cos(t1),  (2^(1/2)*sin(t1))/2, -(2^(1/2)*sin(t1))/2,  0
 sin(t1), -(2^(1/2)*cos(t1))/2,  (2^(1/2)*cos(t1))/2,  0
       0,           -2^(1/2)/2,           -2^(1/2)/2, 10
       0,                    0,                    0,  1];
 
A2 =[  0,  0, 1, 0
 -1,  0, 0, 0
  0, -1, 0, d2
  0,  0, 0, 1];
 
A3 =[ sin(t3 + pi/4),  sin(t3 - pi/4),  0,  5*sin(t3 + pi/4)
 sin(t3 - pi/4), -sin(t3 + pi/4),  0, -5*cos(t3 + pi/4)
              0,               0, -1,                 0
              0,               0,  0,                 1];


T03=A1*A2*A3;
R=T03(1:3,1:3);
disp(R);
p1=A1(1:3,4);
p0=[0;0;0];
t2=A1*A2;
p2=t2(1:3,4);
t3=A1*A2*A3;
p3=t3(1:3,4);
pos=[p0';p1';p2';p3'];


end
