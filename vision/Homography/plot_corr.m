function plot_corr(I1,I2,p1,p2)
	I = [I1,I2];
	[sy,sx] = size(I1);
	
	figure()
	imshow(I)
	hold on;
	plot(p1(:,1),p1(:,2),'bo');
	plot(sx + p2(:,1),p2(:,2),'rx');
	plot([p1(:,1),sx+p2(:,1)]',[p1(:,2),p2(:,2)]','g-');
	hold off;


end