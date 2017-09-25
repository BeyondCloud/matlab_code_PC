%clear;
clc;
infilename = '_a_ao.wav';
[y,Fs] = audioread(infilename);
a = y(23000+35000:44100+35000);
len_a = size(a,1);
%for i = len_a-1000:len_a
[val idx] = min(abs(a(len_a-1000:len_a)));
%end
clip_a = a(10000:len_a-1000+idx-1);
seg = clip_a(1:25);
clip_len = size(clip_a,1);
seg_len = size(seg,1);
result = zeros(clip_len-seg_len,1);
for i=2:clip_len-seg_len
    result(i) = sum(abs(clip_a(i:i+seg_len-1)-seg));
end
%plot(result);

dcum= diffcum(result);


plot(dcum);
%8272
n = 4644;
aa = [clip_a(1:n);clip_a(1:n);clip_a(1:n);clip_a(1:n);clip_a(1:n)];
aa = [aa;aa];
sound(aa,Fs);
hold on
plot(aa);
for i = 1:5
    plot(i*n,aa(i*n),'*');
end
hold off

