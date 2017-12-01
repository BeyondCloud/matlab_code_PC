%======================================================================================
% PARAMETERS RELATING TO THE AUTODETECTION OF THE SUSTAINING PORTION OF THE INPUT     %
% WAVE FILE                                                                           %
%======================================================================================
[y,Fs] = audioread('Xia_a.wav');
y_len = 352000;
y = y(1:y_len);
y_sub = y;
N_ave = 100;
averages = zeros(y_len/N_ave,1);
for i =1:size(averages)
    averages(i) = mean(y((i-1)*N_ave+1:i*N_ave));
    y_sub((i-1)*N_ave+1:i*N_ave) = y((i-1)*N_ave+1:i*N_ave) - averages(i);
end

