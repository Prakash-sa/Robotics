function I_ = stitch(I1,I2,H)
	[sy2,sx2,sz2] = size(I2);
	[x2,y2,z2] = meshgrid(1:sx2,1:sy2,1:sz2);
	
	% map I2 to I1
	p1_hat = H*[x2(:),y2(:),ones(numel(x2),1)]';
	p1_hat = p1_hat(1:2,:)./(repmat(p1_hat(3,:),2,1)+eps);
	
	% create new dimensions to accomodate points from I2
	p1_hat_xmax = max(p1_hat(1,:));
	p1_hat_xmin = min(p1_hat(1,:));
	p1_hat_ymax = max(p1_hat(2,:));
	p1_hat_ymin = min(p1_hat(2,:));
	
	xmin = round(floor(min(p1_hat_xmin,0)));
	xmax = round(ceil(max(p1_hat_xmax,sx2)));
	ymin = round(floor(min(p1_hat_ymin,0)));
	ymax = round(ceil(max(p1_hat_ymax,sy2)));
	
	% create images for mapping
	I1_ = uint8(zeros(ymax - ymin, xmax - xmin,3));
	I2_ = uint8(zeros(ymax - ymin, xmax - xmin,3));
	I_ = uint8(zeros(ymax - ymin, xmax - xmin,3));
	
	% I1 is just translated in I_
	I1_(1-ymin:sy2-ymin, 1-xmin:sx2-xmin,:) = I1;
	
	% map I_ to I2 (translation then homography)
	[sy2_,sx2_,sz2_] = size(I2_);
	[x2_,y2_,z2_] = meshgrid(1:sx2_,1:sy2_,1:sz2_);
	p2_hat = H\[x2_(:)+xmin, y2_(:)+ymin, ones(numel(x2_),1)]';
	p2_hat = round(p2_hat(1:2,:)./(repmat(p2_hat(3,:),2,1)+eps));
	
	% keep only the valid coordinates
	good_x = p2_hat(1,:) > 0 & p2_hat(1,:) <= sx2;
	good_y = p2_hat(2,:) > 0 & p2_hat(2,:) <= sy2;
	good = good_x & good_y; good = good(:);
	
	% valid in I_
	ind2 = sub2ind(size(I2_),y2_(good),x2_(good),z2_(good));
	% valid in I2
	ind2_hat = sub2ind(size(I2),p2_hat(2,good)',p2_hat(1,good)',z2_(good));
	
	% I2 transformed by homography in I_
	I2_(ind2) = I2(ind2_hat);
	
	% nonoverlapping regions do not require blending
	I2_sum = sum(I2_,3); I1_sum = sum(I1_,3);
	[no_blend_y,no_blend_x] = find(I2_sum == 0 | I1_sum == 0);
	
	no_blend_ind_r = sub2ind(size(I_),no_blend_y,no_blend_x,ones(size(no_blend_x)));
	no_blend_ind_g = sub2ind(size(I_),no_blend_y,no_blend_x,2*ones(size(no_blend_x)));
	no_blend_ind_b = sub2ind(size(I_),no_blend_y,no_blend_x,3*ones(size(no_blend_x)));
	
	I_(no_blend_ind_r) = I2_(no_blend_ind_r) + I1_(no_blend_ind_r);
	I_(no_blend_ind_g) = I2_(no_blend_ind_g) + I1_(no_blend_ind_g);
	I_(no_blend_ind_b) = I2_(no_blend_ind_b) + I1_(no_blend_ind_b);
	
	% overlapping regions require blending		
	[blend_y,blend_x] = find(I2_sum > 0 & I1_sum > 0);
	
	blend_ind_r = sub2ind(size(I_),blend_y,blend_x,ones(size(blend_x)));
	blend_ind_g = sub2ind(size(I_),blend_y,blend_x,2*ones(size(blend_x)));
	blend_ind_b = sub2ind(size(I_),blend_y,blend_x,3*ones(size(blend_x)));
	
	I_(blend_ind_r) = uint8(double(I2_(blend_ind_r))*.5 + double(I1_(blend_ind_r))*.5);
	I_(blend_ind_g) = uint8(double(I2_(blend_ind_g))*.5 + double(I1_(blend_ind_g))*.5);
	I_(blend_ind_b) = uint8(double(I2_(blend_ind_b))*.5 + double(I1_(blend_ind_b))*.5);
end