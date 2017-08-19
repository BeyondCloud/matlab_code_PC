

A = [ 1 1 1 1 1 1 1 1 1 0];
B = [2 -2 -2 -2 -2 -2 -2 -2 -2 -2 1]; 
C = [ 0 1 1 1 1 1 1 1 1 1];
D = [12 3 3 3 3 3 3 3 3 3 38];

n = length(D);
A(2:end+1)=A;
A(1) = 0;
C(end+1) = 0;
X = zeros(n,1);
%Forward substitution
for k = 2:n
    if(B(k-1) == 0)
%         X(k) = D(k-1)/C(k-1);
%         B(k-1) = 1;
%         D(k-1) =D(k-1)+X(k);
        error('TDMA divide by zero');
    end
        m = A(k)/B(k-1);
        B(k) = B(k) - m*C(k-1)
        D(k) = D(k) - m*D(k-1) 
end

% Backward substitution, since X(n) is known first.
if(B(n) ~= 0)
    X(n) = D(n)/B(n);
else
    error('TDMA divide by zero');   
%     B(n) = 1;
%     X(n) = D(n-1) - B(n-1)*X(n-1);
end
for k = n-1:-1:1
    if(B(k) ~= 0)
        X(k) = (D(k)-C(k)*X(k+1))/B(k); 
    else
            error('TDMA divide by zero');   
    end
end


