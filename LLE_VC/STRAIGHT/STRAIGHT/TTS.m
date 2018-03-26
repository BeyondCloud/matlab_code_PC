%2009/04/10�ק� ya

% 2008/12/23,24,25 
% Overall flowchat of TTS synthesizer
clear all;
% Reading data from tts
% Loading Data : 
% 1.��tts_lib output�걵�_�Ӫ����X����Wavetalbe  
[wavetable,fs]=wavread('wavetable.wav');  %���X�������`
% 2.����1�����}Wavetable��m
fid=fopen('wavetable_cut.dat','r'); % Syllable boundary and Initial Final boundary
wavetable_cut=fread(fid,'int32');  
wavetable_cut=wavetable_cut+1; % �]��matlab vector�}�Yindex��1,�D0
fclose(fid);
% 3.Target/Source Duration: duration(1)=>�ഫ��k0,1: 0=>unvoice ,1=>�L�n��(ex:��,�@)�άO�v�z�{���}�Y���n��
%duration(2)=Pause(frames) duration(3)=Initial Source(frames)
%duration(4)=Initial Target(frames) duration(5)=Fianl Source(frames) duration(6)=Final Target(frames)
fid=fopen('duration.dat','r');
duration=fread(fid,'short');   
fclose(fid);
% 4.Target loading Pitch Orthogonal
fid=fopen('pitch.dat','r');
pitch_orthogonal=fread(fid,'float');   
fclose(fid);
% % 5.Loading energy rate
% fid=fopen('energy.dat','r');
% energy_rate=fread(fid,'float');   
% fclose(fid);



% Synthesis voice from wavetable and prosody
% Block 1: �f�t�W�z1,2�̧�Ū�X�C��syllable
% Block 2: for i=1:N; N=total synthesis number
%          outputwaveform=syn(waveform,pitch,duration,energy)
%          concatenate outputwaveform and add pause
%          end
outputwaveform=0; %Initial value
outputwaveform1=0;
for i=1:length(wavetable_cut)
   % �̧Ǩ��Xwavetable�����걵syllable
     if i~=length(wavetable_cut)
         source_syllable=wavetable(wavetable_cut(i):wavetable_cut(i+1)-1);
     else 
         source_syllable=wavetable(wavetable_cut(i):end);
     end
   % Synthesized speech
   % Cdur[1]=>�ഫ��k0,1;��k1��ܨS��initial,or���n�l���v�z�{��, [2]=Pause(frames) [3]=Initial Source(frames)
   %     [4]=Initial Target(frames) [5]=Fianl Source(frames) [6]=Final Target(frames)
    
         Cpitch_orthogonal=pitch_orthogonal(((i-1)*4+1):((i-1)*4+4)); % Current pitch
         Cdur=duration(((i-1)*6+1):((i-1)*6+6));          % Current dur
 
         target_syllable=straightmodify(source_syllable,Cpitch_orthogonal,Cdur); 
%         target_syllable1=target_syllable*energy_rate(i);
         % concatenate target_syllable and add pause
         
%          dBsy=powerchk(target_syllable,fs,length(target_syllable)); % 23/Sept./1999
%          dBsy_2=powerchk(2*target_syllable,fs,length(target_syllable))
%          dBsy1=powerchk(source_syllable,fs,length(source_syllable));
%           dBsy1_2=powerchk(2*source_syllable,fs,length(source_syllable));
%          dBsy2=10*log10(sum(source_syllable.^2)/length(source_syllable));
    % 	  cf=(dB(32768)-22)-dBsy;
% 	   sy=sy*(10.0.^(cf/20));

         outputwaveform=[outputwaveform target_syllable];
         
         
         sprintf('Total %d syllables, %d done!',length(wavetable_cut),i)
end
outputwaveform(1)=[]; %����Initial value

% Block 3: play outputwaveform

soundsc(outputwaveform,fs);
fid1=fopen('outputwaveform_F1.pcm','wb');
fwrite(fid1,outputwaveform,'short');
fclose(fid1);
% outputwaveform=syn(waveform,Intial_Fianl position,pitch_rate,duration_rate,synthesis methods)
% block1: Duration modification :Method1: (1)initial (2) Final
%                                Method2: (1) Final only                            
% block2: Pitch modification :Method1: 
%                            :Method2: ���U�ڧѤFPSOLA��k����?
%