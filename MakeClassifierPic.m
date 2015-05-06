function cpic = MakeClassifierPic(all_ftypes, chosen_f, alphas, ps, W, H)

cpic = zeros(H, W);
ws = alphas .* ps;

for i = 1:length(chosen_f)
    fpic = MakeFeaturePic(all_ftypes(chosen_f(i), :), W, H);
    cpic = cpic + fpic * ws(i);
end

end

