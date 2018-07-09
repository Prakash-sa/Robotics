
function [axang] = task(R)
 
    %% Your code starts here
    vec1=(R(3,2)-R(2,3)).*sqrt(((R(3,2)-R(2,3)).^2)+((R(1,3)-R(3,1)).^2)+((R(2,1)-R(1,2)).^2));
    vec2=(R(1,3)-R(3,1)).*sqrt(((R(3,2)-R(2,3)).^2)+((R(1,3)-R(3,1)).^2)+((R(2,1)-R(1,2)).^2));
    vec3=(R(2,1)-R(1,2)).*sqrt(((R(3,2)-R(2,3)).^2)+((R(1,3)-R(3,1)).^2)+((R(2,1)-R(1,2)).^2));
 
    vec = [vec1 vec2 vec3];
    theta = acos((trace(R)-1)./2);

    axang = [vec, theta];
    %% Your code ends here

end