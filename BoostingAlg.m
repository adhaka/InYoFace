function Cparams = BoostingAlg(Tdata, T)
alphas = zeros(T,1);
Thetas = zeros(T, 3);
ys = Tdata.ys;
outfmat = zeros(T, size(Tdata.fmat, 2));
outftypes = zeros(T, size(Tdata.all_ftypes, 2));

m = sum(ys == -1);
n = size(ys, 2);
w = zeros(1,n);
inds = ys == -1;
w(inds) = 1/(2*m);
w(~inds) = 1/(2*(n-m));

fmat = Tdata.fmat;
all_ftypes = Tdata.all_ftypes;
[featcount, ~]= size(fmat);
% Feature responses
fw = fmat * Tdata.ii_ims;

ps = zeros(1, featcount);
errval = zeros(1, featcount);
thetaval = zeros(1, featcount);
for t = 1:T
    for j = 1:featcount
        fs = fw(j,:);
        mu_p = sum(w .* (1 + ys) .* fs) / sum(w .* (1 + ys));
        mu_n = sum(w .* (1 - ys) .* fs) / sum(w .* (1 - ys));

        theta = 0.5 * (mu_p + mu_n);

        gs_n = (-1 * fs < -theta) * 2 - 1;
        gs_p = (fs < theta) * 2 - 1;

        err_n = 0.5 * sum(w .* abs(ys - gs_n));
        err_p = 0.5 * sum(w .* abs(ys - gs_p));

        if err_n < err_p
            ps(j) = -1;
            errval(j) = err_n;
        else
            ps(j) = 1;
            errval(j) = err_p;
        end
        thetaval(j) = theta;
        %[thetaval(j), ps(j) , errval(j)] = LearnWeakClassifier(w, fw(j,:), ys);
    end

    [minerr, minind] = min(errval);
    thetaerr = thetaval(minind);
    %disp(minind);
    Thetas(t,1) = minind;
    Thetas(t,2) = thetaerr;
    Thetas(t,3) = ps(minind);

    alphas(t) = 0.5*log((1-minerr)/minerr);

    hs = (ps(minind) .* fmat(minind, :) * Tdata.ii_ims < ps(minind) * thetaerr) * 2  - 1;

    w = w .* exp(-alphas(t) * ys .* hs );
    w = w/sum(w);

    outfmat(t,:) = fmat(minind,:);
    outftypes(t,:) = all_ftypes(minind,:);
end

Cparams.alphas = alphas;
Cparams.Thetas = Thetas;
Cparams.fmat = outfmat;
Cparams.all_ftypes = outftypes;

end 