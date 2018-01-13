%return best match tail point
function best = match_tail(y,x)
    if size(x,1)<size(x,2)
        x = x';
    end
    if size(y,1)<size(y,2)
        y = y';
    end
    if length(y)<length(x)
       best = -1;
       disp('expect arg1 len > arg2 len');
       return;
    end
    err = zeros(length(y)-length(x)+1,1);
    for t = 1:length(err)
        del_tail = y(t+length(x)-1) - x(end);
        err(t) = sum(((y(t:t+length(x)-1)-x)-del_tail).^2);
    end
    [min_val, min_idx] = min(err);
    best = min_idx+length(x)-1;
%     plot(y(best-length(x)+1:best));
end