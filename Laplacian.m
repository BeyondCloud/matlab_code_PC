clc
clf
clear
A = imread('Gauss.jpg');
%A = [ 1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4; 1 4 7 4 1];
B = double(rgb2gray(A))

Gx = [-1 0 1;-2 0 2;-1 0 1];
%C = conv2(B,Gx)
%C= mod(abs(100*del2(B)),255);
for i = 1: 342
    for j = 1: 342
                k = B(i,j);
                [x y z] =[i j k]; 
    end
end
surf(x,y,z);

% C = del2(B);
% subplot(2,1,1)
% surf(C, []);
% subplot(2,1,2)
% imshow(C, []);
% m = max(C)
