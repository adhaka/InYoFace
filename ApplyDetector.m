function scs = ApplyDetector(Cparams, ii_ims)

Alphas = Cparams.alphas;
Thetas = Cparams.Thetas(:,2);
ps = Cparams.Thetas(:,3);
fmat = Cparams.fmat;
T = size(Alphas, 1);

numIms = size(ii_ims, 2);
psmat = repmat(ps, 1, numIms);
hs1 = psmat .* ( fmat * ii_ims);


Thetamat = repmat(ps .* Thetas, 1, numIms);
Alphamat = repmat(Alphas, 1, numIms);


hs =  Alphamat .* ((psmat .* (fmat * ii_ims) < Thetamat) * 2  - 1);
scs = sum(hs);  

end