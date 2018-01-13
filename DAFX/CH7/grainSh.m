function y = grainSh(x,init,L)
% extract a short grain
% x    input signal
% init first sample
% L    grain length (in samples)
y=x(init:init+L-1).*hanning(L)';