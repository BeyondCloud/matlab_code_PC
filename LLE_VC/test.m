
fs = 16000; 
source_test_file = {'VC_COSPRO_VAD\F002\COSPRO 03_F002phr723_d.wav'};
audio_file=source_test_file;

mccDIM = 39;  

addpath('STRAIGHT\STRAIGHT\STRAIGHTV40_006b');
M = 2^15;
frame_length=25; % STRAIGHT analysis, synthesis set up. 25msec.
frame_shift=5; % STRAIGHT analysis, synthesis set up. 25msec.
prmP.defaultFrameLength=frame_length;
prmP.spectralUpdateInterval=frame_shift;


ap_path = 'feature\ap_data\';
result_path_mcc = ['result\mcc\',num2str(mccDIM),'dim\'];
result_path_wav = ['result\wav\'];

%% synthesis
ndata = length(audio_file);
for ni = 1:ndata
    % load mcc, f0, ap
    [~,source_filename,~] = fileparts(audio_file{ni});
    load([result_path_mcc,source_filename,'.mat']);
    load([ap_path,source_filename,'.mat']);

    % add power
    MCC_target_MLPGGV = cat(1,MCC_power,MCC_target_MLPGGV);

    % convert mcc back to sp
    sp_target_MLPGGV = mcc2sgram(MCC_target_MLPGGV,513,fs);

    % synthesis
%     yhat = exstraightsynth( f0_target, sp_target_MLPGGV, ap, fs, prmP);
%     yhat = yhat/M;
% 
%     if max(abs(yhat)) > 1
%         yhat = yhat/max(abs(yhat));
%     end
%     audiowrite([result_path_wav,source_filename,'.wav'],yhat,fs);
end