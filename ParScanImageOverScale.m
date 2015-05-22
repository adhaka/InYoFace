function dets = ParScanImageOverScale(Cparams, im, min_s, max_s, step_s)

steps = min_s:step_s:max_s;
DETS =  cell(length(steps),1);
disp('before loop')
parfor i=1:length(steps)
    s = steps(i)
    det = ScanImageFixedSize(Cparams, imresize(im,s));
    det = round(det / s);
    DETS{i} = det;
end
disp('after loop')
dets = [];
for i=1:length(steps)
    dets = [dets; DETS{i}];
end
%dets = PruneDetections(dets, [], 0.1, 'average');

end








