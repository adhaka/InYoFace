%% Data augmentations contrast

facesDir = 'data/TrainingImages/FACES/';
face_fnames = dir([facesDir, '*.bmp']);
for i=1:length(face_fnames)
    i
    name = strcat(facesDir,face_fnames(i).name);
    im = imread(name);
    contdown = imadjust(im,[0.0; 1.0],[0.2; 0.8]);
    contup = imadjust(im,[0.35; 0.65],[0.0; 1.0]);
    imwrite(contup,sprintf('data/TrainingImages/FACES/contup%d.bmp',i));
    imwrite(contdown,sprintf('data/TrainingImages/FACES/contdown%d.bmp',i));
    
end
