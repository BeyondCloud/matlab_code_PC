function y=wav(length,f,M,P)
% y=wav(length,frequency,pick,pickup)
%  length of output in seconds
%  desired frequency of output
%  pick - relative point of pluck [0-1]
%  pickup - relative point of pickup [0-1]

fs=44100;
N=round(fs/f/2);
pick=round(M*N);
pu=round(P*N);
if(pu==0) pu=1;end
if(pick==0) pick=1;end 


%x = [0,1,2,..N-1], x[1] = 0, x[2] = 1
x = 0:N-1;

% wave form of pluck
input=.5/pick.*x(1:pick);   %.* stands for element wise multiply
input(pick+1:N)=-.5/(N-pick).*x(pick+1:N)+(.5*N+0.5)/(N-pick+1);

 yr=input;
  yl=input;
  subplot(311);
  plot( 0:N-1 , yr , 0:N-1 , yl );
  title('wave form of initial pluck');
  axis([0 N -.5 .5]);
  
 % dwg
decay=.99;
 for i=1:fs*length
     y(i)=yr(pu)+yl(pu);
     %traveling wave in right direction
     yrlast=yr(N);
     yr(2:N)=yr(1:N-1);
     yr(1)=-decay*yl(1); %reach the left bound 
                        %,decay 99% and reverse it's direction
     yl(1:N-1)=yl(2:N);
     yl(N)=-decay*yrlast;  
 end
  title('final wave form after decay');
  subplot(312);
  plot(y);
  axis([0 2*N -1.1 1.1]);

  subplot(313);
  plot(y)
  axis([0 fs*length -1.1 1.1]);
  sound(y);
pause(.001)
%end
