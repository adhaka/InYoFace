function [im, ii_im] = LoadIm(im_name)

im = double(rgb2gray(imread(im_name)));

% Normalize the image:
mu = mean(im(:));
sigma = std(im(:));
sigma = max(sigma, realmin);
im = (im - mu) / sigma;
% Integral image
ii_im = cumsum(cumsum(im,1),2);

end