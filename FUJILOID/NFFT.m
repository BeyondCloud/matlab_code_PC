function x = NFFT256(x,pnt)

% if (length(x)~=16)||(length(x)~=8)||(length(x)~=4)||(length(x)~=2)||(length(x)~=1)
% %    error('wrong # of input element');
% end

    if pnt>1
        k=[0:pnt-1];
        w=exp(-2j*pi.*k/pnt);
        h=x(1:2:end);
        g=x(2:2:end);
        H=FFT256(h,pnt/2);
        G=FFT256(g,pnt/2);
        x=[H,H]+w.*[G,G];
    end
    
    if pnt==256
        x=[x(1)+x(pnt/2+1) 2*x(2:pnt/2)];
    end
    
    if pnt==256
        x=abs(x);
        plot(x);
        x=find(x==max(x));
    end
end