 function [L,U,flag]=LU(A) 
 %usage : [L,U]  = LU(A)
% flag='failure'表示計算失敗，flag='OK'表示計算成功 
[n,m]=size(A); 
if n~=m 
    error('The rows and columns of matrix A must be equal!'); 
    return; 
end 
L=eye(n);
U=zeros(n);
flag='OK'; 
for k=1:n 
    for j=k:n 
        z=0; 
        for q=1:k-1 
            z=z+L(k,q)*U(q,j); 
        end 
        U(k,j)=A(k,j)-z; 
    end 
    
    if abs(U(k,k))<eps 
        flag='failure'; 
        return; 
    end 
    
    for i=k+1:n 
        z=0; 
        for q=2:k-1 
            z=z+L(i,q)*U(q,k); 
        end 
        L(i,k)=(A(i,k)-z)/U(k,k); 
    end 
end 