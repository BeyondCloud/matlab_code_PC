%======== 使用STRAIGHT調整source的pitch,duration成為target 2008/12/10 ==========================

clear all;

[source,fs1]=wavread('C:/Program Files/MATLAB/R2008a/work/STRAIGHT/2.wav');  %source
[target,fs2]=wavread('C:/Program Files/MATLAB/R2008a/work/STRAIGHT/2_4.wav'); %target
fs=fs1;



%======== duration moditication (mapping)  =========== %
%step1: duration要先拉長成為target duration
ogtm=[0 (length(source)-1)*1000/fs]; %source duration (ms)
trgt=[0 (length(target)-1)*1000/fs]; %target duration (ms)
%trgt=[0 (20000-1)*1000/fs];
otm=0:1000/fs:(length(target)-1)*1000/fs;
%otm=0:1000/fs:(20000-1)*1000/fs;
imap=interp1(trgt,ogtm,otm);  % mapping function 
figure
plot(imap)
plot((0:length(imap)-1)/fs*1000,imap);grid on
xlabel('target time (ms)')
ylabel('original time (ms)')

imap2=imap+1;
%prmS.timeAxisMappingTable=imap2;  % key parameter for modify duration,
%%12/24

%[sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,prmS); 
%soundsc(sy,fs);  %此時放音會聽到聲音被拉長了

%step2: 此時才能調整pitch為target pitch
%==== target duration ==============
prm.F0defaultWindowLength=10; % default frame length for pitch extraction (ms)  12/24
prm.F0frameUpdateInterval=10; % shiftm % F0 calculation interval (ms)   12/24

[f0raw_source,ap_source]=exstraightsource(source,fs,prm);  % 求source f0,ap   12/24
[f0raw_target,ap_target]=exstraightsource(target,fs);  % 求target f0,ap, 此項將來由RNN告知,且已經是還原成pitch contour,以後此項不用
f0raw_estimate=f0raw_target; %設定欲調整之target
ap_estimate=exstraightAPind(source,fs,f0raw_estimate); %欲調整之target,ap Hint:我覺得ap還是用原來的(ap_source)比較好聽說!!

prm.defaultFrameLength=10; %framem=40;	% default frame length for pitch extraction (ms) 12/24
prm.spectralUpdateInterval=10; %shiftm=1;       % default frame shift (ms) for spectrogram 12/24
n3sgram_source=exstraightspec(source,f0raw_source,fs,prm); %以後此項拿掉   12/24
%n3sgram_target=exstraightspec(target,f0raw_target,fs); %以後此像拿掉
%n3sgram_estimate=exstraightspec(source,f0raw_estimate,fs);

prmS.spectralUpdateInterval=10; %12/24
sy_source=exstraightsynth(f0raw_source,n3sgram_source,ap_source,fs,prmS);%以後此項拿掉
%sy_target=exstraightsynth(f0raw_target,n3sgram_target,ap_target,fs);%以後此項拿掉
%sy_estimate1 = exstraightsynth(f0raw_estimate,n3sgram_estimate,ap_estimate,fs,prmS); %注意是因為設定了prmS才會有拉長的效果,ap=ap_estimate
%sy_estimate = exstraightsynth(f0raw_estimate,n3sgram_estimate,ap_source,fs,prmS); %注意是因為設定了prmS才會有拉長的效果,ap我覺得用ap_source 比ap_estimate好

soundsc(sy_source,fs); %以後此項拿掉,Source
%soundsc(sy_target,fs); %以後此項拿掉,Target
%soundsc(sy_estimate1,fs);%由Source改成Target
%soundsc(sy_estimate,fs);%由Source改成Target

%wavwrite(sy_estimate1/32768,fs,16,'C:/Program Files/MATLAB/R2008a/work/STRAIGHT/2_2_bad.wav');
%wavwrite(sy_estimate/32768,fs,16,'C:/Program Files/MATLAB/R2008a/work/STRAIGHT/2_2_good.wav');



figure
 tx=(0:length(sy_source)-1)/fs*1000;
 tfx=(0:length(f0raw_source)-1);
 plot(tx,sy_source/32768*50+80,'b',tfx,f0raw_source,'r');grid on;
 xlabel('time (ms)');
 
 figure
  tx=(0:length(sy_target)-1)/fs*1000;
 tfx=(0:length(f0raw_target)-1);
 plot(tx,sy_target/32768*50+80,'b',tfx,f0raw_target,'r');grid on;
 xlabel('time (ms)');
 
 figure
 [f0raw_estimate,ap]=exstraightsource(sy_estimate1,fs);
  tx=(0:length(sy_estimate1)-1)/fs*1000;
 tfx=(0:length(f0raw_estimate)-1);
 plot(tx,sy_estimate1/32768*50+80,'b',tfx,f0raw_estimate,'r');grid on;
 xlabel('time (ms)');
 
 figure
  [f0raw_estimate,ap]=exstraightsource(sy_estimate,fs);
  tx=(0:length(sy_estimate)-1)/fs*1000;
 tfx=(0:length(f0raw_estimate)-1);
 plot(tx,sy_estimate/32768*50+80,'b',tfx,f0raw_estimate,'r');grid on;
 xlabel('time (ms)');