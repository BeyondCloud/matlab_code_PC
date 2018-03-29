function [sy,synthSataus]=straightSynthTB07ca(n2sgram,f0raw,shiftm,fs, ...
            pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind,ap,imap,imgi,lowestF0);
%    Straight synthesis with all-pass filter design based on
%	TEMPO analysis result
%   sy=straightSynthTB07ca(n2sgram,f0raw,f0var,f0varL,shiftm,fs, ...
%               pcnv,fconv,sconv,gdbw,delfrac,delsp,cornf,delfracind,ap,imap,imgi));
%	sy	: synthsized speech
%	n2sgram	: amplitude spectrogram
%	f0raw	: pitch pattern (Hz) 
%	f0var	: expected F0 variation with fricative modification
%	f0varL	: expected F0 variation
%	shiftm	: frame shift (ms) for spectrogram
%	fs	: sampling freqnency (Hz)
%	pcnv	: pitch stretch factor
%	fconv	: freqnency stretch factor 
%	sconv	: speaking duratin stretch factor (overridden if || imap || >1 )
%	gdbw	: finest resolution in group delay (Hz)
%	delfrac	: ratio of standard deviation of group delay in terms of F0
%	delsp	: standard deviation of group delay (ms)
%	cornf	: lower corner frequency for phase randomization (Hz)
%	delfracind	: selector of fixed and proportional group delay
%	ap	: aperiodicity measure
%	imap	: arbirtary mapping from new time (sample) to old time (frame)
%	imgi	: display indicator, 1: display on (default), 0: off
%   lowestF0    : lower limit of the resynthesized fundamental frequency (Hz)
imgi = 1;
statusReport = 'ok';% 27/Nov./2005
switch nargin % 27/Nov./2005
    case {1,2,3,4,5,6,7,8,9,10,11,12,13,14}
        imgi = 1;
        lowestF0 = 50;
    case {15}
        lowestF0 = 50;
end;
f0l=f0raw;
[nii,njj]=size(n2sgram);
njj=min([njj,length(f0raw)]);  % 18/Sep./1999

f0l=f0l(1:njj);  %03/Sep./1999
if min(f0l(f0l>0))*pcnv < lowestF0
    statusReport = ['Minimum synthesized F0 exceeded the lower limit(' num2str(lowestF0) ' Hz).'];
end;

fftLengthForLowestF0 = 2^ceil(log2(2*round(fs/lowestF0)));% 27/Nov./2005
fftl=nii+nii-2;
if fftl < fftLengthForLowestF0 % 27/Nov./2005
    niiNew = fftLengthForLowestF0/2+1;
    statusReport = 'The FFT length was inconsistent and replaced';
    n2sgram = interp1([0:nii-1],n2sgram,[0:niiNew-1]*(nii-1)/(niiNew-1));
    ap = interp1([0:nii-1],ap,[0:niiNew-1]*(nii-1)/(niiNew-1));
    fftl = fftLengthForLowestF0;
    nii = niiNew;
end;
fftl2=fftl/2;

aprms=10.0.^(ap/20); % 23/Sept./1999
aprm=smax(aprms,18,0.25); % 23/Sept./1999
aprm=min(1,max(0.001,aprms*1.6-0.015)); % 30/May/2001


if length(fconv)==1
    idcv=min([0:fftl/2]/fconv+1,fftl/2+1); % f. stretch conv. tabel
  elseif length(fconv)==nii
	idcv=fconv(:)';
elseif length(fconv) ~= nii
    idcv = 1:fftl/2+1;
    statusReport = [statusReport '\n' 'Frequency axix mapping function is not consistent with lowestF0.'];
end;
if length(imap)>1
	sy=zeros(length(imap)+3*fftl,1);disp('here!!');
else
	sy=zeros([round((njj*shiftm/1000*fs)*sconv+3*fftl+1),1]);
	imap=[1:length(sy)];
	imap=min(length(f0l),((imap-1)/fs*1000/shiftm/sconv+1));
end;
imap=[imap ones(1,round(fs*0.2))*length(f0l)]; % safe guard
ix=min(find(imap>=length(f0l)));

rmap=interp1(imap(1:ix),[1:ix],[1:length(f0l)]);
syo=sy;

f=(0:fftl/2)/fftl*fs;  %  02/Sept./1999
lf=log10(f+0.1);       %  02/Sept./1999


phs=fractpitch2(fftl); %  phs will have smooth phase function for unit delay

a=([0:fftl2-1,0,-(fftl2-1:-1:1)])/fftl2;
sz=a'*pi;
ta=[0:fftl2-1]/fftl2/2*2*pi;
t=[ta,0,-ta(fftl2:-1:2)];

fftl2=fftl/2;
nsyn=length(sy);
idx=1;
bb=1:fftl;
bb2=1:fftl2;
rbb2=fftl/2:-1:2;

%------- shaping for low-frequency noize supression

fxa=(0:fftl2)/fftl*fs;
f0tmp=f0l; % 18/Sept./1999

lowcutf=mean(f0tmp(f0tmp>0))*0.7*pcnv;
lowcutfav=lowcutf;
wlcutav=1.0./(1+exp(-14*(fxa-lowcutfav)/(lowcutfav/1)));

%------ April/2002
waprm=1.0./(1+exp(8*(fxa-1000)/200));
%------- parameters for noize based apf design

t=([1:fftl]-fftl/2-1)/fftl*2;
adjd=1.0./(1+exp(-20*t)); % correction function for smooth transition at fs/2
gw=exp(-0.25*pi*(fs*(t/2)/gdbw).^2); % slope difinition function
gw=gw/sum(gw);            % gdbw is the equvalent rectangular band width
fgw=real(fft(fftshift(gw))); % gw is the spectral smoothing window
df=fs/fftl*2*pi;    % normalization constant for integration and differentiation
fw=(1:fftl2+1)/fftl*fs; % frequency axis

trbw=300;		% width of transition area
rho=1.0./(1+exp(-(fw-cornf)/trbw)); % rondom group delay weighting function

%--------- frozen group delay component calculation ------
nz=randn(1,fftl2+1).*rho; %((rho*0+1)*mixNlow(round(ii))+(1-mixNlow(round(ii)))*rho);
nz=real(ifft(fft([nz,nz(rbb2)]).*fgw));
nz=nz*sqrt(fftl*gdbw/fs);   % correction factor for noise
nz=nz*delsp*df/1000;
mz=cumsum([nz(1:fftl2+1),nz(rbb2)])-nz(1);
mmz=-(mz-adjd*(rem((mz(fftl)+mz(2)),2*pi)-2*pi));
pz=exp(-i*mmz)'; %.*[wlcut wlcut(rbb2)]';
%---------------------------------------------------------

[snn,smm]=size(n2sgram);
fqx=(0:snn-1)/snn*fs/2;
chigh=1.0./(1+exp(-(fqx-600)/100))';
clow=1.0-chigh;

f0arc=0;
lft=1-hanning(fftl);
lft=1.0./(1+exp(-(lft-0.5)*60));
ww=1.0./(1+exp(-(hanning(fftl)-0.3)*23)); % lifter for

iin=1;
if imgi==1; hpg=waitbar(0,'voiced part synthesis'); end; % 10/Aug./2005
icntr=0;
dmx=max(max(n2sgram));
while (idx < nsyn-fftl-10) & (ceil(iin)<length(f0l));
  icntr=icntr+1;
  iix=round(imap(round(idx)));
  ii=min(min(max(1,iix),njj),length(f0l));
  if imgi==1 & rem(icntr,10)==0;waitbar(ii/length(f0l));end; % 10/Aug./2005
	f0=f0l(round(ii));
	if f0==0
		f0=200;
	else
		f0=max(lowestF0/pcnv,f0l(round(ii))); % 27/Nov./2005
	end;

	f00=f0;  % 24/Augst/2002 
    f0=f0*pcnv;
%- --------
%	look ahead correction of F0 (cmmt by Simon Makin of Sheffield Univ.) 24/Augst/2002
%- --------
	tnf0=fs/f0;
	tidx=idx+tnf0;
	tiix=round(imap(round(tidx)));
	tii=min(min(max(1,tiix),njj),length(f0l));
	tf0=f0l(round(tii));
	if (tf0>0) & (f0l(round(ii))>0)

        if f0l(round((ii+tii)/2))>0  % fix by H.K. on 17/Dec./2002
		    f0=max(lowestF0/pcnv,f0l(round((ii+tii)/2))); % mid point
        else
            f0=f0l(round(ii));
        end;
		f0=f0*pcnv;
	end;

    wlcut=1.0./(1+exp(-10*(fxa-f0*0.7)/f0));  % 23rd July, 1999

  ff=[n2sgram(round(idcv(:)),round(ii)); ...
      n2sgram(round(idcv(rbb2)),round(ii))];
% - -- Test for spectral interpolation (3/Feb./2003 by H.K.)
%   The following 6 lines were added to solve quantization effect due to
%   frame rate. However, this linear interpolation was found not
%   substantial for fine frame rate (for example 1 or 2 ms). If you find
%   vowel degradation when using longer frame rate, please activate the
%   follwing lines. At least by now, degradation in case of high-pitched
%   female voices is found mainly due to inaccurate aperiodicity
%   estimation. It is the weakest part of STRAIGHT. (H.K. 3/Feb./2003)
%
% - ------------------------------------
%  fffl=[n2sgram(round(idcv(:)),floor(ii)); ...
%      n2sgram(round(idcv(rbb2)),floor(ii))];
%  ffcl=[n2sgram(round(idcv(:)),ceil(ii)); ...
%      n2sgram(round(idcv(rbb2)),ceil(ii))];
%  iifrac=ii-floor(ii);
%  ff=fffl+(ffcl-fffl)*iifrac;

  ccp=real(fft(log(ff+dmx/1000000)));  % 24 Sept. 1999 10000 -> 1000000
  ccp2=[ccp(1);2*ccp(2:fftl/2);0*ccp(fftl/2+1:fftl)];
  ffx=(fft(ccp2.*lft)/fftl);
  nidx=round(idx);
    nf0=fs/f0;
    frt=idx-nidx;
    frtz=exp(i*phs*frt)'; % This was in a wrong sign!
    
    nz=randn(1,fftl2+1).*rho; %((rho*0+1)*mixNlow(round(ii))+(1-mixNlow(round(ii)))*rho);
    nz=real(ifft(fft([nz,nz(rbb2)]).*fgw));
    nz=nz*sqrt(fftl*gdbw/fs);   % correction factor for noise
    if delfracind, delsp=delfrac*1000/f0; end;
    nz=nz*delsp*df/1000;
    mz=cumsum([nz(1:fftl2+1),nz(rbb2)])-nz(1);
    mmz=-(mz-adjd*(rem((mz(fftl)+mz(2)),2*pi)-2*pi));
    pzr=exp(-i*mmz)'; %.*[wlcut wlcut(rbb2)]'; % set ineffective 01/June/2001

	pz=pzr; % This makes random group delay to be effective    

    wnz=aprm(round(idcv(:)),round(ii));  % 06/May/2001 This is correct!
	wpr=sqrt(max(0,1-wnz.*wnz));  % 23/Sept./1999

	rx=randn(round(nf0),1);
	wfv=fft(rx-mean(rx),fftl); % DC component removal 8/April/2002
	zt0=nf0/fs;
	ztc=0.01; % time constant 10ms (for example)
	ztp=((1:round(nf0))'-1)/fs;
	nev=sqrt(2*zt0/ztc/(1-exp(-2*zt0/ztc)))*exp(-ztp/ztc);
	rx=randn(round(nf0),1);
	wfv=fft((rx-mean(rx)).*nev,fftl); % DC component removal 8/April/2002
    
	ep=0*real(ffx);
	nf0n=round(nf0);
	gh=hanning(nf0n*2);
	ep(1:nf0n)=gh(nf0n:-1:1);
	ep(end:-1:end-nf0n+2)=ep(2:nf0n); % bug fix on 29/Jan./2003
	ep=-ep/sum(ep);
	ep(1)=ep(1)+1;
    epf=fft(ep);
    tx=fftshift(real(ifft(epf.*exp(ffx).*pz.*frtz.*[wpr;wpr(rbb2)]))).*ww; % 8/April/2002

    tx2=fftshift(real(ifft(exp(ffx).*frtz.*[wnz;wnz(rbb2)].*wfv))).*ww; % 31/May/2001 

    sy(bb+nidx)=sy(bb+nidx)+(tx*sqrt(nf0)+tx2)*(f0raw(round(ii))>0); % 02/ Sept./1999

  idx=idx+nf0;

  iin=min(max(1,round(imap(round(idx)))),min(njj,length(f0raw))); % modification  on 5/Dec/2002 based on comments by M. Tsuzaki
  if (f0raw(round(ii))==0) & (f0raw(round(iin))>0) % (mixVlow(round(ii))<0.8) & (mixVlow(round(iin))>0.8)
    idxo=idx;
    ipos=min(find(f0raw(round(ii:iin))>0))-1+ii;   % 03/Sept/1999
    if length(ipos)==0
      idx=idxo;
    else
	  idx=max(idxo-nf0+1,rmap(round(ipos))); % 11/August/2002 (Was -1 mistake??)
    end;
  end;
end;
if imgi==1; close(hpg); end; % 10/Aug./2005
ii=1;
idx=1;
f0=1000;
wlcutfric=1.0./(1+exp(-14*(fxa-lowcutfav)/(lowcutfav))); % 31/July/1999


if imgi==1; hpg=waitbar(0,'unvoiced part synthesis'); end; % 10/Aug./2005
icntr=0;

while (idx < nsyn-fftl) & (ii<length(f0l));
  icntr=icntr+1;
  if imgi==1 & rem(icntr,10)==0;waitbar(ii/length(f0l));end;
  iin=min(max(1,round(imap(round(idx)))),min(njj,length(f0raw))); % modification  on 5/Dec/2002 based on comments by M. Tsuzaki
  nidx=round(idx);
  if f0raw(ii) == 0; %mixNhigh(ii)>0.03
    ff=[n2sgram(round(idcv(:)),ii);n2sgram(round(idcv(rbb2)),ii)];
	ccp=real(fft(log(ff+dmx/100000))); % 23rd July, 1999 % 24th Sept.
    ccp2=[ccp(1);2*ccp(2:fftl/2);0*ccp(fftl/2+1:fftl)];
    ffx=(fft(ccp2.*lft)/fftl);
    nf0=fs/f0;


	tx=fftshift(real(ifft(exp(ffx))));
    rx=randn([round(nf0),1]);
    tnx=fftfilt(rx-mean(rx),tx); % DC component removal 8/April/2002
    sy(bb+nidx)=sy(bb+nidx)+tnx(bb).*ww;
  end;
  idx=idx+nf0;
  ii=round(imap(round(idx)));
end;
if imgi==1; close(hpg); end; % 10/Aug./2005

sy=sy(fftl/2+(1:ix)); % shift signal forward

switch nargout
    case {1}
    case {2}
        synthSataus = statusReport;
end;

