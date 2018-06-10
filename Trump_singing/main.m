
addpath('E:\Matlab_code\MATLAB_TSM-Toolbox_2.01');

ratio = (f0_pit/2^(0/12))./f0_lyc;
% ratio  = ones(size(ratio));
frame_size = 6000;

nframes = ceil(x_len/frame_size);
x = [x_talk;zeros(nframes*frame_size-length(x_talk),1)];
x_len = length(x);
result = zeros(x_len,1);
for i = 1:0.5:nframes-0.5
    range =( ((i-1)*frame_size+1):i*frame_size);
    r = modify_pit(x(range),ratio(range),fs);
    r = r/max(r)*0.3;
    r = r.*win(length(r),1);
    result(range) = result(range)  +r;
    disp(range(1))
end

sound(result,22050);
