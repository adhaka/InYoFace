function SaveTrainingData(all_ftypes, train_inds, s_fn)
% Define paths
facesDir = 'TrainingImages/FACES/';
nonfacesDir = 'TrainingImages/NFACES/';

% Load images
face_ii = LoadImDataDir(facesDir);
nonface_ii = LoadImDataDir(nonfacesDir);
ii_ims = [face_ii, nonface_ii];

% 1: face, -1: non face 
ys = [ones(1,size(face_ii,2)), -ones(1,size(nonface_ii,2))];

% get the features
W = 19;  %%%% HARD CODED!!!! %%%%%% This is lame.
H = 19;
fmat = VecAllFeatures(all_ftypes, W, H);

ii_ims = ii_ims(:,train_inds);
ys = ys(train_inds);

save(s_fn, 'ii_ims', 'fmat', 'all_ftypes', 'W', 'H');



end