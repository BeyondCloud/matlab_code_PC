function [y]=recover(org,n)

for j=1:n+1
    y(j,1)=0;
    for i=1:4
        y(j,1)=y(j,1)+org(i)*phi(i-1,j-1,n);
    end
end
