function x = fix_f0(x,k_stable,thres)
if nargin<2
  k_stable=200;
  thres=5;
end
    stable_cnt = 0;
    prev_stable_end = 1;
    i=2;
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
                next_start = i-k_stable+1;
                fix_range = [prev_stable_end next_start];
                unstable = prev_stable_end+1:next_start-1;
                x(unstable)=interp1(fix_range,x(fix_range),unstable);
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