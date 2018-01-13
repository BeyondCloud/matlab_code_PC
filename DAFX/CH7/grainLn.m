function y = grainLn(x,iniz,L,Lw)
% extract a long grain
% x    input signal
% init first sample
% L    grain length (in samples)
% Lw   length fade-in and fade-out (in samples)

if length(x) <= iniz+L , error('length(x) too short.'),  end

y = x(iniz:iniz+L-1);                      % extract segment
w = hanning(2*Lw+1);
y(1:Lw)     = y(1:Lw).*w(1:Lw);            % fade-in
y(L-Lw+1:L) = y(L-Lw+1:L).*w(Lw+2:2*Lw+1); % fade-out
