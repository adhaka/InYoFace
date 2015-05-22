function [val_ims, val_inds, val_targets] = getValidationData(Tdata)

facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';
face_ii = LoadImDataDir(facesDir);
nonface_ii = LoadImDataDir(nonfacesDir);

all_images = [face_ii, nonface_ii];

total_ims = size(all_images, 2);
face_ims = size(face_ii, 2);
targets = ones(1, total_ims);

targets(face_ims+1:end) = -1; % targets of non images are -1

train_inds = Tdata.train_inds;
total_inds = 1:total_ims;

val_inds = setdiff(total_inds, train_inds);

val_ims = all_images( :, val_inds);
val_targets = targets(:, val_inds);
end