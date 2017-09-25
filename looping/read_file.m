clear;clc;
dinfo = dir('*.wav');
for K = 1 : length(dinfo)
  thisfilename = dinfo(K).name;  %just the name
  disp(thisfilename);
end