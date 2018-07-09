%% Helper script to visualize forward kinematics of a lynx robot
% Fill in your code for the lynx_fk function before executing this script!

close all
pause on;  % Set this to on if you want to watch the animation
GraphingTimeDelay = 0.05; % The length of time that Matlab should pause between positions when graphing, if at all, in seconds.
totalTimeSteps = 100; % Number of steps in the animation

% Generate the starting and final joint angles, and gripper distance
% Set values manually, or randomise as shown below
q01 = 0;
q02 = 0;
q03 = 0;
q04 = 0;
q05 = 0;
g0 = 2;

q11 = 0;
q12 = 0;
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
    
    pos = lynx_fk(q01*(1-t) + q11*(t), q02*(1-t) + q12*(t), q03*(1-t) + q13*(t), q04*(1-t) + q14*(t), q05*(1-t) + q15*(t), g0*(1-t) + g1*(t));
    
   
    set(hrobot,'xdata',[pos(1, 1) pos(2, 1) pos(3, 1) pos(4, 1) pos(5, 1) pos(6, 1) pos(7, 1) pos(9, 1) pos(7, 1) pos(8, 1) pos(10, 1)]',...
        'ydata',[pos(1, 2) pos(2, 2) pos(3, 2) pos(4, 2) pos(5, 2) pos(6, 2) pos(7, 2) pos(9, 2) pos(7, 2) pos(8, 2) pos(10, 2)]',...
        'zdata',[pos(1, 3) pos(2, 3) pos(3, 3) pos(4, 3) pos(5, 3) pos(6, 3) pos(7, 3) pos(9, 3) pos(7, 3) pos(8, 3) pos(10, 3)]');
    
    pause(GraphingTimeDelay);
end