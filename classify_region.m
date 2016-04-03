function [fc percentages] =  classify_regin(region, indexs)
	SVM = load('svm.mat'); % Get the trained svm
	% Get data from each pixel
	[i, j] = ind2sub(size(region(:, :, 1)), indexs);
	is(:, 1) = i;
	is(:, 2) = j;
	is = mat2cell(is, repmat(1, length(indexs), 1), 2);
	features = cellfun(@(i) get_data(region, i(2), i(1)), is, 'UniformOutput', false);
	features = cell2mat(features);
	% Predict labels
	[labels features] = libsvmapplyscale(repmat(-1, length(indexs), 1), features, 'color_data.rng');
	[labs, ~, ~] = svmpredict(labels, features, SVM.svm, '-b 1 -q');
	% Get color counts 
	total = length(labs);
	counts = [length(find(labs == 1)) length(find(labs == 2)) length(find(labs == 3)) length(find(labs == 4)) length(find(labs == 5)) length(find(labs == 6)) length(find(labs == 7)) length(find(labs == 8)) length(find(labs == 9)) length(find(labs == 10)) length(find(labs == 11))];
	% Create false color image
	fc = zeros(size(region(:,:,1)));
	fc(indexs) = labs;
	fc = uint8(fc);
	% imtool(fc)
	map = [0 0 0];
	colors = [[0 0 0]; [0.6 0.2 0]; [1 0 0]; [1 0.6 0]; [1 1 0]; [0 1 0]; [0 0.44706 0.74118]; [0.74902 0 0.74902]; [0.50196 0.50196 0.50196]; [1 1 1]; [1 0.6 0.78431]];
	max = 0;
	for i = 1:11
		if counts(i) > 0
			map = vertcat(map, colors(i, :));
			max = max + 1;
		else
			s = uint8(zeros(size(region(:,:,1))));
			s(find(fc > max)) = 1;
			fc = fc - s;
		end
	end
	fc = ind2rgb(fc, map);
	% imtool(fc)
	% Calculate percentages
	percentages.black 	= 	counts(1) / total;
	percentages.brown 	= 	counts(2) / total;
	percentages.red 	= 	counts(3) / total;
	percentages.orange 	= 	counts(4) / total;
	percentages.yellow 	= 	counts(5) / total;
	percentages.green 	= 	counts(6) / total;
	percentages.blue 	= 	counts(7) / total;
	percentages.violet 	= 	counts(8) / total;
	percentages.grey 	= 	counts(9) / total;
	percentages.white 	= 	counts(10) / total;
	percentages.other 	= 	counts(11) / total;
end
