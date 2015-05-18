%% sanity check program 12
Cparams = load('Cparams');
[im, ii_im] = LoadIm('data/TrainingImages/FACES/face00001.bmp');
scs = ApplyDetector(Cparams, ii_im(:))

%%  sanity check program 13
Tdata = load('training_data');
ComputeROC(Cparams, Tdata);
title('ROC')

%% Debug Point 70%

