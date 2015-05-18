function dets = ScanImageFixedSize(Cparams, im)

%im = imread(im_name);
im1 = double(rgb2gray(im));
%im1 = double(im);
[H, W] = size(im1);

im1 = (im1 - mean(im1(:))) / max(realmin, std(im1(:)));
im2 = im1 .* im1;

ii_im1 = cumsum(cumsum(im1, 1), 2);
ii_im2 = cumsum(cumsum(im2, 1), 2);

i = 1;
subws = zeros(361, (W-19+1)*(H-19+1));
all_patches = zeros((W-19+1)*(H-19+1), 4);

for x = 1:W-19+1
    for y = 1:H-19+1
        s1 = ii_im1(y+19-1, x+19-1);
        s2 = ii_im2(y+19-1, x+19-1);
        if x-1 > 0 && y-1 > 0
            s1 = s1 + ii_im1(y-1, x-1);
            s2 = s2 + ii_im2(y-1, x-1);
        end
        if x-1 > 0
            s1 = s1 - ii_im1(y+19-1, x-1);
            s2 = s2 - ii_im2(y+19-1, x-1);
        end
        if y-1 > 0
            s1 = s1 - ii_im1(y-1, x+19-1);
            s2 = s2 - ii_im2(y-1, x+19-1);
        end
        
        mu = s1 / 361;
        sigma = (s2 - 361*mu*mu) / 360;
        
        subw = (ii_im1(y:y+19-1, x:x+19-1) - mu) / sigma;
        %mean(subw(:))
        %mean(ii_im1(:))
        subws(:,i) = subw(:);
        all_patches(i,:) = [x, y, 19, 19];
        i = i+1;
    end
end

%disp(num2str(ApplyDetector(Cparams, subws)))
det_ids = ApplyDetector(Cparams, subws) > Cparams.thresh;
dets = all_patches(det_ids,:);

end

