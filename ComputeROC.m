
function ComputeROC(Cparams, Tdata)

facesDir = 'data/TrainingImages/FACES/';
nonfacesDir = 'data/TrainingImages/NFACES/';

face_ii = LoadImDataDir(facesDir);
nonface_ii = LoadImDataDir(nonfacesDir);

dinfo5 = load('data/DebugInfo/debuginfo5.mat');
all_images = [face_ii, nonface_ii];
size(all_images)
total_ims = size(all_images, 2);
face_ims = size(face_ii, 2);
targets = ones(1, total_ims);

targets(face_ims+1:end) = -1;
size(targets)
train_inds = dinfo5.train_inds;

total_inds = 1:total_ims;

test_inds = setdiff(total_inds, train_inds);

test_images = all_images( :, test_inds);
test_targets = targets(:, test_inds);

disp(size(test_targets));
disp(size(test_images));
scores= ApplyDetector(Cparams, test_images);

Threshold = [0 0.2 0.4 0.8 1.0 1.25 1.5 1.75 2.0 2.5 3.0 3.5 4.0 4.5 5 6 7 8 9 10 12 15 ];
tprVec = zeros(1, length(Threshold));
fprVec = zeros(1, length(Threshold));

for t = 1:size(Threshold)
    
    thresh = Threshold(t);
    preds = (scores > Threshold(t))*2 -1;
    tp = sum(preds == 1 & test_targets == 1);
    tn = sum(preds == -1 & test_targets == -1);
    fp = sum(preds == 1 & test_targets == -1);
    fn = sum(preds == -1 & test_targets == 1);
    tpr = tp/(tp+fn);
    fpr = fp/(fp+tn);
    tprVec(t) = tpr;
    fprVec(t) = fpr;
    
end

plot(fprVec, tprVec)
axis([0 1 0 1])

end