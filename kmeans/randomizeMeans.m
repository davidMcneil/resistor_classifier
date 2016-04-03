function [means] = randomizeMeans(K, seed)
    % Generate K random means based on the seed 
    rand('state', seed);
    means = 255 .* rand(K,3); % creates a k-by-3 matrix of random numbers
end

