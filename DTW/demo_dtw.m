% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

% this is a demo showing the use of our dynamic time warping package 
% we provide both Matlab version and C/MEX version
% the C/MEX version is much faster and highly recommended

clear;clc;close all;

% mex dtw_c.c;

a=[71 73 75 80 80 80 78 76 75 73 71 71 71 73 75 76 76 68 76 76 75 73 71 70 70 69 68 68 72 74 78 79 80 80 78]';
b=[69 69 69 69 69 73 75 79 80 79 78 76 73 72 71 70 70 69 69 69 71 73 75 76 76 76 76 76 75 73 71 70 70 71 73 75 80 80 80 78]';
w=10;

d1=dtw(a,b,w);
[val , idx] = min(d1,[],2);
% tic;
% d2=dtw_c(a,b,w);
% t2=toc;
% fprintf('Using C/MEX version: distance=%f, running time=%f\n',d2,t2);

