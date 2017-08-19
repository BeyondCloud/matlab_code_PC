clear;
clc;
A(1:69,1:69) = 0.5;
B=A;
C=A;

f = 1/12;
syms z;
for t=0:257
   B(25,25) = (1/2)*(sin(2*pi*f*t)+1);
       B(25,26) = B(25,25);
       B(25,24) = B(25,25);
       B(26,25) = B(25,25);
       B(24,25) = B(25,25);
   for i = 2:68
        for j = 2:68
                A(i,j)  = -C(i,j) + 2 *B(i,j) + ( B(i+1,j) +B(i-1,j) + B(i,j+1) +B(i,j-1) - 4 *B(i,j) )/4;
        end
   end
   for i = 1:49
       if i<=20 || i>22
                A(i,1)  = 0.5;
                A(i,49)  = 0.5;
                A(1,i)  = 0.5;
                A(49,i)  = 0.5;
       end
   end
   imshow(A,'InitialMagnification','fit');
   C = B;
   B = A;
   pause(0.01);
end