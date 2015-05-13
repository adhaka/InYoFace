function Cparams = BoostingAlg(Tdata, T)
alphas = zeros(T,1);
Thetas = zeros(T, 3);
ys = Tdata.ys;
outfmat = zeros(T, size(Tdata.fmat, 2));
outftypes = zeros(T, size(Tdata.all_ftypes, 2));

m = sum(Tdata.ys == -1);
n = size(Tdata.ys, 2);
w = zeros(1,n);
inds = ys == -1;
w(inds) = 1/(2*m);
w(~inds) = 1/(2*(n-m));

fmat = Tdata.fmat(:,:);
all_ftypes = Tdata.all_ftypes;
[featcount, ~]= size(fmat);

for t = 1:T
%     w = w/sum(w);
    ps = zeros(1, featcount);
    errval = zeros(1, featcount);
    thetaval = zeros(1, featcount);
    % maybe this can be done without a loop
    fw = fmat * Tdata.ii_ims;
    for j = 1:featcount
        %fw = fmat(j,:);
        fs = fw(j,:);%fw * Tdata.ii_ims;
        [thetaval(j), ps(j) , errval(j)] = LearnWeakClassifier(w, fs, ys);
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
% disp(w);

Cparams.alphas = alphas;
Cparams.Thetas = Thetas;
Cparams.fmat = outfmat;
Cparams.all_ftypes = outftypes;

end 