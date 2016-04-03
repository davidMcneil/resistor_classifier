% Find resistor bounding boxes in the image
% Inputs
% I-> original image
% M-> resistor mask
% rotStep-> rotation step size in degrees
% bwThresh-> theshold for converting to black and white
% verbose-> whether or not to produce logs
% Outputs
% iLocs-> i i index of top right point in resistor bounding box
% jLocs-> j index of top right point in resistor bounding box

function  [iLocs, jLocs, angles] = detection(I, M, rotStep, bwThresh, verbose)
	% Convert to black and white
	Ibw = im2bw(I, bwThresh);
	Ibw = imcomplement(Ibw);
	if verbose
		% imtool(Ibw)
		imwrite(Ibw, 'output/Ibw.jpg');
	end
	% Convolve image with masks
	sizeM = size(M);
	sizeC = (size(Ibw) + size(M)) - 1;
	locsImg = zeros(sizeC) - 1;
	maxsImg = zeros(sizeC);
	% Setup local maximum finder
	localMax = vision.LocalMaximaFinder;
	localMax.MaximumNumLocalMaxima = 20;
	localMax.NeighborhoodSize = (sizeM) * 2 - 1;
	localMax.Threshold = 0.15;
	for i = 0:rotStep:(180-rotStep)
		% Perform convolution
		MR = imrotate(M, i, 'crop');
		c = conv2(double(Ibw), double(MR) / numel(MR));
		if (i == 0 || i == 90) && verbose
			% imtool(mat2gray(c))
			imwrite(mat2gray(c), strcat('output/conv', int2str(i), '.jpg'));
		end
		% Find current local maximum locations
		release(localMax);
		curLocs = step(localMax, c);
		curLocs = sub2ind(sizeC, curLocs(:, 2), curLocs(:, 1));
		% Save max values
		newMaxs = zeros(sizeC);
		newMaxs(curLocs) = c(curLocs);
		maxsImg = maxsImg + newMaxs;
		% Find all local maximum locations
		release(localMax);
		allLocs = step(localMax, maxsImg);
		allLocs = sub2ind(sizeC, allLocs(:, 2), allLocs(:, 1));
		% Save the locations with corresponding rotation
		locsImg(setdiff(find(locsImg > -1), allLocs)) = -1;
		locsImg(intersect(curLocs, allLocs)) = i;
	end
	
	[iLocs, jLocs] = ind2sub(sizeC, allLocs);
	iLocs = uint64(iLocs - sizeM(1));
	jLocs = uint64(jLocs - sizeM(2));
	angles = locsImg(allLocs);
end

