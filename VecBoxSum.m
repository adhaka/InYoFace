function b_vec = VecBoxSum(x, y, w, h, W, H)

a = [y-1, x-1];
b = [y+h-1, x-1];
c = [y-1, x+w-1];
d = [y+h-1, x+w-1];

b_vec = zeros(1, W*H);

if y ~= 1 && x ~= 1
    b_vec((a(2)-1) * H + a(1)) = 1;
end
if x ~= 1
    b_vec((b(2)-1) * H + b(1)) = -1;
end
if y ~= 1
    b_vec((c(2)-1) * H + c(1)) = -1;
end
b_vec((d(2)-1) * H + d(1)) = 1;

end

