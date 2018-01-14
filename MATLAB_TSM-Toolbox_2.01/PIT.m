[x Fs] = audioread('Xia_a_C4.wav');
start_f = 1.2;
end_f = 2;
del_f =end_f - start_f ;
k_spline = 4;
x_len = length(x);
f_tbl = [start_f:del_f/(x_len-2):end_f];
f_tbl_cum = cumsum(f_tbl);
stretch_ratio = sum(f_tbl)/(x_len-1);
%%%stretching input x
x_str = wsolaTSM(x,stretch_ratio);
yy = zeros([1,x_len]);
yy(1) = x_str(1);
ana_pnts = [ana_start:ana_end];
yy(2:end) = spline(1:length(x_str),x_str,f_tbl_cum);
