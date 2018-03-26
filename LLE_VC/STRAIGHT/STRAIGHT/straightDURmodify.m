function [imap2]= straightDurmodify(IsourceL,ItargetL,FsourceL,FtargetL,fs,method)
%   Designed and coded by Hsin Te Hwang
%   25/December/2008

%   [imap2]= straightDurmodify(sourceL,targetL,fs)
%   Input parameters
%   IsourceL : length of source Initial (sample point) 
%   ItargetL : length of target Initial (sample point)
%   FsourceL : length of source Final (sample point) 
%   FtargetL : length of target Final (sample point)
%   fs      : sampling frequency (Hz)
%   method: 0=>Syllable with Initial(unvoice)+Final; 1=>Syllable with Initial(Null/voice)+Final 
%   Output parameters
%   imap2   : this parameter is mainly for function of exstraightsynth   

%---- Check input parameters
if nargin~=6
        disp('Number of arguments is not relevant');
        return
end;
%======== duration moditication (mapping)  =========== %
%step1: duration要先拉長成為target duration
if method==0
    Sseg1=IsourceL*1000/fs;
    Sseg2=Sseg1+FsourceL*1000/fs;
    Tseg1=ItargetL*1000/fs;
    Tseg2=Tseg1+FtargetL*1000/fs;
%ogtm=[0 (length(source)-1)*1000/fs]; %source duration (ms)
%trgt=[0 (length(target)-1)*1000/fs]; %target duration (ms)
    ogtm=[0 Sseg1 Sseg2];
    trgt=[0 Tseg1 Tseg2];
%otm=0:1000/fs:(length(target)-1)*1000/fs;
otm=0:1000/fs:Tseg2;
imap=interp1(trgt,ogtm,otm);  % mapping function 
else % method==1
    Sseg2=FsourceL*1000/fs;
    Tseg1=ItargetL*1000/fs;
    Tseg2=Tseg1+FtargetL*1000/fs;
    ogtm=[0 Sseg2];
    trgt=[0 Tseg2];
    otm=0:1000/fs:Tseg2;
    imap=interp1(trgt,ogtm,otm);  % mapping function 
end

% figure
% plot(imap)
% plot((0:length(imap)-1)/fs*1000,imap);grid on
% xlabel('target time (ms)')
% ylabel('original time (ms)')
 imap2=imap+1;


%prmS.timeAxisMappingTable=imap2;  % key parameter for modify duration,
%[sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,prmS); 
%soundsc(sy,fs);  %此時放音會聽到聲音被拉長了
