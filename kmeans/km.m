I = imread('res.jpg');
% Convert to lab sapce
cform = makecform('srgb2lab');
labI = applycform(I, cform);
% Extract ab layers completely encompase color space
ab = double(I(:, :, 2:3));
nrows = size(ab, 1);
ncols = size(ab, 2);
ab = reshape(ab, nrows*ncols, 2);

nColors = 2;
[cluster_idx, cluster_center] = kmeans(ab, nColors, ...
									   'distance', 'sqEuclidean', ...
                                       'Replicates', 3);

%% Step 4: Label Every Pixel in the Image Using the Results from KMEANS
% For every object in your input, |kmeans| returns an index corresponding to a
% cluster. The |cluster_center| output from |kmeans| will be used later in the
% example. Label every pixel in the image with its |cluster_index|.

imtool(I)

Ir = I(:, :, 1);
Ig = I(:, :, 2);
Ib = I(:, :, 3);
pixel_labels = reshape(cluster_idx, nrows, ncols);

for i = 1:nColors
	idx = find(pixel_labels == i);
	mc = uint8( ...
		[mean(Ir(idx))...
		 mean(Ib(idx))...
		 mean(Ig(idx))]);
	[y, x] = find(pixel_labels == i);
	Ir(idx) = mc(1);
	Ig(idx) = mc(2);
	Ib(idx) = mc(3);
end

outImg(:,:,1) = Ir;
outImg(:,:,2) = Ig;
outImg(:,:,3) = Ib;

imtool(outImg);


% figure;
% imshow(pixel_labels,[]), title('image labeled by cluster index');
% figure
% imagesc(pixel_labels)
% imtool()

% Step 5: Create Images that Segment the H&E Image by Color.
% Using |pixel_labels|, you can separate objects in |hestain.png| by color,
% which will result in three images.

% segmented_images = cell(1,3);
% rgb_label = repmat(pixel_labels,[1 1 3]);

% for k = 1:nColors
%     color = I;
%     color(rgb_label ~= k) = 0;
%     segmented_images{k} = color;
% end


% imtool(segmented_images{1});
% imtool(segmented_images{2});
% imtool(segmented_images{3});
% imtool(segmented_images{4});

% imtool(segmented_images{1});

% %% Step 6: Segment the Nuclei into a Separate Image
% % Notice that there are dark and light blue objects in one of the clusters.
% % You can separate dark blue from light blue using the 'L*' layer in the
% % L*a*b* color space. The cell nuclei are dark blue.
% %
% % Recall that the 'L*' layer contains the brightness values of each color.
% % Find the cluster that contains the blue objects. Extract the brightness
% % values of the pixels in this cluster and threshold them using |im2bw|.
% %
% % You must programmatically determine the index of the cluster containing
% % the blue objects because |kmeans| will not return the same |cluster_idx|
% % value every time.  You can do this using the |cluster_center| value,
% % which contains the mean 'a*' and 'b*' value for each cluster. The blue
% % cluster has the smallest cluster_center value (determined
% % experimentally).
% mean_cluster_value = mean(cluster_center,2);
% [tmp, idx] = sort(mean_cluster_value);
% blue_cluster_num = idx(1);

% L = lab_he(:,:,1);
% blue_idx = find(pixel_labels == blue_cluster_num);
% L_blue = L(blue_idx);
% is_light_blue = im2bw(L_blue,graythresh(L_blue));

% %%
% % Use the mask |is_light_blue| to label which pixels belong to the blue
% % nuclei. Then display the blue nuclei in a separate image.

% nuclei_labels = repmat(uint8(0),[nrows ncols]);
% nuclei_labels(blue_idx(is_light_blue==false)) = 1;
% nuclei_labels = repmat(nuclei_labels,[1 1 3]);
% blue_nuclei = he;
% blue_nuclei(nuclei_labels ~= 1) = 0;
% figure;
% imshow(blue_nuclei), title('blue nuclei');

