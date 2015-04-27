function fmat = VecAllFeatures(all_ftypes, W, H)

%N = size(all_ftypes, 1);
%fmat = zeros(N, W*H);

fmat = rowfun(VecFeature, all_ftypes, 'W', W, 'H', H);

end

