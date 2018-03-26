function [MCD] = mcd_function(mT,mC)
% MCD function
% 10/ln10*sprt(2*sigma((target-converted)^2))
% function [MCD] = mcd_function(mT,mC)
% Author: tedwu 2016/6/22
% Last update: 2016/6/22
cTen = 10/log(10);
mDiff = bsxfun(@minus,mT,mC);
mDiff2 = bsxfun(@power,mDiff,2);
mSumDim = sum(mDiff2,1);
mSqrt = sqrt(2*mSumDim);
MCD = mean(cTen*mSqrt);
end