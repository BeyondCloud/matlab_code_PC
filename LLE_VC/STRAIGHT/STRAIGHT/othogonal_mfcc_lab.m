% 2009/1/5 othogonal expansion apply to MFCC lab and resynthesize.
%clear all;
addpath 'C:/Program Files/MATLAB/R2008a/work/STRAIGHT/rastamat';
% 1.��tts_lib output�걵�_�Ӫ����X����Wavetalbe  
[wavetable,fs]=wavread('c:/wavetable.wav'); %�����Φ�mfrom wavetable,�����ӧ令ŪDS1.rnn�H�Ψ���Φ�m.
% 2.����1�����}Wavetable��m
fid=fopen('c:/wavetable_cut.dat','r');
wavetable_cut=fread(fid,'int32');  
wavetable_cut=wavetable_cut+1; % �]��matlab vector�}�Yindex��1,�D0
fclose(fid);

mfcc_dim = 24;  % dimensions 
outputwaveform=0; %Initial value
outputwaveform1=0;
outputwaveform2=0;
for i=1:length(wavetable_cut)
   % �̧Ǩ��Xwavetable�����걵syllable
     if i~=length(wavetable_cut)
         source_syllable=wavetable(wavetable_cut(i):wavetable_cut(i+1)-1);
     else 
         source_syllable=wavetable(wavetable_cut(i):end);
     end
   
  %  �惡���`�����R�èD�XSTRAIGHT Spectrogram
     analysisParams.F0defaultWindowLength = 40;
     analysisParams.F0frameUpdateInterval=1;
     [f0raw,ap]=exstraightsource(source_syllable,fs,analysisParams);
     
     analysisParamsSp.defaultFrameLength = 40;
     analysisParamsSp.spectralUpdateInterval=1;
     n3sgram=exstraightspec(source_syllable,f0raw,fs,analysisParamsSp);
     
     target_syllable = exstraightsynth(f0raw,n3sgram,ap,fs);
     outputwaveform=[outputwaveform target_syllable'];
    % soundsc(outputwaveform,fs);
  %  �惡���`spectrum�@mfcc encode,�åB�٭줧 (�ثe�p�����k)
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
      
   %  �ϥΥ���ƫY�ƥhmodel "syllable based firstly" mfcc, encode�C�@��,�Υ���ƫY��; than decode�^�h�é�.
      energy = cepstra(1,:);
      cepstra(1,:) = [];
      mfcc_orthogonal=0;
      [size_row,size_col]=size(cepstra);
      for j=1:size_row  % mfcc_dim-1
          tmp=Orthogonal_Expansion(1,size_col,cepstra(j,:));
          mfcc_orthogonal=[mfcc_orthogonal tmp'];   %Encode
      end
      mfcc_orthogonal(1)=[];
      mfcc_orthogonal=mfcc_orthogonal';
      %Decode
      cepstra_back=zeros(size_row,size_col);
      for j=1:length(mfcc_orthogonal)/4  
           tmp1=mfcc_orthogonal(1+4*(j-1):(4*j),1);
           tmp=recover(tmp1,size_col-1);
           cepstra_back(j,:)=tmp';   % Decode; PS:�i�H�e���٭�ݬ�
      end
      cepstra_back = [energy;cepstra_back];
      n3sgram2 = inv_STRAIGHT_mfcc(cepstra_back, fs, 'wintime', 0.04, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
     
      target_syllable2 = exstraightsynth(f0raw,n3sgram2,ap,fs);
      outputwaveform2=[outputwaveform2 target_syllable2'];
     % soundsc(target_syllable2,fs);
      
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
outputwaveform(1)=[]; %����Initial value
outputwaveform1(1)=[];
outputwaveform2(1)=[];
% % Block 3: play outputwaveform
soundsc(outputwaveform,fs);
soundsc(outputwaveform1,fs);
soundsc(outputwaveform2,fs);
