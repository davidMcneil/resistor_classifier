function libsvmscaledwrite(lib, labels, features)
	tempLib = strcat('temp_', random_string());
	% Write lib so we can scale it
	libsvmwrite(tempLib, sparse(labels), sparse(features));
	% Scale lib
	command = sprintf('./svm-scale -l 0 -s %s.rng %s > %s', lib, tempLib, lib);
	system(command);
	system(sprintf('rm %s', tempLib));
end