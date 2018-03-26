% 2009/1/5 othogonal expansion apply to MFCC lab and resynthesize.
%clear all;
addpath 'C:/Program Files/MATLAB/R2008a/work/STRAIGHT/rastamat';
% 1.由tts_lib output串接起來的欲合成之Wavetalbe  
[wavetable,fs]=wavread('c:/wavetable.wav'); %有切割位置from wavetable,我應該改成讀DS1.rnn以及其切割位置.
% 2.對應1的切開Wavetable位置
fid=fopen('c:/wavetable_cut.dat','r');
wavetable_cut=fread(fid,'int32');  
wavetable_cut=wavetable_cut+1; % 因為matlab vector開頭index為1,非0
fclose(fid);

mfcc_dim = 36;  % dimensions 
outputwaveform=0; %Initial value
outputwaveform1=0;
outputwaveform2=0;
for i=1:1%length(wavetable_cut)  %8/20
   % 依序取出wavetable內的串接syllable
     if i~=length(wavetable_cut)
         source_syllable=wavetable(wavetable_cut(i):wavetable_cut(i+1)-1);
     else 
         source_syllable=wavetable(wavetable_cut(i):end);
     end
   
  %  對此音節做分析並求出STRAIGHT Spectrogram
     analysisParams.F0defaultWindowLength = 40;
     analysisParams.F0frameUpdateInterval=1;
     [f0raw,ap]=exstraightsource(source_syllable,fs,analysisParams);
     
     analysisParamsSp.defaultFrameLength = 40;
     analysisParamsSp.spectralUpdateInterval=1;
     n3sgram=exstraightspec(source_syllable,f0raw,fs,analysisParamsSp);
     
     target_syllable = exstraightsynth(f0raw,n3sgram,ap,fs);
     outputwaveform=[outputwaveform target_syllable'];
    % soundsc(outputwaveform,fs);
  %  對此音節spectrum作mfcc encode,並且還原之 (目前小宋做法)
      cepstra = STRAIGHT_mfcc(n3sgram, fs, 'wintime', 0.04, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
      
      n3sgram1 = inv_STRAIGHT_mfcc(cepstra, fs, 'wintime', 0.04, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
     
      target_syllable1 = exstraightsynth(f0raw,n3sgram1,ap,fs);
      outputwaveform1=[outputwaveform1 target_syllable1'];
     % soundsc(outputwaveform1,fs);
      
   %  使用正交化係數去model "syllable based firstly" mfcc, encode每一維,用正交化係數; than decode回去並放音.
      energy = cepstra(1,:);
      cepstra(1,:) = [];
      [size_row,size_col]=size(cepstra);
      N=2; %分N等份
      mfcc_orthogonal=zeros(size_row,4*N); 
      for j=1:size_row  % mfcc_dim-1
          tmp=0
          for k=1:N %分N等份 新增
          tmp1=Orthogonal_Expansion(1,size_col/N,cepstra(j,1+size_col*(k-1)/N:size_col*k/N))';
          %tmp1(3:4)=0; %故意把2,3order拿掉,其實已經聽不出來了
          tmp=[tmp tmp1]; %新增
          end
          tmp(1)=[];
          mfcc_orthogonal(j,:)=tmp;
      end
     
      %Decode
      cepstra_back=zeros(size_row,size_col);
      [a,b]=size(mfcc_orthogonal);  
      for k=1:size_row
          tmp2=0;
      for j=1:b/4
           tmp1=mfcc_orthogonal(k,1+4*(j-1):(4*j));
           tmp=recover(tmp1,size_col/N-1);
           tmp2=[tmp2 tmp'];   % Decode; PS:可以畫圖還原看看
           %figure; 
           %plot(1:length(tmp),mfcc_orthogonal(k,1+4*(j-1)),'r');
      end
      tmp2(1)=[];
      cepstra_back(k,:)=tmp2;
      end
      figure %8/20
      plot(cepstra_back(1,:),'r');%8/20
      hold on;%8/20
      plot(cepstra(1,:));%8/20
      hold off; %8/20
    %  tmp=zeros(1,144);%
    %  tmp(1,:)=mean(energy); %
    %  cepstra_back = [tmp;cepstra_back]; %
      cepstra_back = [energy;cepstra_back];
      %cepstra_mean=cepstra_back;
      n3sgram2 = inv_STRAIGHT_mfcc(cepstra_back, fs, 'wintime', 0.04, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
     
      target_syllable2 = exstraightsynth(f0raw,n3sgram2,ap,fs);
      outputwaveform2=[outputwaveform2 target_syllable2'];
      %soundsc(target_syllable2,fs);
      
%      voice_frame=length(f0raw_source);
%y=recover(Cpitch_orthogonal,voice_frame-1);
      
   % Synthesized speech
        
%          Cpitch_orthogonal=pitch_orthogonal(((i-1)*4+1):((i-1)*4+4)); % Current pitch
%          Cdur=duration(((i-1)*6+1):((i-1)*6+6));          % Current dur
%          target_syllable=straightmodify(source_syllable,Cpitch_orthogonal,Cdur);                  
%          concatenate target_syllable and add pause
%          outputwaveform=[outputwaveform target_syllable];
%          sprintf('Total %d syllables, %d done!',length(wavetable_cut),i)
end
outputwaveform(1)=[]; %拿掉Initial value
outputwaveform1(1)=[];
outputwaveform2(1)=[];
% % Block 3: play outputwaveform
%soundsc(outputwaveform,fs);
%soundsc(outputwaveform1,fs);
output8=outputwaveform2;
soundsc(output8,fs);
