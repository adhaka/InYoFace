function dets = CascadeScanImageOverScale(cascade, im, min_s, max_s, step_s)
dets = zeros(1000,4);
tot = 0;
for s=min_s:step_s:max_s
    s
    det = CascadeScanImageFixedSize(cascade, imresize(im,s));
    det = round(det / s);
    n = size(det,1);
    dets(tot+1:tot+n,:) = det;
    tot = tot+n;
end

dets = dets(1:tot,:);
dets = PruneDetections(dets, [], 0.1, 'average');
end