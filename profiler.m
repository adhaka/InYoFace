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