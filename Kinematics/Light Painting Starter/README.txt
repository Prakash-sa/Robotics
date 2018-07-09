1) puma_paint.m

This script contains the code which gets all the lines you would like to paint,
finds the inverse kinematics solutions to the points on the lines, and paints
your picture. You do not need to make any modifications here, but feel free
to go through the code, and understand what is being done!

To slow down the animation, change the variable GraphingTimeDelay.

2) plot_puma.m

Actual plotting of the PUMA robot given the robot parameters.
Again, you do not need to make any modifications here, but it would be good
if you understood how the robot is being plotted.

3) puma_fk.p

Code for foward kinematics of the PUMA. This is required to plot the robot.
However, it is an encrypted script and you cannot access the source code,
as this would be giving away the solution to Part 1 of this project.

4) puma_ik.m

This is the code for inverse kinematics of the PUMA. Copy over you code from
part 2 of this project here. You may want to modify the code from part 2 to return
4, or even all 8 possible inverse kinematic solutions that may exist for a 
given point. Each row of ik_sol must contain one set of solutions.

5) choose_solution.m

As mentioned above, there are multiple possible inverse kinematic solutions
for a given point, i.e., there are multiple joint angle combinations that get
the end effector to the desired position and orientation.

If you are not careful, you will see that the robot arm shifts between these
different poses. In simulation, there is no danger, but in the real world,
this would cause really bad effects as the joints are instantaneously made
to switch between the solutions, and the motor will have to generate infinite
torque.

For example, compare the two videos 'choose_correct.avi' and 'choose_wrong.avi',
and notice how the robot keeps incorrectly switching between elbow-up 
and elbow-down configurations in the second video.

In this script, you are given the set of solutions for where the robot needs
to go next, and the current joint angles of the robot. You should make use
of this information to select the next set of joint angles for the robot appropriately.

6) get_poc.m

This file handles generating the trajectory for the robot based on the points
provided in the .mat files. It randomly selects between painting the eiffel tower,
the love statue, or the philadelphia skyline.

First verify if the above pictures are being painted properly. If they are not,
there is probably a bug in your choose_solution or puma_ik files.

Once you verify with the given paintings, you can attempt to paint your own picture.
You have two options:

A) The Challenging Way:

Understand how this function works, and write your own code to return 
end effector position, orientation, and color, required to paint your picture.

Remember, if called without a value for time, the function should initialize
and return only the duration.

B) The Straight Forward Way:

The easier way would be to create a 'mypainting.mat' file which contains
a matrix called painting which has N rows and 10 columns. Then load this
mat-file instead of eiffel/love/skyline in get_poc.m

Each row of the painting matrix defines a single via point 
(position, orientation, and color) that the robot’s end effector 
should accomplish, along with the type of trajectory to be used 
between this point and the next one. The via points are listed in the order 
in which they should be performed.
 
Each column of the via points hold the following information:

• Columns 1, 2, and 3 of the painting matrix contain the x, y, and z coordinates
  of the center of frame 6 relative to frame 0, expressed in inches.

• Columns 4, 5, and 6 contain the φ, θ, and ψ ZYZ Euler angles 
  that define the orientation of frame 6 relative to frame 0, in radians.

• Columns 7, 8, and 9 contain the red, green, and blue color component values 
  for the end effector to paint. Each of these values should range from zero to one, with one being brightest.
  Set all three to zero to cause the 'LED' to be off at a certain via point.

• Column 10 contains an integer that specifies the type of trajectory that 
  should be executed as the robot moves from this via point to the next one.
  As written, the starter code defines and uses only one trajectory type: 
  linear interpolation on position, orientation. 
  This trajectory type is defined to be number 0, and it’s implemented via 
  the provided function linear_trajectory.m
  You are welcome to use only this provided trajectory type, or you may edit it or program your own.

Play around with .mat files given to you, and see how the changes effect
the painting, to get a better idea of how this works!

>>>> Once everything is setup, call 'puma_paint' to see the light painting animation!

After the animation completes, click on the save button on the plot, and save
your light painting as a .png file, which you will need to submit via edX
for grading.