clear; close all;
DIR = './';
FILENAME = 'vaiueo2d.wav';
[y,fs1] = audioread([DIR FILENAME]);

sound(y,fs1);

%% new EPD
%   [staPT, endPT] = EPD(y,fs1,1)
staPT = 2361;
endPT = 16181
y1=y(staPT:endPT);
time6=(endPT-staPT)/fs1;
audiowrite('./clip.wav',y1,fs1);
fs = 16000;
y = resample(y1,fs,fs1);

framelen = 0.092; % second. [INVESTIGATE]
p = 25; % linear prediction order. [INVESTIGATE]

%%
L = round(framelen*fs);
overlap=0.8;

frame_shift=round(L*(1-overlap));

if L<=p
    disp('Linear prediction requires the num of equations to be greater than the number of variables.');
end

sw.emphasis = 1; % default = 1

numFrames = floor((length(y)-L)/frame_shift)+1;
%ceil((L-winlengh)/shift)
excitat = zeros(size(y));
e_n = zeros(p+L,1);

LPcoeffs = zeros(p+1,numFrames);
Kcoeffs = zeros(p,numFrames); % reflection coeffs

Nfreqs = 2^nextpow2(2*L-1)/2; % Num points for plotting the inverse filter response
df = fs/2/Nfreqs;
ff = 0:df:fs/2-df;

if sw.emphasis == 1,
    y_emph = filter([1 -0.95],1,y);
                %[PARAM] -0.95 may be tuned anywhere from 0.9 to 0.99
else
    y_emph = y;
end
%
%% Linear prediction and estimation of the source e_n
win = ones(L,1);% hamming(L); % Rectangular window.
ADDff1=[];ADDff2_ff1=[];
ADDff2=[];ADDff3=[];
writerobj = VideoWriter('out.avi')
writerobj.FrameRate =numFrames/time6;
open(writerobj);

figg=3;


for kk = 1:numFrames
    ind = (kk-1)*frame_shift+1:(kk-1)*frame_shift+L;
    ywin = y_emph(ind).*win;
    %A = lpc(ywin,p); %% This is actually the more direct way to obtain the
    % LP coefficients. But, in this script, we used levinson() instead
    % because it gives us the "reflection coefficients".
    %
    % (Below, the fast way to calculate R is
    % copied and modified from MATLAB's lpc() function)
    Y = fft(ywin,2*Nfreqs);
    R = ifft(Y.*conj(Y));           %--autocorre-%
    [A,errvar,K] = levinson(R,p);  

    % Preparation for data visualization
    hold on;
    if kk == 1,
        e_n(p+1:end) = filter(A,[1],ywin);
    else
        ywin_extended = y((kk-1)*frame_shift+1-p:(kk-1)*frame_shift+L);  %% WORTH TWEAKING
        e_n = filter(A,[1],ywin_extended);
    end
    excitat(ind) = e_n(p+1:end);
    %
    figure(1);
    subplot(221);
    plot(ind/fs*1000, y(ind));
    xlabel('ms')
    ylabel('orginal signal')
    % set(gca,'xlim',[kk-1 kk]*framelen*1000);
    subplot(222);
    plot(ind/fs*1000, e_n(p+1:end));
    %  set(gca,'xlim',[kk-1 kk]*framelen*1000);
    xlabel('ms')
    ylabel('e(z)')


    subplot(223);
    [H,W] = freqz(1,A,Nfreqs);
    Hmag = 20*log10(abs(H));
    Ymag = 20*log10(abs(Y(1:Nfreqs))); % NEED DEBUG
    Hmax = max(Hmag);
    offset = max(Hmag) - max(Ymag);
    plot(ff,Hmag); hold on;
    plot(ff,Ymag+offset,'r'); hold off;
    set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+5]);
    xlabel('Hz')
    ylabel('orginal signal fourier')


    subplot(224);
    plot(ff,Ymag+offset-Hmag);
     set(gca,'xlim',[0 fs/2],'ylim',[-30, 25]);
    xlabel('Hz');
    ylabel('e(z) fourier (e(z))')
    drawnow;
    %pause;
    LPcoeffs(:,kk) = A;
    Kcoeffs(:,kk) = K;

    if figg==1
        frame = getframe(gcf);
        writeVideo(writerobj,frame)
    end

    % see the variety
    figure(2)
    plot(ff,Hmag,'b-o');
    grid on;
    set(gca,'xlim',[0 fs/2],'ylim',[Hmax-50, Hmax+5]);
    xlabel('ff  Hz   ????')
    ylabel('Hmag')
    title('for loop Hmag ??')
    if figg==2;
        frame = getframe(gcf);
        writeVideo(writerobj,frame)

    end

    N=size(Hmag(:),1);

    range1=1500/df;
    range2=2000/df;
    range3=4000/df;

    [H1,f1]=max(Hmag(1:range1));
    [H2,f2]=max(Hmag(range1+1:range2));
    [H3,f3]=max(Hmag(range2+1:range3));




    ff1=f1*df;
    ff2=(range1+f2)*df;
    ff3=(range2+f3)*df;

    ADDff1=[ADDff1;ff1];
    ADDff2_ff1=[ADDff2_ff1;ff2-ff1];
    ADDff2=[ADDff2;ff2];
    ADDff3=[ADDff3;ff3];
    
    figure(3);
    scatter(ff2-ff1,ff1);hold on ;
    set(gca,'xdir','reverse');
    set(gca,'ydir','reverse');
    set(gca,'yaxislocation','right');
    set(gca,'xaxislocation','top');
    %set(get(ax(2),'Ylabel'),'String','?? y2 ??')
    axis([100 3000 -100 1000 ])
    grid on;
    % axis([100 5000 50 1500])
    xlabel('f2-f1')
    ylabel('f1')
    title('for loop frames')
    if figg==3
        frame = getframe(gcf);
        writeVideo(writerobj,frame)
    end
    
    figure(15)
    scatter3(ff1,ff2-ff1,ff3)
    grid on;
    axis([0 4000 0 inf 0 inf])
    xlabel('f1');
    ylabel('f2-f1')
    zlabel('f3')
    title('3D for loop frames')
    
    figure(11)
    plot(Kcoeffs,'DisplayName','Kcoeffs')
    grid on;
    xlabel('p order');
    ylabel('Kcoeffs')
    title('k parameters')




end
close(writerobj);
Averageff1=sum(ADDff1(:))/size(ADDff1,1);
AverageADDff2_ff1=sum(ADDff2_ff1(:))/size(ADDff2_ff1,1);
Averageff2=sum(ADDff2(:))/size(ADDff2,1);
Averageff3=sum(ADDff3(:))/size(ADDff3,1);

%%   connect spot
figure(13)
plot(ADDff2_ff1,ADDff1,'b-o');
%scatter(ADDff2_ff1,ADDff1)
grid on;
set(gca,'xdir','reverse');
set(gca,'ydir','reverse');
set(gca,'yaxislocation','right');
set(gca,'xaxislocation','top');
axis([100 5000 -100 4000 ])
xlabel('f2-f1')
ylabel('f1')
title('f3')

figure(14)
plot3(ADDff1,ADDff2_ff1,ADDff3,'b-o')
grid on;
%axis([100 4000 100 4000 10 inf])
axis([0 4000 0 inf 0 inf])
xlabel('f1');
ylabel('f2-f1')
zlabel('f3')
title('3D')

figure(12)
scatter3(ADDff1,ADDff2_ff1,ADDff3)
grid on;
axis([0 4000 0 inf 0 inf])
xlabel('f1');
ylabel('f2-f1')
zlabel('f3')
title('f3')

ff1=359.375;
ff2=3906.3;

figure(10);
scatter(AverageADDff2_ff1,Averageff1);
set(gca,'xdir','reverse');
set(gca,'ydir','reverse');
set(gca,'yaxislocation','right');
set(gca,'xaxislocation','top');
%set(get(ax(2),'Ylabel'),'String','?? y2 ??')

axis([100 4000 100 4000])
xlabel('f2-f1 ')
ylabel('f1')
title('all average of f1 and f2-f1')


%% Below is a demo for vocal-tract shape estimation.
% YWL is not 100% sure if the implementation is correct, or if the current
% results make sense. Use with caution; or further research is highly
% appreciated.
% Last updated: May 2017.

vtshape = zeros(p+1,numFrames); % defined as the sqrt of cross-sec area.
vtshape(end,:) = ones(1,numFrames); % Assume that the cross-section
                                    % area near the glottis is fixed.

speed = 34300; % cm/s, speed of sound
dx = speed/fs; % cm per sample, spatial
xx = p*dx:-dx:0;

for ii = 1:numFrames
    K = Kcoeffs(:,ii);
    for ll = p:-1:1
        refl = K(ll); % reflectance at this segment
        vtshape(ll,ii) = vtshape(ll+1,ii)*sqrt((1+refl)/(1-refl));
    end
    figure(4)
    plot(xx,vtshape(:,ii)); % First reflectance K(1) tends to be large because
            % impedance drastically changes between the end of vocal tract
            % and the open air outside.
            set(gca,'ydir','reverse');
            set(gca,'ylim',[0 15]);
            xlabel('glottis <-> lips (cm)')
            hold on;
            drawnow;
end
title(FILENAME)

