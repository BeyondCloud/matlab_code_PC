clear;
clc;

%meter
stretch_len = 2; 
orig_len = 1;

balls  =3
sec = 8;

% N/m
k = 3;

%kg
str_mass = 0.02;

% Hz, sampling frequency
Fs=1000;

fps = 60;
damp_factor = 0.9;

%========only modify code obove while simulating================
seg_len = (orig_len)/(balls-1);

node_x =  linspace(0,stretch_len,balls)
node_x_next =  linspace(0,stretch_len,balls)

v0_x =  linspace(0,0,balls)
node_x(2) = 0.75
if(node_x(2) < seg_len)
    node_x(2) = seg_len*1.5;
    error('initial length too short ');
end
pnt_mass = str_mass/(balls-1);
del_t = 1/Fs

for frame = 0:fps*sec
    for j = 0:del_t:1/fps
        for i = 2:1:balls-1
            force_L = k*((node_x(i) - node_x(i-1)) - seg_len);
            force_R = k*((node_x(i+1) - node_x(i)) - seg_len);
            a = (force_R-force_L)/pnt_mass;
            if(force_L<0 || force_R<0)
                 v0_x(i) = -v0_x(i)*0;
            end
            if(force_L<0 && force_R<0)
                 v0_x(i) = 0;
            end
            node_x_next(i) = node_x(i) + v0_x(i)*del_t +0.5*a*del_t^2;
            v0_x(i) = v0_x(i) + a*del_t ; 
        end
        node_x = node_x_next;
    end
    
    plot(node_x,linspace(0,0,balls),'o-');
    axis([0 stretch_len -1 1])
    pause(1/fps)
end