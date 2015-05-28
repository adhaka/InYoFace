Tdata = load('training_data.mat');
ftype = Tdata.fmat(12028, :);
ys = Tdata.ys;
m = sum(Tdata.ys == -1);
n = size(Tdata.ys, 2);
w = zeros(1,n);
inds = ys == -1;
w(inds) = 1/(2*m);
w(~inds) = 1/(2*(n-m));

fs = ftype * Tdata.ii_ims;

[theta, p, err] = LearnWeakClassifier(w, fs, ys);

sprintf('Theta = %f \np = %d\nerr = %f',theta, p, err)

%%
faces = fs(ys == 1);
non_faces = fs(ys == -1);

[counts, centers] = hist(faces);
plot(centers, counts/sum(counts), 'ro-');
hold on;
[counts, centers] = hist(non_faces);
plot(centers, counts/sum(counts), 'bo-');

%%
fpic = MakeFeaturePic([4,5,5,5,5],19,19);
imagesc(fpic);
colormap gray;

%%
cpic = MakeClassifierPic(Tdata.all_ftypes, [5192, 12765], [1.8725, 1.467], [1,-1], 19, 19);
imagesc(cpic);
colormap gray;

%%
dinfo6 = load('data/DebugInfo/debuginfo7.mat');
T = dinfo6.T;
Cparams = BoostingAlg(Tdata, T);
sum(abs(dinfo6.alphas - Cparams.alphas) > 0.000001)
sum(abs(dinfo6.Thetas(:) - Cparams.Thetas(:)) > 0.000001)
%%
fims = cell(11, 1);
for i = 1:10
    fims{i} = MakeFeaturePic(Cparams.all_ftypes(i,:), 19, 19);
end
cpic = MakeClassifierPic(Cparams.all_ftypes, 1:10, ...
    Cparams.alphas, sign(Cparams.Thetas(:,3)) ,19, 19);
fims{11} = cpic;
montage(fims, 'size', [1, 11]);
colormap gray;
colormap gray;