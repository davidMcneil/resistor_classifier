% Editable parameters
trainPercent = 0.8; % Percent data to use for training
libFilename = 'color_data';
svmFilename = 'svm.mat';

% Read Lib
libDirectory = 'libs/';
[labels features] = libsvmread(libFilename);
features = full(features);
nSamples = length(labels);

% Training parameters
randIndexs = randperm(nSamples);
trainIndexs = randIndexs(1:uint64(nSamples * trainPercent));
tLabels = labels(trainIndexs);
tFeatures = features(trainIndexs, :);

%%% Train the SVM and save it to file
% Grid search, and cross-validation
[C, gamma] = meshgrid(-5:1:15, -15:1:3);
folds = 5;
cvAcc = zeros(numel(C), 1);
for i=1:numel(C)
    cvAcc(i) = svmtrain(tLabels, tFeatures, ...
               sprintf('-c %f -g %f -v %d -q', 2^C(i), 2^gamma(i), folds));
end

% pair (C,gamma) with best accuracy
[~, idx] = max(cvAcc);
fprintf('Best Cross Validation Accuracy = %0.4f\n', cvAcc(idx));	

% contour plot of paramter selection
contour(C, gamma, reshape(cvAcc,size(C))), colorbar
hold on
plot(C(idx), gamma(idx), 'rx')
text(C(idx), gamma(idx), sprintf('Acc = %.2f %%',cvAcc(idx)), ...
    'HorizontalAlign','left', 'VerticalAlign','top')
hold off
xlabel('log_2(C)'), ylabel('log_2(\gamma)'), title('Cross-Validation Accuracy')

% Train final svm on best_C and best_gamma
bestC = 2^C(idx);
bestGamma = 2^gamma(idx);
svm = svmtrain(tLabels, tFeatures, ...
               sprintf('-c %f -g %f -b 1 -q', bestC, bestGamma, folds));
save(svmFilename, 'svm');

% Verification parameters
verifyIndexs = setdiff(find(labels), trainIndexs);
vLabels = labels(verifyIndexs);
vFeatures = features(verifyIndexs, :);

% Verify the SVM
SVM = load(svmFilename);
[lab, acc, pro] = svmpredict(vLabels, vFeatures, SVM.svm, '-b 1');

clear;
