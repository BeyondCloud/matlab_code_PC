function [result] = Orthogonal_Expansion(start_i, end_i, fea)
N = end_i - start_i ;
for j=1:1:4
    result(j,1) = 0;
    if j>N
    else
       for i=0:1:N
           result(j,1) = result(j,1) + fea(1,start_i+i) * phi(j-1,i,N);
       end
       result(j,1) = result(j,1) / (N + 1);        
    end
end


