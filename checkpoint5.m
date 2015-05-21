%% checkpoint 5

Dparams = load('Dparams.mat');
Tdata = load('training_data');
ComputeROC(Dparams, Tdata);
title('ROC')

Dparams.thresh = 4.3400;

%% 
im = imread('data/TestImages/big_one_chris.png');
profile clear
profile on

tic
dets = ScanImageOverScale(Dparams, im, 0.9, 1.1, 0.06);
toc
profile viewer
p = profile('info');
profsave(p,'profile_results')
DisplayDetections(im, dets);
