function DisplayDetections(im, dets)

%im = imread(im_name);
nd = size(dets, 1);

imagesc(im);
for i = 1:nd
    rectangle('Position', dets(i,:), 'EdgeColor', 'r');
end

axis equal;

end

