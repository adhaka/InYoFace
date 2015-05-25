function ImproveClassification(Cparams, Tdata)


%% Load the face and non face images

facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';
face_ii = LoadImDataDir(facesDir);
nonface_ii = LoadImDataDir(nonfacesDir);
% 
all_images = [face_ii, nonface_ii];
%

total_ims = size(all_images, 2);
face_ims = size(face_ii, 2);

targets = ones(1, total_ims);

targets(face_ims+1:end) = -1; % targets of non images are -1

train_inds = Tdata.train_inds;
total_inds = 1:total_ims;

test_inds_mat = zeros(1, total_ims);

test_inds = setdiff(total_inds, train_inds);
test_inds_mat(test_inds) = 1
disp(sum(test_inds_mat))


test_images = all_images( :, test_inds);
test_targets = targets(:, test_inds);

% scores= ApplyDetector(Cparams, test_images);

scores= ApplyDetector(Cparams, all_images);

%  set the threshold for false positives
Threshold = 1.82

preds = (scores > Threshold)*2 -1;
fpinds = find(preds == 1 & targets == -1 & test_inds_mat == 1);

disp(fpinds);
Tdata.train_inds = [Tdata.train_inds  fpinds];

T = 100
Cparams_new = BoostingAlg(Tdata, T)
ComputeROC(Cparams_new, Tdata)

axis([0 1 0 1])
