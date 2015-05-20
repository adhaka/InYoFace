function dets = ScanImageFixedSize(Cparams, im)

% Transform to grayscale
if (size(im,3)==3)
    im = rgb2gray(im);
end
im = double(im);
[H, W] = size(im);
% integral images
ii_im = cumsum(cumsum(im,1),2);
ii_im2 = cumsum(cumsum(im.*im,1),2);

h = 19; 
w = 19;
dets = zeros((H-h-1)*(W-w-1),4);
p = 1;

for y=1:H-19+1 %20
    for x=1:W-19+1 %20
        patch = ii_im(y:y+h-1,x:x+w-1);
        mu = patch(end,end);
        sigma2 = ii_im2(y+h-1,x+w-1);
        if x~=1
            mu = mu - ii_im(y+h-1,x-1);
            sigma2 = sigma2 - ii_im2(y+h-1,x-1);
        end
        if y~=1
            mu = mu - ii_im(y-1,x+w-1);
            sigma2 = sigma2 - ii_im2(y-1,x+w-1);
        end
        if x~=1 && y~=1
            mu = mu + ii_im(y-1,x-1);
            sigma2 = sigma2 + ii_im2(y-1,x-1);
        end
        mu = mu/(w*h);
        sigma = sqrt(abs((sigma2 - w*h*mu*mu)/(w*h-1)));
        
        if ApplyDetectorAdapt(Cparams, patch(:), mu, sigma) > Cparams.thresh
            dets(p,:) = [x,y,w,h];
            p=p+1;
        end
    end
end
dets = dets(1:p-1,:);

end
