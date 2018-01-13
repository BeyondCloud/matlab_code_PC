[y,Fs] = audioread('my_a.wav');

win_len = 512; %feature window
% normalize amp of wav
my_a_unit = unit_amp(y,0.3,320);
feat_win = my_a_unit(end-win_len+1:end);

y_buf = my_a_unit(1:end-win_len);
pnt = match_tail(y_buf,feat_win);
update_buf = y_buf(pnt+1:end);

%remove y offset
% update_buf = update_buf - (y_buf(pnt)-my_a_unit(end));
my_a_stretch = [my_a_unit;update_buf;update_buf];

audiowrite('my_a_stretch.wav',my_a_stretch,44100);