function fdets = PruneDetections(dets, responses, rho, method)

nd = size(dets,1);
% intersections
intersectionArea = rectint(dets,dets);
% unions
detArea = dets(:,3).*dets(:,4);
unionArea = repmat(detArea,1,nd) + repmat(detArea',nd,1).*(intersectionArea>0) - intersectionArea;
% overlappers
D = ( intersectionArea ./ unionArea ) > rho;
[S, C] = graphconncomp(sparse(D));
fdets = zeros(S,4);

if strcmp('average',method)
    for i=1:S
        fdets(i,:) = mean(dets(C==i,:),1);
    end
elseif  strcmp('max',method)
    for i=1:S
        [~, M] = max(responses.*responses(C==i));
        fdets(i,:) = dets(M,:);
    end
end
end



