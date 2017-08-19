% Use the LU decomposition to decompose the B matrix
close all; clear all;
B=[0.200000000000000,0.300000000000000,0.400000000000000,0.500000000000000,0.600000000000000,0.700000000000000,0.800000000000000,0.900000000000000,1,1.10000000000000;0.100000000000000,0.550000000000000,0.700000000000000,0.850000000000000,1,1.15000000000000,1.30000000000000,1.45000000000000,1.60000000000000,1.75000000000000;0.140000000000000,0.530000000000000,1.28000000000000,1.53000000000000,1.78000000000000,2.03000000000000,2.28000000000000,2.53000000000000,2.78000000000000,3.03000000000000;0.180000000000000,0.670000000000000,1.52000000000000,2.62000000000000,3.02000000000000,3.42000000000000,3.82000000000000,4.22000000000000,4.62000000000000,5.02000000000000;0.220000000000000,0.810000000000000,1.82000000000000,3.30000000000000,4.80000000000000,5.40000000000000,6.00000000000000,6.60000000000000,7.20000000000000,7.80000000000000;0.260000000000000,0.950000000000000,2.12000000000000,3.82000000000000,6.10000000000000,8.05000000000000,8.90000000000000,9.75000000000000,10.6000000000000,11.4500000000000;0.300000000000000,1.09000000000000,2.42000000000000,4.34000000000000,6.90000000000000,10.1500000000000,12.6000000000000,13.7500000000000,14.9000000000000,16.0500000000000;0.340000000000000,1.23000000000000,2.72000000000000,4.86000000000000,7.70000000000000,11.2900000000000,15.6800000000000,18.6800000000000,20.1800000000000,21.6800000000000;0.380000000000000,1.37000000000000,3.02000000000000,5.38000000000000,8.50000000000000,12.4300000000000,17.2200000000000,22.9200000000000,26.5200000000000,28.4200000000000;0.420000000000000,1.51000000000000,3.32000000000000,5.90000000000000,9.30000000000000,13.5700000000000,18.7600000000000,24.9200000000000,32.1000000000000,36.3500000000000];
A=B
[n,m]=size(A); 
if n~=m 
    error('The rows and columns of matrix A must be equal!'); 
    return; 
end 

v = [1 1 1 1 1 1 1 1 1 1];
L = diag(v);
U=zeros(n);
flag='OK'; 
for k=1:n 
    for j=k:n 
        z=0; 
        for s=1:k-1 
            z=z+L(k,s)*U(s,j); 
        end 
        U(k,j)=(A(k,j)-z)/L(k,k); 
        
    end 
    
    if abs(U(k,k))<eps 
        flag='failure'; 
        return; 
    end 
    
    for i=k+1:n 
        z=0; 
        for s=1:k-1 
            z=z+L(i,s)*U(s,k); 
        end 
        L(i,k)=(A(i,k)-z)/U(k,k); 
    end 
end