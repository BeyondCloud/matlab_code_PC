function pitch_marks = find_pmarks(speech,fs)
%
% function pitch_marks = find_pmarks(speech)
%
%
% This MATLAB function calculates and returns the pitch marks (placed at
% peaks in the short-time energy function) for the input speech, that is
% assumed to be sampled at 8 KHz.
%
%           speech:     the input speech data
%
% W. Goncharoff (goncharo@ece.uic.edu)
% 06/12/97
%___________________________________________________________________________


p1 = round(fs/400);
p2 = round(fs/60);

spch = speech(:)';
xsamp = length(spch);


%calculate the approximate pitch contour based on energy peaks:
wlen = round((p1+p2)/3);
ecurve = conv(hanning(wlen)',spch.^2);
ecurve = conv(hanning(wlen)',ecurve);
ecurve = ecurve((1:xsamp)+wlen);
peaks = ([0,diff(ecurve)]>0) & ([diff(ecurve),0]<0);
index = 1:xsamp;
index(~peaks) = [];
Npeaks = length(index);
pitch = diff(index);
pitch1 = [pitch, pitch(Npeaks-1)];
pitch2 = [pitch(1), pitch];
mat_row1 = max(1,min(p2-p1+1,pitch1-p1+1));
mat_row2 = max(1,min(p2-p1+1,pitch2-p1+1));
z1 = ecurve([index(2:Npeaks),index(Npeaks)]);
z2 = ecurve([index(1),index(1:(Npeaks-1))]);


step_size = round(fs/192);
Nbatch2 = ceil(xsamp/step_size);
mat_col = round(1+(index-1)*(Nbatch2-1)/(xsamp-1));
subset = zeros(p2-p1+1,Nbatch2);
for n = 1:length(index)
        subset(mat_row1(n),mat_col(n)) = z1(n);
        subset(mat_row2(n),mat_col(n)) = z2(n);
end
path = rridern(subset,3)+p1-1;
pitch = round(interp1(1:Nbatch2,path,linspace(1,Nbatch2,xsamp)));

array = zeros(1,2*xsamp);
n = 1;
array(1) = 1;
while n < xsamp
        n = n + pitch(n);
        array(n) = 1;
end
peaks = 1:length(array);
peaks(~array) = [];

Xres = 500;
xpts = round(linspace(1,xsamp,Xres));
M = length(peaks);
N2 = p2;
N = 2*N2;


pointers = max(1,min(xsamp,([1:N]'-N2)*ones(1,M)+ones(N,1)*peaks));
MAT = reshape(abs(spch(pointers)),N,M) .* [hanning(N)*ones(1,M)];
path = rridern(MAT,4);
peaks = round(peaks+path-N2);
pitch_marks = peaks([peaks>=1]&[peaks<=xsamp]);

return



function path = rridern(MAT,N)
%
% y = rridern(MAT)
%
% This function traces a path from the first to the last columns
% of MAT, one that does not exceed slope == N (N integer >0) when
% assuming that successive rows are separated by one unit, and that
% successive columns are separated by one unit) and has the maximum
% possible cumulative MAT values along the path.  The output
% path y adheres to the sample points of MAT.
%
% W. Goncharoff  3/17/96


% calculate best-path cumulative errors:
[mrows,mcols] = size(MAT);
sf = mean(mean(MAT));
MAT = [-Inf*ones(N,mcols); MAT; -Inf*ones(N,mcols)];
best_paths = zeros(size(MAT));
range = N + (1:mrows);
T = zeros(1+2*N,mrows);
B = zeros(1+2*N,mrows);
R = zeros(1,(1+2*N)*mrows);
for i = -N:N
        B(i+N+1,:) = ones(1,mrows) * sf/sqrt(1+i*i);
        R(mrows*(i+N)+[1:mrows]) = range + i;
end
for col = 2:mcols
        T = reshape(MAT(R,col-1),mrows,1+2*N)';
        [temp1,temp2] = max(T+B);
        MAT(range,col) = MAT(range,col) + temp1';
        best_paths(range,col) = temp2';
end


% trace the optimal path backwards through the cum. error matrix:
best_paths = best_paths - N - 1;
path = zeros(1,mcols);
[total_error,row] = max(MAT(:,mcols));
path(mcols) = row;
for col = mcols:-1:2
        row = row + best_paths(row,col);
        path(col-1) = row;
end

path = path - N;

return



function W = hanning(N)

    W1 = (1 + cos(pi*linspace(-1,1,N+2)))'/2;
    W = W1(2:(N+1));

return