function scs = ApplyDetectorAdapt(Cparams, ii_im, mu, sigma)

Alphas = Cparams.alphas;
Thetas = Cparams.Thetas(:,2);
ps = Cparams.Thetas(:,3);
fmat = Cparams.fmat;
all_ftypes = Cparams.all_ftypes;

T = size(Alphas, 1);

numIms = size(ii_ims, 2);
psmat = repmat(ps, 1, numIms);

ffin = (fmat * ii_ims) ./ sigma;

for i = 1:size(all_ftypes)
    if all_ftypes(i, 1) == 3
        ffin = ffin + all_ftypes(i,4) * all_ftypes(i,5) * mu/ sigma
    
    end
end

% hs1 = psmat .* ( fmat * ii_ims);

Thetamat = repmat(ps .* Thetas, 1, numIms);
Alphamat = repmat(Alphas, 1, numIms);


hs =  Alphamat .* ((psmat .* ffin < Thetamat) * 2  - 1);
scs = sum(hs);  

end