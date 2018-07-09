% This Matlab script is part of the starter code for the simulated
% light painting Project in the Robotics Fundamentals edX course 
% by the University of Pennsylvania.
%
% It tests inverse kinematics code for the light painting.
% 

%% INSTRUCTIONS
% 
% You will need to code up the functions below. These functions are 
% present as separate files.
% puma_ik: This is where you will perform inverse kinematics of the PUMA
%          robot. Copy over your code from Part 2 of the project.
%          
% choose_solution: Inverse kinematics of the PUMA can have upto eight possible
%                  solutions. In this function, you will need to pick the
%                  best solution.
% 
% Please read through the comments in all the functions before you proceed
% with the implementation.

%% SETUP

% Set whether to animate the robot's movement using the plot variable.
animate = true;

if animate
    pause on;  % Set this to on if you want to watch the animation when running this script locally.
    GraphingTimeDelay = 0.05; % The length of time that Matlab should pause between positions when graphing, if at all, in seconds.
else
    pause off;
    GraphingTimeDelay = 0.0;
end

%% CREATE JOINT ANGLE SEQUENCE

% To test the positions and orientations from your light painting, we call your light painting code.

% Initialize the function that calculates positions, orientations, and
% colors by calling it once with no arguments.  It returns the
% duration of the light painting in seconds.
duration = get_poc();

% Create time vector.
tstep = 0.1; % s
t = 0:tstep:duration;

% Preallocate space for all the history variables.
ox_history = zeros(length(t),1);
oy_history = zeros(length(t),1);
oz_history = zeros(length(t),1);
phi_history = zeros(length(t),1);
theta_history = zeros(length(t),1);
psi_history = zeros(length(t),1);
r_history = zeros(length(t),1);
g_history = zeros(length(t),1);
b_history = zeros(length(t),1);
thetas_history = zeros(length(t),6);

% Step through the time vector, filling the histories by calling the
% function that returns positions, orientations, and colors.
for i = 1:length(t)
    [~, ox_history(i), oy_history(i), oz_history(i), phi_history(i), ...
        theta_history(i), psi_history(i), r_history(i), g_history(i), ...
        b_history(i)] = get_poc(t(i));
end


%% TEST

% Notify the user that we're starting the test.
disp('Starting the test.')

% Show a message to explain how to cancel the test and graphing.
disp('Click in this window and press control-c to stop the code.')

if animate
    % Plot the robot once in the home position to get the plot handles.
    figure(1); clf
    h = plot_puma(0,0,0,0,0,0,0,0,0,0,-pi/2,0,0,0,0);
end

% Step through the ox_history vector to test the inverse kinematics.
for i = 1:length(ox_history)
    
    % Pull the current values of ox, oy, and oz from their histories. 
    ox = ox_history(i);
    oy = oy_history(i);
    oz = oz_history(i);
    
    % Pull the current values of phi, theta, and psi from their
    % histories.
    phi = phi_history(i);
    theta = theta_history(i);
    psi = psi_history(i);

    % Pull the current values of red, green, and blue from their
    % histories.
    r = r_history(i);
    g = g_history(i);
    b = b_history(i);
        
    % Send the desired pose into the inverse kinematics to obtain the
    % joint angles that will place the PUMA's end-effector at this
    % position and orientation relative to frame 0.
    R = eulerrotation(phi, theta, psi);
    allthetas = puma_ik(ox, oy, oz, R);
    
    if (i == 1)
        % Pass in the home position as the current position.
        thetas_history(i,:) = choose_solution(allthetas, [0 0 0 0 -pi/2 0])';
    else        
        % Choose the solution to show.
        thetas_history(i,:) = choose_solution(allthetas, thetas_history(i-1,:))';
    end

    if animate
        % Plot the robot at this IK solution with the specified color.
         plot_puma(ox,oy,oz,phi,theta,psi,thetas_history(i,1),...
             thetas_history(i,2),thetas_history(i,3),thetas_history(i,4),...
             thetas_history(i,5),thetas_history(i,6),r,g,b,h);
    
        % Set the title to show the viewer which pose and result this is.
         title(['Pose ' num2str(i)])
    end

    % Pause for a short duration so that the viewer can watch
    % animation evolve over time.
     pause(GraphingTimeDelay)
    
end


%% FINISHED

% Tell the user.
disp('Done with the test.')

function R = eulerrotation(phi, theta, psi)
    R = [(cos(phi)*cos(theta)*cos(psi)) - (sin(phi)*sin(psi)),  -(cos(phi)*cos(theta)*sin(psi)) - (sin(phi)*cos(psi)), cos(phi)*sin(theta);...
         (sin(phi)*cos(theta)*cos(psi)) + (cos(phi)*sin(psi)),  -(sin(phi)*cos(theta)*sin(psi)) + (cos(phi)*cos(psi)), sin(phi)*sin(theta);...
          -sin(theta)*cos(psi)                               ,  sin(theta)*sin(psi)                                  , cos(theta)];
end