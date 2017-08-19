function X = TDMA(A,B,C,D)
% A = [0 2 4];
% B = [2 1 2];
% C = [4 2 0];
% D = [6 5 6];

n = length(A);
X = zeros(n,1);
%Forward substitution
for k = 2:n
    m = A(k)/B(k-1);
    B(k) = B(k) - m*C(k-1)
    D(k) = D(k) - m*D(k-1)
end

% Backward substitution, since X(n) is known first.
X(n) = D(n)/B(n);
for k = n-1:-1:1
    X(k) = (D(k)-C(k)*X(k+1))/B(k);
end