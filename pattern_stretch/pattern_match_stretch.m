[y,Fs] = audioread('my_a.wav');
win_len = 512;
lookback_len = 10000;
update_len = 64;
my_a_unit = unit_amp(y,0.3,320);

feat_win = my_a_unit(end-win_len+1:end);
y_buf = my_a_unit(end-win_len-update_len-lookback_len+1:end-win_len-update_len);
y_buf_no_up = y_buf(1:end-update_len);
pnt = match_tail(y_buf_no_up,feat_win);
% update_buf = y_buf(pnt+1:pnt+update_len+1);
update_buf = y_buf(pnt+1:end);

%remove y offset
% update_buf = update_buf - (y_buf(pnt)-my_a_unit(end));
my_a_stretch = [my_a_unit;update_buf];

audiowrite('my_a_stretch.wav',my_a_stretch,44100);