clear;clc;
audio_file = 'src_train\s5.wav';
mccDIM = 39; 
addpath('STRAIGHT\STRAIGHT\STRAIGHTV40_006b');
ap_path = 'feature\ap_data\';
f0_path = 'feature\f0_data\';

opt.speaker_gender = 'F';
% feature_extract({audio_file},opt);

result_path_mcc = ['feature\mcc_data\',num2str(mccDIM),'dim\'];

[~,source_filename,~] = fileparts(audio_file);
load([result_path_mcc,source_filename,'.mat']);
load([ap_path,source_filename,'.mat']);
load([f0_path,source_filename,'.mat']);

M = 2^15;
frame_length=25; % STRAIGHT analysis, synthesis set up. 25msec.
frame_shift=5; % STRAIGHT analysis, synthesis set up. 5msec.
prmP.defaultFrameLength=frame_length;
prmP.spectralUpdateInterval=frame_shift;
fs = 16000;
sp_target_MLPGGV = mcc2sgram(mcc,513,fs);
% f0(:) = 329.628;
yhat = exstraightsynth( f0, sp_target_MLPGGV, ap, fs, prmP);
yhat = yhat/M;
sound(yhat,16000);