function fmat = VecAllFeatures(all_ftypes, W, H)

N = size(all_ftypes, 1);
fmat = zeros(N, W*H);

for i = 1:N
    fmat(i,:) = VecFeature(all_ftypes(i,:), W, H);
end

end

