
function ComputeROC(Cparams, Tdata)

[val_ims, ~, val_targets] = getValidationData(Tdata);

scores= ApplyDetector(Cparams, val_ims);

Threshold = min(scores):0.01:max(scores);
tprVec = zeros(1, length(Threshold));
fprVec = zeros(1, length(Threshold));

for t = 1:size(Threshold,2)
    [tpr, fpr] = getRates(scores, val_targets, Threshold(t));
    tprVec(t) = tpr;
    fprVec(t) = fpr;
    if tpr > 0.7
        tpr
        Threshold(t)
    end
end
figure
plot(fprVec, tprVec)
axis([0 1 0 1])

end