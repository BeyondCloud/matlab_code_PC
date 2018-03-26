function basis = phi(j,i,N)
if j==0
	basis = 1;
end

if j==1
    if N<1
        basis = 0;
    else
        basis = (12 * N / (N + 2))^(0.5) * (i/N-0.5);
    end    
end

if j==2
    if N<2
        basis = 0;
    else
        basis =  (180 * N^3 / (N - 1) / (N + 2) / (N + 3))^0.5 * ( (i/N)^2 - i/N + (N-1)/(6*N));
    end
end

if j==3
    N1 = N;
    N2 = N^2;
    N5 = N^5;
    N3 = N^3;
    I1 = i;
    I2 = I1^2;
    I3 = I1^3;
    if N<3
        basis = 0;
    else
        basis = ((2800*N5/(N1-1)/(N1-2)/(N1+2)/(N1+3)/(N1+4))^0.5) * ( I3/N3 - 3/2*I2/N2 + (6*N2-3*N1+2)/10/N3*I1 - (N1-1)*(N1-2)/20/N2);
    end
    
end