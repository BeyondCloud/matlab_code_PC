% fast linear interp

function y = pit_norm(x,target_f)
    param.sr = 16000;
    [f0 t] = yin_f0(x,param);  %get freq_tbl
    f0 = fix_f0(f0);
    y = zeros([length(x)*2,1]);  %create an zero array large enough
    ana_pnt  = t(1);
    i=1;
    cur_t = 1;
    while ceil(ana_pnt) < t(end)
       y(i) = x(floor(ana_pnt));
       while ana_pnt>=t(cur_t)
           cur_t = cur_t + 1;
       end
       if cur_t > length(t)
           break;
       end
       %linear interpolate
       r = (ana_pnt-t(cur_t-1))/(t(cur_t)-t(cur_t-1))*...
           (f0(cur_t)-f0(cur_t-1))+f0(cur_t-1);
       ana_pnt= ana_pnt+ target_f/r;
       i=i+1;
    end
    y = y(1:i-1); %truncate zero
    y= wsolaTSM(y,length(x)/length(y));
    disp('done');
    
%     [y0 t] = yin_f0(y,param);
%     disp('quality:');
%     disp(max(y0)-min(y0));
    
end