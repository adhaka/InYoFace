function [theta, p, err] = LearnWeakClassifier(ws, fs, ys)

mu_p = ws .* (1 + ys) * fs / (ws * (1 + ys));
mu_n = ws .* (1 - ys) * fs / (ws * (1 - ys));

theta = 0.5 * (mu_p + mu_n);

gs_n = (-1 * fs < -theta) * 2 - 1;
gs_p = (fs - theta) * 2 - 1;

err_n = 0.5 * ws * (ys - gs_n);
err_p = 0.5 * ws * (ys - gs_p);

if err_n < err_p
    p = -1;
    err = err_n;
else
    p = 1;
    err = err_p;
end

end

