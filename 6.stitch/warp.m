function [done] = warp()

	data = loadLibrary();
	im1 = data{1};
	im2 = data{2};
	im1_pts = data{3};
	im2_pts = data{4};

	% compute feature descriptors
	[hx1,hy1,hv1] = harris(im1);
	[x1,y1] = suppression(hx1, hy1, hv1);
	d1 = descriptorExtraction(x1,y1,im1);
	[hx2,hy2,hv2] = harris(im2);
	[x2,y2] = suppression(hx2, hy2, hv2);
	d2 = descriptorExtraction(x2,y2,im2);

	% feature match, get homography
	H = computeH2(x1,y1,d1,x2,y2,d2);
	%H = computeH(im1_pts, im2_pts);

	% warp right image
	warpOut = warpImage(im2,H);
	imwarped = warpOut{1};
	nLeft = warpOut{2};

	size(im2)

	% combine images
	combinedImage = combineImage(im1, imwarped, nLeft);

	imwrite(combinedImage, 'output2/lib.jpg');
	%imshow(combinedImage);
	done = 0;



end



% show harris coordinates on image
function [outputs] = showHarris(x, y, im)
	imagesc(im);
	colormap(gray);
	hold on;
	plot(x,y,'r.');
	hold off;
end


% for library
function [data] = loadLibrary()
	im1 = im2double(imread('images/lib1.jpg'));
	im2 = im2double(imread('images/lib2.jpg'));
	im1_pts = [528,166;
						 317,135;
						 295,580;
						 724,485;
						 880,123];

	im2_pts = [381,132;
						 151,76;
						 99,551;
						 554,463;
						 481,137];
	data = {im1, im2, im1_pts, im2_pts};
end



% for room
function [data] = loadRoom()
	im1 = im2double(imread('images/room1.jpg'));
	im2 = im2double(imread('images/room2.jpg'));
	im1_pts = [553,408;
						 566,221;
						 724,206;
						 768,493];

	im2_pts = [138,423;
						 150,218;
						 337,205;
						 380,485;];



	data = {im1, im2, im1_pts, im2_pts};
end




% for outdoors
function [data] = loadOut()
	im1 = im2double(imread('images/out1.jpg'));
	im2 = im2double(imread('images/out2.jpg'));
	im1_pts = [498,193;
						 515,310;
						 651,321;
						 600,238];

	im2_pts = [237,183;
						 266,312;
						 408,315;
						 352,233];
	data = {im1, im2, im1_pts, im2_pts};
end