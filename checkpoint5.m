%% checkpoint 5

Dparams = load('Dparams.mat');
Tdata = load('training_data');
ComputeROC(Dparams, Tdata);
title('ROC')

Dparams.thresh = 4.3400; % threshold for 70 percent

%% test image
im = imread('data/TestImages/big_one_chris.png');
profile clear
profile on

tic
dets = ScanImageOverScale(Dparams, im, 0.6, 1.3, 0.06);
toc
profile viewer
p = profile('info');
profsave(p,'profile_results')
DisplayDetections(im, dets);

%% start parallel pool
numThreads = 3;
parpool(numThreads);

%% close the pool
delete(gcp);

%% parallel

im = imread('data/TestImages/facepic2.jpg');
profile clear
profile on

tic
disp('before function')
dets = ParScanImageOverScale(Dparams, im, 0.4, 1, 0.06);
toc

profile viewer
p = profile('info');
profsave(p,'profile_results')
DisplayDetections(im, dets);
%% Test images:
ims = cell(4,1);
ims{1} = imread('data/TestImages/many_faces.jpg');
ims{2} = imread('data/TestImages/Student4.jpg');
ims{3} = imread('data/TestImages/IMG_0181.jpg');
ims{4} = imread('data/TestImages/facepic2.jpg');
for i=1:4
    tic
    dets = ParScanImageOverScale(Dparams, ims{i}, 0.4, 1.3, 0.06);
    toc
    figure
    DisplayDetections(ims{i}, dets);
end

