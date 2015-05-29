function [tpr, fpr] = getRates(scores, targets, threshold)

preds = (scores > threshold)*2 -1;
tp = sum(preds == 1 & targets == 1);
tn = sum(preds == -1 & targets == -1);
fp = sum(preds == 1 & targets == -1);
fn = sum(preds == -1 & targets == 1);

tpr = tp/(tp+fn);
fpr = fp/(fp+tn);

end