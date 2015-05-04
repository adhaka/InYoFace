function ii_ims = LoadImDataDir(dirname, varargin)

face_fnames = dir([dirname, '*.bmp']);
im_fname = [dirname, face_fnames(1).name];

dirSize = length(face_fnames);

nVararg = length(varargin);

numImages = dirSize;

if nVararg > 0
    numImages = varargin{1};
end

[ii1, ii_im1] = LoadIm(im_fname);

ii_ims = zeros(numel(ii_im1), numImages);

for i = 1:numImages
    
    img = [dirname, face_fnames(i).name]; 
    [ii, ii_im] = LoadIm(img);
    col_ii_iim = ii_im(:);
    ii_ims(:,i) = col_ii_iim;
    
end


end