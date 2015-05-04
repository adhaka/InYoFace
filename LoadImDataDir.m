function ii_ims = LoadImDataDir(dirname, varargin)

face_fnames = dir('data/TrainingImages/FACES/*.bmp')

im_fname = ['data/TrainingImages/FACES/' , face_fnames(1).name]

dirSize = length(face_fnames);

[ii1, ii_im1] = LoadIm(im_fname);
ii_ims = ii_im1(:);

nVararg = length(varargin);
disp(nVararg);
numImages = dirSize;

if nVararg > 0
    numImages = varargin{1};
end

for i = 2:numImages
    img = ['data/TrainingImages/FACES/', face_fnames(i).name]; 
    [ii, ii_im] = LoadIm(img);
    col_ii_iim = ii_im(:);
    ii_ims = [ii_ims col_ii_iim];
    
end


end