%% checkpoint 4
Cparams = load('Cparams.mat');
im = imread('data/TestImages/one_chris.png');
dets  = ScanImageFixedSize(Cparams, im);
DisplayDetections(im, dets);
figure
DisplayDetections(im, PruneDetections(dets,[],0.7,'average'));

%% scales
im = imread('data/TestImages/big_one_chris.png');
tic
dets = ScanImageOverScale(Cparams, im,0.6,1.3,0.06);
toc
figure
DisplayDetections(im, dets);