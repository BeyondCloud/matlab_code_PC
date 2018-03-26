function [d1,d2] = min_unique(sp1,sp2,d1,d2)
    % check for d1
    [C,~,~] = unique(d1); 
    idx_final = [];
    for i = 1:length(C)
        idx = find(d1 ==C(i));
        dist = sum((sp1(:,d1(idx)) - sp2(:,d2(idx))).^2,1); % find the min one in the same conponent
        [~,I] = min(dist);
        idx_final = [idx_final idx(I)];
    end
    d1 = d1(idx_final);
    d2 = d2(idx_final);
    
    % check for d2
    [C,~,~] = unique(d2);
    idx_final = [];
    for i = 1:length(C)
        idx = find(d2 ==C(i));
        dist = sum((sp1(:,d1(idx)) - sp2(:,d2(idx))).^2,1); % find the min one in the same conponent
        [~,I] = min(dist);
        idx_final = [idx_final idx(I)];
    end   
    d1 = d1(idx_final);
    d2 = d2(idx_final);   
end