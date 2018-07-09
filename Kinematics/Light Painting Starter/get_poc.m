function [duration, x, y, z, phi, theta, psi, r, g, b] = get_poc(t)
%
% Calculates the position, orientation, and color (poc) for the PUMA's
% LED at the specified point in time.
%
% The original was written by Professor Katherine J. Kuchenbecker.
% Students can use this default implementation of the script,
% or modify it if they prefer.
%
% The only input is the present time (t) in seconds.  The light
% painting begins at t = 0, when the robot must be in the home pose
% (all thetas equal to zero except theta5, which equals -pi/2).  If
% called without a value for time, the function initializes and
% returns only the duration.
%
%    t: present time, in seconds
%
% The first output is the total duration of this light painting, in
% seconds.  The calling function needs this information so it can tell
% when to stop.
%
%    duration: time needed to do the entire light painting, in seconds
%
% The next three outputs (x, y, z) are the coordinates where the
% PUMA's end-effector tip should be, specified in inches in the base
% frame.  The origin of the base frame is where the first joint axis
% (waist) intersects the table. The z0 axis points up, and the x0 axis
% points out away from the robot, perpendicular to the front edge of
% the table.
%
%     x: x-coordinate of the origin of frame 6 in frame 0, in inches
%     y: y-coordinate of the origin of frame 6 in frame 0, in inches
%     z: z-coordinate of the origin of frame 6 in frame 0, in inches
%
% The fifth through seventh outputs (phi, theta, psi) represent the
% desired orientation of the PUMA's end-effector in the base frame
% using ZYZ Euler angles in radians.
%
%     phi: first ZYZ Euler angle to represent orientation of frame 6 in frame 0, in radians
%     theta: second ZYZ Euler angle to represent orientation of frame 6 in frame 0, in radians
%     psi: third ZYZ Euler angle to represent orientation of frame 6 in frame 0, in radians
%
% The last three outputs (r, g, b) are the red, green, and blue
% components of the color that the PUMA's LED should take on.  Set all
% to zero to turn the LED off without having to wait.
%
%     r: red value for the LED, from 0 to 1
%     g: green value for the LED, from 0 to 1
%     b: blue value for the LED, from 0 to 1


    %% DEFINE PERSISTENT VARIABLES
    % Define all variables needed multiple times to be persistent.
    persistent xvia yvia zvia phivia thetavia psivia rvia gvia bvia 
    persistent trajectorytypevia tipspeed tvia dur


    %% HANDLE INITIALIZATION

    % This function is initialized by calling it with no argument.
    if (nargin == 0)

        % Load the painting file from disk. It contains the
        % variable painting. If you prefer, you may omit loading a file
        % from disk and just write the necessary code here.
        pickPainting = randi(3);
        
        if pickPainting == 1
            load skyline
        elseif pickPainting == 2
            load love
        else
            load eiffel
        end

        % Pull the lists of x, y, and z positions out of the painting
        % matrix. You may do additional manipulations here to scale,
        % shift, or otherwise transform the painting.
        xvia = painting(:,1);
        yvia = painting(:,2);
        zvia = painting(:,3);

        % Pull the lists of Euler angles out of the painting matrix.
        phivia = painting(:,4);
        thetavia = painting(:,5);
        psivia = painting(:,6);

        % Pull the lists of red, green, and blue color components out.
        rvia = painting(:,7);
        gvia = painting(:,8);
        bvia = painting(:,9);

        % Pull the list of trajectory types out of the painting matrix.
        trajectorytypevia = painting(:,10);

        % Calculate the distance traveled between neighboring via points,
        % assuming linear interpolation, in inches.
        distances = sqrt((diff(xvia)).^2 + (diff(yvia)).^2 + (diff(zvia)).^2);

        % Define the speed the tip should move in inches per second.
        tipspeed = 2;

        % Calculate durations for travel between neighboring via points,
        % assuming linear interpolation, in seconds.
        durations = distances / tipspeed;

        % Calculate time at each via point using the cumulative sum
        % function.
        tvia = cumsum(durations);

        % Add a zero at the start of tvia, since time starts at zero.
        tvia = [0 ; tvia];

        % The light painting's duration in seconds is the time of the
        % final via point.  The variable dur is persistent.
        dur = tvia(end);

        % Since an output variable cannot be persistent, we put the
        % calculated duration into the output variable.
        duration = dur;

        % Return from initialization.
        return

    end


    %% HANDLE REGULAR CALLS

    % Assign value to duration output.
    duration = dur;

    % Determine which trajectory we should be executing.  Assuming the via
    % point times are monotonically increasing, we look for the first via
    % point time that is greater than the current time.  Subtract 1 to get
    % to the index of the via point that starts this trajectory.
    traj = find(t < tvia,1) - 1;

    % Select the correct trajectory types.
    switch (trajectorytypevia(traj))
        case 0
            % Linearly interpolate all values.
            x = linear_trajectory(t,tvia(traj),tvia(traj+1),xvia(traj),xvia(traj+1));
            y = linear_trajectory(t,tvia(traj),tvia(traj+1),yvia(traj),yvia(traj+1));
            z = linear_trajectory(t,tvia(traj),tvia(traj+1),zvia(traj),zvia(traj+1));
            phi = linear_trajectory(t,tvia(traj),tvia(traj+1),phivia(traj),phivia(traj+1));
            theta = linear_trajectory(t,tvia(traj),tvia(traj+1),thetavia(traj),thetavia(traj+1));
            psi = linear_trajectory(t,tvia(traj),tvia(traj+1),psivia(traj),psivia(traj+1));
            r = linear_trajectory(t,tvia(traj),tvia(traj+1),rvia(traj),rvia(traj+1));
            g = linear_trajectory(t,tvia(traj),tvia(traj+1),gvia(traj),gvia(traj+1));
            b = linear_trajectory(t,tvia(traj),tvia(traj+1),bvia(traj),bvia(traj+1));
        % case 1
            % You may define and write other interpolation methods if you
            % want, but that is not required.
        otherwise
            error(['Unknown trajectory type: ' num2str(trajectorytypevia(traj))])
    end
end