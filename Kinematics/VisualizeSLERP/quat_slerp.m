
function [ q_int ] = quat_slerp( q0, q1, steps)
%QUAT_SLERP Perform SLERP between two quaternions and return the intermediate quaternions
%   Usage: [ q_int ] = quat_slerp( q0, q1, steps )
%   Inputs:
%       q0 is the quaternion representing the starting orientation, 1x4 matrix
%       q1 is the quaternion representing the final orientation, 1x4 matrix
%       steps is the number of intermediate quaternions required to be returned, integer value
%       The first step is q0, and the last step is q1
%   Output:
%       q_int contains q0, steps-2 intermediate quaternions, q1
%       q_int is a (steps x 4) matrix

    pn=quatnormalize(q0);

qn=quatnormalize(q1);
    %% Your code goes here
    q_int1 = quatinterp(pn,qn,steps/400,'slerp');
    q_int2 = quatinterp(pn,qn,steps/100,'slerp');
    q_int3 = quatinterp(pn,qn,steps/200,'slerp');
    q_int= [q_int1;q_int2;q_int3];
end