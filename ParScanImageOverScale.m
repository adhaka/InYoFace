function dets = ParScanImageOverScale(Cparams, im, min_s, max_s, step_s)
DETS = zeros(1000,4);
tot = 0;
spmd
    dets = zeros(1000,4);
    for s=min_s:step_s:max_s
        s
        det = ScanImageFixedSize(Cparams, imresize(im,s));
        det = round(det / s);
        n = size(det,1);
        dets(tot+1:tot+n,:) = det;
        tot = tot+n;
    end

    dets = dets(1:tot,:);
    dets = PruneDetections(dets, [], 0.1, 'average');
end
DETS = zeros(1000,4,length(min_s:step_s:max_s));
parfor s=min_s:step_s:max_s
    
end


end