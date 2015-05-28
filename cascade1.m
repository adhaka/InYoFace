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


num_faces = size(faces,2);
num_non_faces = size(non_faces,2);


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

% Cascade
cascade = cell(stages+1,1);

% Initial values for dr and fpr

i=1;
thresholds = ones(stages+1,1);
D = ones(stages+1,1);
F = ones(stages+1,1);
D(1) = 1;
F(1) = 1;
% while F > Ftarget
for j=1:10
    
    i=i+1
    n = 0;
    F(i) = F(i-1);
    
    % This should later be inside a loop to select number of features
    %---------- start loop ----------
    cascade{i} = BoostingAlg(Tdata, nrf);
    scores = ApplyDetector(cascade{i}, val_images);
    thresholds(i) = max(scores);
    [tpr, fpr] = getRates(scores, val_targets, thresholds(i));
    
    D(i) = D(i-1)*tpr;
    condition = D(i-1)*d;
    
    while D(i) < condition
        thresholds(i) = thresholds(i)-0.01;
        [tpr, fpr] = getRates(scores, val_targets, thresholds(i));
        D(i) = D(i-1)*tpr;
    end
    F(i) = F(i-1)*fpr;
    %---------- end loop ----------
    cascade{i}.thresh = thresholds(i);
    % evaluate the current cascade on non face images
    predictions = ones(1,num_non_faces);
    for c=2:i % run through the cascade
        scores = ApplyDetector( cascade{i}, non_faces );
        predictions = predictions & ( scores > thresholds(c) );
    end
    
    % Append the misclassified non faces to the faces and add the training
    % indices which might be uneccessary.
    Tdata.ii_ims = [ faces(:,1:2:num_of_faces), non_faces(:,predictions) ];
    Tdata.train_inds = [ 1:2:num_of_faces,  find(predictions) + num_of_faces];
    Tdata.ys = [ones(1,length(1:2:num_of_faces)), -ones(1,sum(predictions))];
    [val_images, val_inds, val_targets] = getValidationData(Tdata);
end







