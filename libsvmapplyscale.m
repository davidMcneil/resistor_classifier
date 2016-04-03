function [labels features] = libsvmapplyscale(labels, features, rng)
	tempLib1 = strcat('temp_', random_string());
	tempLib2 = strcat('temp_', random_string());
	% Write lib so we can scale it
	libsvmwrite(tempLib1, sparse(labels), sparse(features));
	% Scale lib
	command = sprintf('./svm-scale -l 0 -r %s %s > %s', rng, tempLib1, tempLib2);
	system(command);
	[labels features] = libsvmread(tempLib2);
	system(sprintf('rm %s', tempLib1));
	system(sprintf('rm %s', tempLib2));
end