function Cparams = BoostingAlg(Tdata, T)
Cparams.alphas = zeros(T,1);
Cparams.Thetas = zeros(T, 3);
ys = Tdata.ys;
Cparams.fmat = zeros(T, size(Tdata.fmat, 2));
Cparams.all_ftypes = zeros(T, size(Tdata.all_ftypes, 2));

m = sum(ys == -1);
n = size(ys, 2);
w = zeros(n,1);
inds = ys == -1;
w(inds) = 1/(2*m);
w(~inds) = 1/(2*(n-m));



[featcount, ~]= size(Tdata.fmat);
% Feature responses
fw = (Tdata.fmat * Tdata.ii_ims)';

ps = zeros(1, featcount);
errval = zeros(1, featcount);
thetaval = zeros(1, featcount);

ys = ys';
ysp = (1+ys);
ysn = (1-ys);
for t = 1:T
    t
    for j = 1:featcount
        fs = fw(:,j);
         
        wysp = w.*ysp;
        wysn = w.*ysn;

        mu_p = sum(wysp .* fs) / sum(wysp);
        mu_n = sum(wysn .* fs) / sum(wysn);

        theta = 0.5 * (mu_p + mu_n);

        gs_n = (fs > theta) * 2 - 1;
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
    end

    [minerr, minind] = min(errval);
    thetaerr = thetaval(minind);
    %disp(minind);
    Cparams.Thetas(t,1) = minind;
    Cparams.Thetas(t,2) = thetaerr;
    Cparams.Thetas(t,3) = ps(minind);

    Cparams.alphas(t) = 0.5*log((1-minerr)/minerr);

    hs = (ps(minind) .* Tdata.fmat(minind, :) * Tdata.ii_ims < ps(minind) * thetaerr) * 2  - 1;

    w = w .* exp(-Cparams.alphas(t) * ys .* hs' );
    w = w/sum(w);

    Cparams.fmat(t,:) = Tdata.fmat(minind,:);
    Cparams.all_ftypes(t,:) = Tdata.all_ftypes(minind,:);
end


end 