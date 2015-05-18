function dets = ScanImageFixedSize(Cparams, im)

%im = imread(im_name);
im1 = double(rgb2gray(im));
[H, W] = size(im1);

im1 = (im1 - mean(im1(:))) / max(realmin, std(im1(:)));
im2 = im1 .* im1;

ii_im1 = cumsum(cumsum(im1, 1), 2);
ii_im2 = cumsum(cumsum(im2, 1), 2);

i = 1;
subws = zeros(361, (W-2)*(H-2));
all_patches = zeros((W-2)*(H-2), 4);

for x = 2:W-19-1
    for y = 2:H-19-1
        s1 = ii_im1(y-1, x-1) - ii_im1(y+19-1, x-1) - ii_im1(y-1, x+19-1) + ii_im1(y+19-1, x+19-1);
        s2 = ii_im2(y-1, x-1) - ii_im2(y+19-1, x-1) - ii_im2(y-1, x+19-1) + ii_im2(y+19-1, x+19-1);
        mu = s1 / 361;
        sigma = (s2 - 361*mu*mu) / 360;
        subw = (ii_im1(y:y+19-1, x:x+19-1) - mu) / sigma;
        subws(:,i) = subw(:);
        all_patches(i,:) = [x, y, 19, 19];
        i = i+1;
    end
end

det_ids = ApplyDetector(Cparams, subws) > 3;
dets = all_patches(det_ids,:);

end

