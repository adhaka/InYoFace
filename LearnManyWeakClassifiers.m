function [thetas, p, err] = LearnManyWeakClassifiers(ws, fs, ys)
[nF, N] = size(fs);

mus_p =  sum(bsxfun(@times, fs, ws .* (1 + ys)),2) / sum(ws .* (1 + ys));
mus_n =  sum(bsxfun(@times, fs, ws .* (1 - ys)),2) / sum(ws .* (1 - ys));

thetas = 0.5 * (mus_p + mus_n);

gss_n = (bsxfun(@gt,fs,thetas))'*2 - 1;
gss_p = (bsxfun(@lt,fs,thetas))'*2 - 1;
ys=ys';
errs_n = 0.5 * ws * abs(bsxfun(@minus,gss_n,ys));
errs_p = 0.5 * ws * abs(bsxfun(@minus,gss_p,ys));

inds = errs_n < errs_p;
p = zeros(nF, 1);
err = zeros(nF, 1);

p(inds) = -1;
err(inds) = errs_n(inds);
p(~inds) = 1;
err(~inds) = errs_p(~inds);

end

