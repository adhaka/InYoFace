function SaveTrainingData(all_ftypes, train_inds, s_fn, varargin)
% Define paths
facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';

% new training indices for additional training will use about 9000 training
% examples in place of just 6000.

x = 3:3:12000;
tot_inds = 1:1:12000;
train_inds = setdiff(tot_inds, x);

%


% Load images
if length(varargin) > 0
    numImages = varargin{1};
    face_ii = LoadImDataDir(facesDir,numImages);
    nonface_ii = LoadImDataDir(nonfacesDir,numImages);
else
    face_ii = LoadImDataDir(facesDir);
    nonface_ii = LoadImDataDir(nonfacesDir);
end
ii_ims = [face_ii, nonface_ii];

% 1: face, -1: non face 
ys = [ones(1,size(face_ii,2)), -ones(1,size(nonface_ii,2))];

% get the features
W = 19;  %%%% HARD CODED!!!! %%%%%% This is lame.
H = 19;
fmat = sparse(VecAllFeatures(all_ftypes, W, H));
ii_ims = ii_ims(:,train_inds);
ys = ys(train_inds);

save(s_fn, 'ii_ims', 'fmat', 'all_ftypes', 'W', 'H', 'ys', 'train_inds');
end