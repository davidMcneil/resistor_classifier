function [outImg] = findClusters(img, n, K)
    means = randomizeMeans(K, round(rand(1)*100));
    img = double(img);
    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);
    [r, c, d] = size(img);
    for n=1:n % Opposed to testing for convergence 
        % Initialze distance matrix
        dist = (img(:,:,1) - means(1, 1)).^2 + ...
               (img(:,:,2) - means(1, 2)).^2 + ...
               (img(:,:,3) - means(1, 3)).^2;
        meanIdentity = ones(r, c);
        % Assign pixels
        for k=2:K % Start at 2 due to intialization
            newDist = (img(:,:,1) - means(k, 1)).^2 + ...
                      (img(:,:,2) - means(k, 2)).^2 + ...
                      (img(:,:,3) - means(k, 3)).^2;
            idx = find(newDist < dist);
            dist(idx) = newDist(idx);
            meanIdentity(idx) = k;
        end
        % Recalculate means
        for k=1:K
            idx2 = find(meanIdentity == k);
            if size(idx2, 1) ~= 0
                means(k, 1) = mean(red(idx2));
                means(k, 2) = mean(green(idx2));
                means(k, 3) = mean(blue(idx2));
            end
        end
    end
    % Color image
    for k=1:K
        idx3 = find(meanIdentity == k);
        if size(idx3, 1) ~= 0
            red(idx3) = means(k, 1);
            green(idx3) = means(k, 2);
            blue(idx3) = means(k, 3);
        end
    end
    outImg(:,:,1) = uint8(red);
    outImg(:,:,2) = uint8(green);
    outImg(:,:,3) = uint8(blue);
end
