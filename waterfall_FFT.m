disp(' ')
disp(' waterfall_FFT.m ')
disp(' ver 1.8  June 21, 2006 ')
disp(' by Tom Irvine  Email: tomirvine@aol.com ')
disp(' ')
disp(' This program calculates the one-sided, full amplitude FFT ')
disp(' of a time history ')
disp(' ')
disp(' The time history must be in a two-column matrix format: ')
disp(' Time(sec)  & amplitude ')
disp(' ')
%
clear THM;
clear tmx;
clear tmi;
clear ts;
clear te;
clear n;
clear n1;
clear n2;
clear dt;
clear po;
clear as;
clear ts;
clear amp;
clear tim;
%
disp(' Select file input method ');
disp('   1=external ASCII file ');
disp('   2=file preloaded into Matlab ');
file_choice = input('');
%
if(file_choice==1)
    [filename, pathname] = uigetfile('*.*');
    filename = fullfile(pathname, filename);
    fid = fopen(filename,'r');
    THM = fscanf(fid,'%g %g',[2 inf]);
    THM=THM';
else
    THM = input(' Enter the matrix name:  ');
end
%
size(THM)
tmx=max(THM(:,1));
tmi=min(THM(:,1));
n = length(THM(:,2));
dt=(tmx-tmi)/n;
%
out3 = sprintf('\n  number of samples = %d ',n);
disp(out3)
out3 = sprintf('\n  start  = %g sec    end = %g sec \n',tmi,tmx);
disp(out3)
%
disp(' Enter processing option for signal duration');
disp(' 1=whole time history   2=segment ');
po=input('');
%
if(po==2)
    disp(' ');
    ts=input(' Enter segment start time  ');
    te=input(' Enter segment end   time  ');
    disp(' ');
%
    if(ts>tmx)
        ts=tmx;
    end
    if(te<tmi)
        ts=tmi;
    end
%
    n1=fix((ts-tmi)/dt);
    n2=fix((te-tmi)/dt);
%
    if(n1<1)
        n1=1;
    end
%
    if(n2>n)
        n2=n;
    end
%
    if(n1>n2)
        n2=n1;
    end
%
    as=THM(:,2);
%
    ts=THM(:,1);
%
    amp=as(n1:n2)';
    tim=ts(n1:n2)';
%
else
    amp=THM(:,2);
    tim=THM(:,1);
end
clear THM;
%
for(ijk=1:10)
%
clear Y;
clear store;
clear freq;
clear store_p;
clear freq_p;
clear time_a;
clear dt;
clear df;
clear NW;
clear mmm;
clear n;
clear max_a;
clear max_j;
%
tmx=max(tim);
tmi=min(tim);
%
n = length(amp);
dt=(tmx-tmi)/n;
%
disp(' ');
out4 = sprintf(' Time history length = %d ',n);
disp(out4)
%
for(i=1:22)
    if( 2^i > n )
        break;
    end
    N=2^i;
end
%
NC=17;
for(i=4:NC)
    ss(i) = 2^i;
    seg(i) =n/ss(i);
    i_seg(i) = fix(seg(i));
end
%
disp(' ');
out4 = sprintf(' Number of   Samples per   Time per    df');
out5 = sprintf('  Segments     Segment      Segment      ');
%
disp(out4)
disp(out5)
%        
for(i=4:NC)
    if( i_seg(i)>0)
        str = int2str(i_seg(i));
        tseg=dt*ss(i);
        ddf=1./tseg;
        out4 = sprintf(' \t  %s  \t  %d  \t   %6.3f  \t  %6.3f',str,ss(i),tseg,ddf);
        disp(out4)
    end
end
%
disp(' ')
NW = input(' Choose the Number of Segments:  ');
disp(' ')
%
mmm = 2^fix(log(n/NW)/log(2));
%
df=1./(mmm*dt);
%
minf = input(' select minimum output frequency (Hz) ');
disp(' ');
maxf = input(' select maximum output frequency (Hz) ');
%
for(i=1:mmm/2)
    freq(i)=(i-1)*df;
    if(freq(i)>maxf)
        break;
    end
end
mk=length(freq);
t1=tmi+(dt*mmm);
time_a(1)=t1;
%
for(i=2:NW)
    time_a(i)=time_a(i-1)+dt*mmm;
end
jk=1;
for(ij=1:NW)
   max_a(ij)=0.;
   max_f(ij)=0.;
   for(k=1:mmm)
       sa(k)=amp(jk);
       jk=jk+1;
   end
   Y= fft(sa,mmm);
   aa=real(Y(1));
   bb=imag(Y(1));   
   store(ij,1) = sqrt(aa^2+bb^2)/mmm; 
%   
   j=1;
   for(k=2:mk) 
      aa=real(Y(k));
      bb=imag(Y(k));
      store(ij,k) =2.*sqrt(aa^2+bb^2)/mmm;   
      if(freq(k)>=minf)
            store_p(ij,j)=store(ij,k);
            freq_p(j)=freq(k);
            if(store_p(ij,j)>max_a(ij))
                max_a(ij)=store_p(ij,j);
                max_f(ij)=freq_p(j);
            end
            j=j+1;
      end
   end    
end
%
% disp(' Plot the Spectogram? ')
% choice = input(' 1=yes 2=no ');
choice=1;
%
disp(' ')
disp(' Choose color scheme ')
color_choice = input(' 1=default 2=red 3=black ');
%
if(choice == 1)
    figure(1);    
    if(color_choice ==1)
        colormap(hsv(128));
    end  
    if(color_choice ==2)
        colormap(hsv(1));
    end    
    if(color_choice ==3)
        for(i=1:64)
          map(i,:)=[0 0 0];
          colormap(map);
        end      
    end 
    set(gcf,'renderer','openGL');    
    waterfall(freq_p,time_a,store_p);  
    xlabel(' Frequency (Hz)');
    ylabel(' Time (sec)'); 
    zlabel(' Magnitude'); 
    view([-12 15]);   
end
disp(' ')
disp(' Peak Values ');
disp(' Time(sec)  Freq(Hz)  Amplitude ');
for(ij=1:NW)
    out4 = sprintf(' \t  %6.3f  \t  %6.3f  \t  %6.3f',time_a(ij),max_f(ij),max_a(ij));
    disp(out4) 
end
%disp(' ')
%disp(' Repeat analysis with new parameters? ')
%repeat = input(' 1=yes  2=no  ');
%
%if(repeat==2)
%    break
%end
break
end
