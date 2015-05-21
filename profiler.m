profile clear
profile on
Tdata=load('training_data.mat');
Tdata.fmat = sparse(Tdata.fmat);
tic
Dparams = BoostingAlg(Tdata, 10);
toc
profile viewer
p = profile('info');
profsave(p,'profile_results')

%%
profile clear
profile on

tic
Eparams = BoostingAlgMat(Tdata, 100);
toc
profile viewer
p = profile('info');
profsave(p,'profile_results')

%%
Tdata = load('training_data.mat');
fw = Tdata.fmat;
ys = Tdata.ys;
fs = fw * Tdata.ii_ims;


m = sum(ys == -1);
n = size(ys, 2);
w = zeros(n,1);
inds = ys == -1;
w(inds) = 1/(2*m);
w(~inds) = 1/(2*(n-m));
w=w';
%fs = repmat(fs,12000,1);
profile clear
profile on

tic
[theta, p, err] = LearnManyWeakClassifiers(w, fs, ys);
toc

profile viewer
p = profile('info');
profsave(p,'profile_results')
