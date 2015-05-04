function ii_ims = LoadImDataDir(dirname, varargin)

face_fnames = dir([dirname, '*.bmp']);

disp(dirname);
disp(face_fnames);
im_fname = [dirname , face_fnames(1).name];

dirSize = length(face_fnames);

nVararg = length(varargin);
disp(nVararg);
numImages = dirSize;

if nVararg > 0
    numImages = varargin{1};
end

disp(im_fname);
[ii1, ii_im1] = LoadIm(im_fname);
ii_ims = ii_im1(:);

for i = 2:numImages
    img = [dirname, face_fnames(i).name]; 
    [ii, ii_im] = LoadIm(img);
    col_ii_iim = ii_im(:);
    ii_ims = [ii_ims col_ii_iim];
    
end


end