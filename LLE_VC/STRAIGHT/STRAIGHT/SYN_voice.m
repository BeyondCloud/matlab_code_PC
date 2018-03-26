% 做Voice Conversion的合成部份
% 即是Synthesis phase

clear all;
pack;
clc;

addpath 'E:/bond8246/research/rastamat';
load 'E:/bond8246/common_research/iterative9/MOS_GMM_parameter_sung_tu';

load 'E:/bond8246/research/MOS_STRmfcc_24/sung/pitch';
source_pitch = [];
[m,n] = size(f0);
for i = 1:n
    if f0(i) ~= 0
        source_pitch = [source_pitch f0(i)];
    end
end


load 'E:/bond8246/research/MOS_STRmfcc_24/tu/pitch';
target_pitch = [];
[m,n] = size(f0);
for i = 1:n
    if f0(i) ~= 0
        target_pitch = [target_pitch f0(i)];
    end
end


mixture = 16;  % mixture數
mfcc_dim = 24;  % dimension數

% 讀檔
[x,fs]=wavread('E:/bond8246/vc_training_data/MOS/WAV/sung/treebank_018_sung');%  輸入要轉換的音檔

analysisParams.F0defaultWindowLength = 25;
analysisParams.F0frameUpdateInterval=10;
[f0raw,ap,analysisParams]=exstraightsource(x,fs,analysisParams);

analysisParamsSp.defaultFrameLength = 25;
analysisParamsSp.spectralUpdateInterval=10;
[n3sgram,analysisParamsSp]=exstraightspec(x,f0raw,fs,analysisParamsSp);

% ========================================================================
cepstra = STRAIGHT_mfcc(n3sgram, fs, 'wintime', 0.025, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
% ========================================================================
energy = cepstra(1,:);
cepstra(1,:) = [];
est_target = kain_gmm_TF(cepstra,mixture,mfcc_dim-1,Mu,Sigma,Priors);
cepstra = [energy;est_target];
% ========================================================================
n3sgram = inv_STRAIGHT_mfcc(cepstra, fs, 'wintime', 0.025, 'hoptime', 0.010, ...
          'numcep', mfcc_dim, 'lifterexp', 0.6, 'sumpower', 1, 'preemph', 0.97, ...
	  'dither', 0, 'minfreq', 0, 'maxfreq', fs/2, ...
	  'nbands', 24, 'bwidth', 1.0, 'dcttype', 2, ...
	  'fbtype', 'mel', 'usecmp', 0, 'modelorder', 0);
% ========================================================================

f0raw = exp((log(f0raw)-mean(log(source_pitch)))*sqrt(var(log(target_pitch)))/sqrt(var(log(source_pitch)))+mean(log(target_pitch))); % modify pitch   

prmS.spectralUpdateInterval=10;
[sy,prmS] = exstraightsynth(f0raw,n3sgram,ap,fs,prmS);

wavwrite(sy/32768,fs,16,'E:/bond8246/common_research/iterative9/CON_treebank_018_sung_tu');% 輸出音檔








