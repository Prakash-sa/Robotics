function thetas = choose_solution(allSolutions, thetasnow)
%
% Chooses the best inverse kinematics solution from all of the
% solutions passed in.  This decision is based both on the
% characteristics of the PUMA 260 robot and on the robot's current
% configuration.
%
% This Matlab function is part of the starter code for the light painting
% project in the Robotics Fundamentals edX course by the University of
% Pennsylvania.  The original was written by Professor Katherine J.
% Kuchenbecker. 
%
% The first input (allSolutions) is a matrix that contains the joint
% angles needed to place the PUMA's end-effector at the desired
% position and in the desired orientation. The first column is theta1,
% the second column is theta2, etc., so it has six columns.  The number of
% rows is the number of inverse kinematics solutions that were
% found; each row should contain a set of joint angles that place
% the robot's end-effector in the desired pose. These joint angles are
% specified in radians according to the order, zeroing, and sign
% conventions described in the figure given in part B of Project 2.
% If the IK function could not find a solution to the inverse kinematics problem, it will
% pass back [] (empty matrix).
%
%    allSolutions: IK solutions for all six joints, in radians
%
% The second input is a vector of the PUMA robot's current joint
% angles (thetasnow) in radians.  This information enables this
% function to choose the solution that is closest to the robot's
% current pose.
%
%     thetasnow: current values of theta1 through theta6, in radians
%
% You will need to update this function so it chooses intelligently
% from the provided solutions to choose the best one.
%
% There are several reasons why one solution might be better than the
% others, including how close it is to the robot's current
% configuration and whether it violates or obeys the robot's joint
% limits.

    % For now, just return the last row of allSolutions.
    thetas = allSolutions(end,:);

end