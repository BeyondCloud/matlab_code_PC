clear;clc;
[val,~,raw] = xlsread('sampleScore');
lines = size(val,1);
items = size(raw,2);


utta =raw(2:size(raw,1),1);

t = val(2:lines,1);
note = val(2:lines,2);
PIT = val(2:lines,3);
DYN = val(2:lines,4);


for i = 1:lines-1
    fprintf('%d\t%d\t%d\t%d\n', t(i),note(i),PIT(i),DYN(i));
end