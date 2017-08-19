clear;
clc;

%meter
len = 2; 
mass = 0.2; %kg
T = 800;    %N
balls  =11
del_x = len/(balls-1);
density = mass/(balls-1);
v = T/density;
sec = 8;

% Hz, sampling frequency
Fs=1000;
fps = 60;
%==========initial ball position===========================
node_x =  linspace(0,len,balls)
node_y = linspace(0,0,balls)
node_y(1:(balls+1)/2) = linspace(0,0.5,(balls+1)/2)
node_y((balls+1)/2:balls) = linspace(0.5,0,(balls+1)/2)
%=========================================================
prev_y = node_y;
for i = 2:balls-1
    ddy = 2*node_y(i)-node_y(i-1)-node_y(i+1)/(del_x^2)
    
    plot(node_x,node_y,'o-');
    axis([0 len -1 1]);

end




