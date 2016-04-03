function features = get_data(img, j, i)
	% colorTransform = makecform('srgb2lab');
	% img = applycform(img, colorTransform);
	% img = rgb2hsv(img);
	locality = [2 2];
	rImg = img(:, :, 1); 
	gImg = img(:, :, 2);
	bImg = img(:, :, 3); 
	% [i, j] = ind2sub(size(rImg), index);
	pnt = uint32([j i]) - uint32((locality) / 2);
	rect = horzcat(pnt, locality);
	rReg = imcrop(rImg, rect);
	gReg = imcrop(gImg, rect);
	bReg = imcrop(bImg, rect);
	features = [mean(mean(rReg))...
		 		mean(mean(gReg))...
		 		mean(mean(bReg))];
end
