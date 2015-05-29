function predictions = ApplyCascade(cascade, images, mu, sigma)

predictions = ones(1,size(images,2));
for c=1:size(cascade,1) % run through the cascade
    scores = ApplyDetectorAdapt( cascade{c}, images, mu, sigma );
    predictions = predictions && ( scores > cascade{c}.thresh );
    if predictions == 0
        break;
    end
end

predictions = predictions*2 - 1;

end