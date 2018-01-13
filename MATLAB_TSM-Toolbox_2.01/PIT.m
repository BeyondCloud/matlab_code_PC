[x Fs] = audioread('Xia_a_C4.wav');
start_f = 1.2;
end_f = 2;
del_f =end_f - start_f ;
k_spline = 4;
f_tbl = [start_f:del_f/(length(x)-1):end_f];
stretch_ratio = sum(f_tbl)/(length(x)-1);
%%%stretching input x
x_str = wsolaTSM(x,stretch_ratio);
samp_pnt = f_tbl(1)+1;
yy = zeros([1,44100]);
for i = 2:44100
    ana_start = max(1,ceil(samp_pnt-k_spline/2));
    ana_end = min(length(x_str),floor(samp_pnt+k_spline/2));
    ana_pnts = [ana_start:ana_end];
    yy(i) = spline(ana_pnts,x_str(ana_pnts),samp_pnt);
    samp_pnt=samp_pnt+f_tbl(i);
 end