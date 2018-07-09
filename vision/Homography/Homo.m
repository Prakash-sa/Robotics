clear all;
buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);
I1 = readimage(buildingScene, 1);
I2 = readimage(buildingScene, 2);

p1 = [ 366.6972 ,106.9789
  439.9366  , 84.4437
  374.5845 , 331.2042
  428.6690 , 326.6972 ];

p2 = [ 115.0000 , 120.0000
  194.0000 , 107.0000
  109.0000 , 351.0000
  169.0000 , 346.0000 ];

 
  
figure()
subplot(131)
imshow(I1);
hold on;
plot(p1(:,1),p1(:,2),'go')
hold off;

subplot(132)
imshow(I2);
hold on;
plot(p2(:,1),p2(:,2),'go')
hold off;

H = compute_homography(p1,p2);
H=[0.6295,-0.001,-0.005
    0 ,-0.315,-0.3155
    0,0,0.6344];

I = stitch(I1,I2,H);


figure()
imshow(I)


function H = compute_homography(p1,p2)		
    % use SVD to solve for H as was done in the lecture
    
   A=[ p1(1,1) , p1(1,2) ,1 ,    0     ,  0    , 0 , -p1(1,1)*p2(1,1) , -p1(1,2)*p2(1,1) , -p2(1,1)
            0  ,     0   , 0 , p1(1,1) ,p1(1,2), 1 , -p1(1,1)*p2(1,2) , -p1(1,2)*p2(1,2) , -p2(1,2)
       p1(2,1) , p1(2,2) ,1 ,    0     ,  0    , 0 , -p1(2,1)*p2(2,1) , -p1(2,2)*p2(2,1) , -p2(2,1)
            0  ,     0   , 0 , p1(1,1) ,p1(1,2), 1 , -p1(2,1)*p2(2,2) , -p1(2,2)*p2(2,2) , -p2(2,2)
       p1(3,1) , p1(3,2) ,1 ,    0     ,  0    , 0 , -p1(3,1)*p2(3,1) , -p1(3,2)*p2(3,1) , -p2(3,1)
            0  ,     0   , 0 , p1(3,1) ,p1(3,2), 1 , -p1(3,1)*p2(3,2) , -p1(3,2)*p2(3,2) , -p2(3,2)
      p1(4,1) , p1(4,2) ,1 ,    0     ,  0    , 0 , -p1(4,1)*p2(4,1) , -p1(4,2)*p2(4,1) , -p2(4,1)
            0  ,     0   , 0 , p1(4,1) ,p1(4,2), 1 , -p1(4,1)*p2(4,2) , -p1(4,2)*p2(4,2) , -p2(4,2)];
        
       
     [u,d,v]=svd(A);
 
      X=v(:,9)/v(9,9);
  
       X
       H=reshape(X,3,3);
 
     
  %{   
ncorr = length(img1_points);
    %% Setting the P matrix 10x9
    P = [img1_points(1:ncorr,:),ones(ncorr,1),zeros(ncorr,3),...
        -1*img2_points(1:ncorr,1).*img1_points(1:ncorr,:),...
        -1*img2_points(1:ncorr,1);...
        zeros(ncorr,3),-1*img1_points(1:ncorr,:),-1*ones(ncorr,1),...
        img2_points(1:ncorr,2).*img1_points(1:ncorr,:),...
        img2_points(1:ncorr,2)];
    %% Calculating r 8x1
    r = img2_points(:);
    %% SVD Decomposition
    [~,S,V] = svd(P);
    %% Extracting Diagonal elements of S
    sigmas = diag(S);
    %% Detecting minimum diagonal element
    if length(sigmas) >= 9
        minSigma = min(sigmas);
        [~,minSigmaCol] = find(S==minSigma);
        %% Calculating q
        q = double(vpa(V(:,minSigmaCol)));
    elseif length(sigmas)<9
        %% Calculating q
        q = double(vpa(V(:,9)));
    end
    %% Calculating A
    A = reshape(q,[3,3])';

%}


 %{    
     if ~isequal(size(pin), size(pout))
    error('Points matrices different sizes');
     end

n = size(pin,2);

% Solve equations using SVD
x = pout(1, :); y = pout(2,:); X = pin(1,:); Y = pin(2,:);
rows0 = zeros(3, n);
rowsXY = -[X; Y; ones(1,n)];
hx = [rowsXY; rows0; x.*X; x.*Y; x];
hy = [rows0; rowsXY; y.*X; y.*Y; y];
h = [hx hy];
if n == 4
    [U, ~, ~] = svd(h);
else
    [U, ~, ~] = svd(h, 'econ');
end
v = (reshape(U(:,9), 3, 3)).';
%}




end



%n = size(pts1,2);
%A = zeros(2*n,9);
%A(1:2:2*n,1:2) = pts1';
%A(1:2:2*n,3) = 1;
%A(2:2:2*n,4:5) = pts1';
%A(2:2:2*n,6) = 1;
%x1 = pts1(1,:)';
% y1 = pts1(2,:)';
 %x2 = pts2(1,:)';
% y2 = pts2(2,:)';

 %A(1:2:2*n,7) = -x2.*x1;
% A(2:2:2*n,7) = -y2.*x1;
 %A(1:2:2*n,8) = -x2.*y1;
 %A(2:2:2*n,8) = -y2.*y1;
% A(1:2:2*n,9) = -x2;
% A(2:2:2*n,9) = -y2;

 %[evec,~] = eig(A'*A);
% H = reshape(evec(:,1),[3,3])';
 %H = H/H(end); % make H(3,3) = 1

