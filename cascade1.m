%%
%% Train an unintelligent cascade
%%

%% Create training data

train_inds = 1:2:13954;  % every other photo in training images
all_ftypes = EnumAllFeatures(19,19);
SaveTrainingData(all_ftypes, train_inds, 'simple_cascade_training_data.mat');


%%
facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';
faces = LoadImDataDir(facesDir);
non_faces = LoadImDataDir(nonfacesDir);
all_images = [faces, non_faces];


%% Define parameters
% Number of stages in the classifier.
stages = 10;
% FPR for each stage in the cascade.
f = 0.3;
% Detection rate for each stage.
d = 0.99;
% Desired detection rate of the cascade.
Dtarget = 0.9;
% Desired FPR of the cascade
Ftarget = 6e-6;
% Number of features per stage.
nrf = 20;

%% Prepare the validation set
Tdata = load('simple_cascade_training_data.mat');

[val_images, val_inds, val_targets] = getValidationData(Tdata);


%% Do the training

% Set of positive and negative examples
P = Tdata.ii_ims(Tdata.ys == 1);
N = Tdata.ii_ims(Tdata.ys == -1);

% Cascade
cascade = cell(stages,1);

% Initial values for dr and fpr
D0 = 1;
F0 = 1;
i=0;
thresholds = ones(stages,1)*20;
D = ones(stages,1);
F = ones(stages,1);

% while F > Ftarget
for j=1:10
    i=i+1;
    n = 0;
    if i==1
        F(i) = F0;
    else
        F(i) = F(i-1);
    end
    
    % This should later be inside a loop to select number of features
    cascade{i} = BoostingAlgMat(Tdata, nrf);
    scores = ApplyDetector(cascade{i}, val_images);
    
    preds = (scores > thresholds(i))*2 -1;
    tp = sum(preds == 1 & val_targets == 1);
    tn = sum(preds == -1 & val_targets == -1);
    fp = sum(preds == 1 & val_targets == -1);
    fn = sum(preds == -1 & val_targets == 1);

    tpr = tp/(tp+fn);
    fpr = fp/(fp+tn);
    if i==1
        D(i) = D0*tpr;
    else
        D(i) = D(i-1)*tpr;
    end
    
    if i==1
        condition = d;
    else
        condition = D(i-1)*d;
    end
    
    while D(i) < condition
        thresholds(i) = thresholds(i)-0.01;
        preds = (scores > thresholds(i))*2 -1;
        tp = sum(preds == 1 & val_targets == 1);
        tn = sum(preds == -1 & val_targets == -1);
        fp = sum(preds == 1 & val_targets == -1);
        fn = sum(preds == -1 & val_targets == 1);

        tpr = tp/(tp+fn);
        fpr = fp/(fp+tn);
        if i==1
            D(i) = tpr;
        else
            D(i) = D(i-1)*tpr;
        end
    end
    
    if i==1
        F(i)=F0*fpr;
    else
        F(i) = F(i-1)*fpr;
    end
    % prune the training images
    % N <- O
    
    % evaluate the current cascade on non face images
    for params in cascade
        scores = ApplyDetector(cascade{i}, non_faces);
    end
    
    % add the false positive to the training images
    preds = (scores > thresholds(i))*2 -1;
    fpinds = find(preds == 1) + size(faces,2);
    
    
    
    
    
    ims = Tdata.ii_ims(Tdata.ys == 1);
    Tdata.ii_ims = [ims, all_images(fpinds)];
    
    all_inds = 1:13954; % don't hardcode like this
    train_inds = Tdata.train_inds;
    val_inds;
    fpinds = val_inds(val_targets == -1 & preds == 1);
    Tdata.ii_ims = [ims, all_images(fpinds)];
    Tdata.train_inds = [Tdata.train_inds, fpinds];

end







