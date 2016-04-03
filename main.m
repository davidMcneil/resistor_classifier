I = imread('images/img1.jpg');
M = imread('mask.png');
sizeI = size(I);
sizeM = size(M);
sizeC = (sizeI(1:2) + sizeM) - 1; % Size of resulting convolved image
verbose = true;

% Detect bounding boxes
rotStep = 10;
bwThresh = 0.7;
[iLocs, jLocs, angles] = detection(I, M, rotStep, bwThresh, verbose);

% Pad image for display (after convolving with mask image has border)
m = sizeI(1);
n = sizeI(2);
p = sizeC(1);
q = sizeC(2);
Ipad = padarray(I, [(p-m)/2 (q-n)/2]);
Ipad = padarray(I, [floor((p-m)/2) floor((q-n)/2)], 'post');
Ipad = padarray(Ipad, [ceil((p-m)/2) ceil((q-n)/2)], 'pre');

% Draw bounding boxes
imshow(Ipad);
hold on
boxes = {};
fileID = fopen('output/percentages.txt','w');
for i = 1:size(jLocs, 1)
	MR = imrotate(M, angles(i), 'crop');
	rect = [jLocs(i), iLocs(i)];
	rectangle('Position', [double(rect) + (sizeM / 2), sizeM], ...
			  'EdgeColor','r', 'LineWidth', 1);
	boxes{i} = imcrop(I, [rect, sizeM - 1]);
	if verbose
		masked = boxes{i} .* uint8(repmat(MR, 1, 1, 3));
		imwrite(masked, strcat('output/masked', int2str(i), '.jpg'));
		[fc p] = classify_region(masked, find(MR));
		imwrite(fc, strcat('output/fc', int2str(i), '.jpg'));
		fprintf(fileID,'Number 	%2.f\n', i);
		fprintf(fileID,'black: 	%0.5f\n', p.black);
		fprintf(fileID,'brown: 	%0.5f\n', p.brown);
		fprintf(fileID,'red: 	%0.5f\n', p.red);
		fprintf(fileID,'orange: %0.5f\n', p.orange);
		fprintf(fileID,'yellow: %0.5f\n', p.yellow);
		fprintf(fileID,'green: 	%0.5f\n', p.green);
		fprintf(fileID,'blue: 	%0.5f\n', p.blue);
		fprintf(fileID,'violet: %0.5f\n', p.violet);
		fprintf(fileID,'grey: 	%0.5f\n', p.grey);
		fprintf(fileID,'white: 	%0.5f\n', p.white);
		fprintf(fileID,'other: 	%0.5f\n', p.other);
	end
end

fclose(fileID);
clear;

