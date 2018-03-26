function [target_syllable]= straightmodify(source_syllable,Cpitch_orthogonal,Cdur)
%   Designed and coded by Hsin Te Hwang
%   25/December/2008

%---- Check input parameters
switch nargin
    case 3
        fs=20000; % sampling frequence (Hz)  %Tao  原本20000
        pitch_frame=10; % analysis frame of pitch detection (ms)
        pitch_frameshift=10; % frame shift of pitch detection (ms)
        spec_frame=10; %(ms)
        spec_frameshift=10; %(ms)
    otherwise
        disp('Number of arguments is not relevant.');
        return
end;

%防呆，因為target在切割時，會因為ㄅ ㄉ ㄎ等太短的切不出來，所以直接給1，=10ms
if Cdur(1)==0
    if Cdur(4)==0;
        Cdur(4)=1; 
    end
end

% Calculate the length of Initial and Final of source and target
Ini_sourceL=Cdur(3)*pitch_frame*10^-3*fs; %length of source Initial (samples)
Ini_targetL=Cdur(4)*pitch_frame*10^-3*fs; %length of target Initial (samples)
Final_sourceL=Cdur(5)*pitch_frame*10^-3*fs; %length of source Final (samples)
Final_targetL=Cdur(6)*pitch_frame*10^-3*fs; %length of target Final (samples)

% Method 1: source_syllable"不屬於"Initial null,ㄇㄋㄌㄖ開頭
if Cdur(1)==0
% Step1: Duration modification
imap2=straightDurmodify(Ini_sourceL,Ini_targetL,Final_sourceL,Final_targetL,fs,Cdur(1));
prm.F0defaultWindowLength=40; % default frame length for pitch extraction (ms)  
prm.F0frameUpdateInterval=1; % shiftm % F0 calculation interval (ms)   
[f0raw_source,ap_source]=exstraightsource(source_syllable,fs,prm);  % 求source f0,ap   
%f0raw_source = MulticueF0v14(source_syllable,fs);
%ap_source = exstraightAPind(source_syllable,fs,f0raw_source);

%這裡要多加 fO target and ap
voice_frame=Cdur(5)*10;%length(f0raw_source);
y=recover(Cpitch_orthogonal,voice_frame-1);
pitch=y*200/100+0.5;%if(MF_flag)   %Tao  原本200
% 		           pitch[k]=(long)(Sum*Frame/100+0.5); 
%                 else
% 		           pitch[k]=(long)(Sum*Frame/441+0.5); 
FO=fs./pitch;  % target F0
FO=[zeros(1,length(f0raw_source)-length(FO)) FO'];
%ap_estimate=exstraightAPind(source_syllable,fs,FO); % 用ap_source比較好聽ㄝ!

prm.defaultFrameLength=40; %frame=40;	% default frame length for spectrogram  (ms) 
prm.spectralUpdateInterval=1; %shiftm=1;       % default frame shift (ms) for spectrogram 

%n3sgram_source=exstraightspec(source_syllable,f0raw_source,fs);
n3sgram_source=exstraightspec(source_syllable,f0raw_source,fs,prm);
%n3sgram_source=exstraightspec(source_syllable,FO,fs,prm); %n3sgram_source指的是target spectrogram

prmS.spectralUpdateInterval=1; 
prmS.timeAxisMappingTable=imap2;  % key parameter for modify duration,
% target_syllable=exstraightsynth(f0raw_source,n3sgram_source,ap_source,fs,prmS);%以後此項拿掉
target_syllable=exstraightsynth(FO,n3sgram_source,ap_source,fs,prmS);%以後此項拿掉




target_syllable=[zeros(1,Cdur(2)*200) target_syllable']; %Tao  原本200
%[sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,prmS); 
%soundsc(sy,fs);  %此時放音會聽到聲音被拉長了

% Step2: Final pitch modification
% (1) 保險法: A.直接用Straight分析調整後的聲音,可得pitch與幾個frame
%             B.還原正交化係數為hz,長度同A. PS:記得frame shift那些設定.
%             C.還原後的fO=>target,直接取代A.求得的pitch,and ap.



% Method 2: source_syllable"屬於"Initial null,ㄇㄋㄌㄖ開頭
elseif Cdur(1)==1
% Step1: Voice (Initial+Final duration modification)
IniFi_sourceL=length(source_syllable)%Ini_sourceL+Final_sourceL
imap2=straightDurmodify(0,Ini_targetL,IniFi_sourceL,Final_targetL,fs,Cdur(1));
%IniFi_imap=straightDurmodify(IniFi_sourceL,IniFi_targetL,fs);
% Step2: Voice part pitch modification
%要先用straight拉長阿!!
prm.F0defaultWindowLength=40; % default frame length for pitch extraction (ms)  
prm.F0frameUpdateInterval=1; % shiftm % F0 calculation interval (ms)   
[f0raw_source,ap_source]=exstraightsource(source_syllable,fs,prm);  % 求source f0,ap   
%  f0raw_source = MulticueF0v14(source_syllable,fs);
% ap_source = exstraightAPind(source_syllable,fs,f0raw_source);


%這裡要多加 fO target and ap
voice_frame=length(f0raw_source);
y=recover(Cpitch_orthogonal,voice_frame-1);
pitch=y*200/100+0.5; %sample  %Tao  原本200
FO=fs./pitch;
%ap_estimate=exstraightAPind(source_syllable,fs,FO); %
%FO=[zeros(1,length(f0raw_source)-length(FO)) FO'];
    
prm.defaultFrameLength=40; %framem=40;	% default frame length for pitch extraction (ms) 
prm.spectralUpdateInterval=1; %shiftm=1;       % default frame shift (ms) for spectrogram 


% n3sgram_source=exstraightspec(source_syllable,f0raw_source,fs);
n3sgram_source=exstraightspec(source_syllable,f0raw_source,fs,prm); 
%n3sgram_source=exstraightspec(source_syllable,FO,fs,prm);



prmS.spectralUpdateInterval=1; 
prmS.timeAxisMappingTable=imap2;  % key parameter for modify duration,
% target_syllable=exstraightsynth(f0raw_source,n3sgram_source,ap_source,fs,prmS);%以後此項拿掉
 target_syllable=exstraightsynth(FO,n3sgram_source,ap_source,fs,prmS);%以後此項拿掉



target_syllable=[zeros(1,Cdur(2)*200) target_syllable']; %Tao  原本200
else
   disp('Synthesis method error!!');
   return
end




