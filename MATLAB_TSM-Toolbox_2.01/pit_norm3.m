% % fast linear interp
% [x Fs] = audioread('my_a2.wav');
% param.sr = Fs;
% [f0 t] = yin_f0(x,param);  %get freq_tbl
%240,1.3915
%245,1.4190
%250,1.4012

target_f = 300;


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
disp('done');
y = y(1:i-1); %truncate zero
[y0 ty] = yin_f0(y,param);
disp(max(y0)-min(y0));