
function ComputeROC(Cparams, Tdata)

%% Load the face and non face images
facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';
face_ii = LoadImDataDir(facesDir);
nonface_ii = LoadImDataDir(nonfacesDir);

all_images = [face_ii, nonface_ii];
size(all_images)
total_ims = size(all_images, 2);
face_ims = size(face_ii, 2);
targets = ones(1, total_ims);

targets(face_ims+1:end) = -1; % targets of non images are -1
size(targets)

train_inds = Tdata.train_inds;
total_inds = 1:total_ims;

test_inds = setdiff(total_inds, train_inds);

test_images = all_images( :, test_inds);
test_targets = targets(:, test_inds);

disp(size(test_targets));
disp(size(test_images));
scores= ApplyDetector(Cparams, test_images);

Threshold = -100:0.01:100;
tprVec = zeros(1, length(Threshold));
fprVec = zeros(1, length(Threshold));

for t = 1:size(Threshold,2)
    preds = (scores > Threshold(t))*2 -1;
    tp = sum(preds == 1 & test_targets == 1);
    tn = sum(preds == -1 & test_targets == -1);
    fp = sum(preds == 1 & test_targets == -1);
    fn = sum(preds == -1 & test_targets == 1);
    tpr = tp/(tp+fn);
    fpr = fp/(fp+tn);
    tprVec(t) = tpr;
    fprVec(t) = fpr;
%     if tpr > 0.7
%         tpr
%         Threshold(t)
%     end
end

plot(fprVec, tprVec)
axis([0 1 0 1])

end