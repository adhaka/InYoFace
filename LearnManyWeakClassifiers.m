function [thetas, p, err] = LearnManyWeakClassifiers(ws, fs, ys)
[nF, N] = size(fs);
%tic
% mus_p =  sum(repmat(ws .* (1 + ys),nF,1) .* fs,2) ./ sum(ws .* (1 + ys));
% mus_n =  sum(repmat(ws .* (1 - ys),nF,1) .* fs,2) ./ sum(ws .* (1 - ys));
%toc
tic
mus_p =  sum(bsxfun(@times, fs, ws .* (1 + ys)),2) / (ws * (1 + ys)');
mus_n =  sum(bsxfun(@times, fs, ws .* (1 - ys)),2) / (ws * (1 - ys)');
toc
tic
thetas = 0.5 * (mus_p + mus_n);
thetamat = repmat(thetas,1,N);

gss_n = (-1 * fs < - thetamat) * 2 - 1;
gss_p = (fs < thetamat) * 2 - 1;

ysmat = repmat(ys,nF,1);
errs_n = 0.5 * abs(ysmat-gss_n) * ws';
errs_p = 0.5 * abs(ysmat-gss_p) * ws';

inds = find(errs_n < errs_p);
p = zeros(nF, 1);
err = zeros(nF, 1);

p(inds) = -1;
err(inds) = errs_n(inds);
p(~inds) = 1;
err(~inds) = errs_p(~inds);

end

