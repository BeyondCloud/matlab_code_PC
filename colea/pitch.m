function [f0] = pitch(len,sr,xin)

% Copyright (c) 1995 Philipos C. Loizou
%


xin=hamming(len).*xin;
cn1=rceps(xin);

LF=floor(sr/500); 
HF=floor(sr/70);

cn=cn1(LF:HF);
[mx_cep ind]=max(cn);


if mx_cep > 0.09 & ind >LF
  f0= sr/(LF+ind);
else
  f0=0;
end


