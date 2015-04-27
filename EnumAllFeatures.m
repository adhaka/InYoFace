function all_ftypes = EnumAllFeatures(W,H)
% rows = W-2 + floor(H/2) + W-w + H-2*h + H-2 + floor(W/2)-2 + W-2*w + H-h;
all_ftypes = zeros(H*H*W*W*4,5);

% type1 = cartprod([1], 2:W-w, 2:H-2*h, 1:W-2, 1:floor(H/2) );
% type2 = cartprod([2], 2:W-2*w, 2:H-h, 1:floor(W/2)-2, 1:H-2);
% type3 = cartprod([3], 2:W-3*w, 2:H-h, 1:floor(W/3)-2, 1:H-2);
% type4 = cartprod([4], 2:W-2*w, 2:H-2*h, floor(W/2)-2, 1:floor(H/2)-2);

% all_ftypes = [type1; type2; type3; type4];

i=1;
% Type I
for w = 1:W-2
    for h = 1:floor(H/2)
        for x = 2:W-w
            for y = 2:H-2*h
                all_ftypes(i,:) = [1, x, y, w, h];
                i = i+1;
            end
        end
    end
end

% Type II
for w = 1:floor(W/2)-2
    for h = 1:H-2
        for x = 2:W-2*w
            for y = 2:H-h
                all_ftypes(i,:) = [2, x, y, w, h];
                i = i+1;
            end
        end
    end
end

% Type III
for w = 1:floor(W/3)-2
    for h = 1:H-2
        for x = 2:W-3*w
            for y= 2:H-h
                all_ftypes(i,:) = [3, x, y, w, h];
                i = i+1;
            end
        end
    end
end

% Type IV
for w = 1:floor(W/2)-2
    for h = 1:floor(H/2)-2
        for x = 2:W-2*w
            for y = 2:H-2*h
                all_ftypes(i,:) = [4, x, y, w, h];
                i = i+1;
            end
        end
    end
end

% trimmmmming
all_ftypes = all_ftypes(1:i-1,:);

end