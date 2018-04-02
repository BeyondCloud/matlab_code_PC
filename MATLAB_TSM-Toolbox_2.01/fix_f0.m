function x = fix_f0(x)
    k_stable =20;
    thres = 5;
    stable_cnt = 0;
    prev_stable_end = 1;
    i=2
    while i <=length(x)
        if abs(x(i)-x(i-1))<thres
            stable_cnt=stable_cnt+1;
        else
            stable_cnt = 0;
        end
        
        if stable_cnt>=k_stable
            %fix spike
            if prev_stable_end == 1
                x(1) = x(i);
            end
                edge = [prev_stable_end i];
                unstable = prev_stable_end+1:i-1;
                x(unstable)=interp1(edge,x(edge),unstable);
            while abs(x(i)-x(i-1))<thres
                i=i+1;
                if(i>length(x))
                    break;
                end
                
            end
            prev_stable_end = i-1;
            stable_cnt = 0;
        end
        i=i+1;
    end
    x(prev_stable_end:end) = x(prev_stable_end);
end