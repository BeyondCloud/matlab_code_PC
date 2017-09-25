function y = diffcum(x)
   if(size(x,1) ~= 1 && size(x,2) ~= 1)
        error('diffcum error:expect 1xn or  nx1 array')
   end
   n = size(x,1)*size(x,2);
   dsum = 0;
   y= zeros(1, n); % dcum 0 is always 1,won't record
   for lag =  1:n
        dsum = dsum+x(lag);
        y(lag) = x(lag)/(dsum/(lag));
   end
end