function feature_synthesis(audio_file,opt)
%% Setup
    if nargin < 2
        opt.none = 0;
    end
    if isfield(opt, 'fs')
        fs = opt.fs; 
    else
        fs = 16000; 
    end
    if isfield(opt, 'mccDIM')
        mccDIM = opt.mccDIM; 
    else
        mccDIM = 39; 
    end    
    
    addpath('STRAIGHT\STRAIGHT\STRAIGHTV40_006b');
    M = 2^15;
    frame_length=25; % STRAIGHT analysis, synthesis set up. 25msec.
    frame_shift=5; % STRAIGHT analysis, synthesis set up. 5msec.
    prmP.defaultFrameLength=frame_length;
    prmP.spectralUpdateInterval=frame_shift;

    
    ap_path = 'feature\ap_data\';
    f0_path = 'feature\f0_data\';
    
    result_path_mcc = ['result\mcc\',num2str(mccDIM),'dim\'];
    result_path_wav = ['result\wav\'];
    
%% synthesis
    ndata = length(audio_file);
    for ni = 1:ndata
        % load mcc, f0, ap
        [~,source_filename,~] = fileparts(audio_file{ni});
        load([result_path_mcc,source_filename,'.mat']);
        load([ap_path,source_filename,'.mat']);
        load([f0_path,source_filename,'.mat']);
        % add power
        MCC_target_MLPGGV = cat(1,MCC_power,MCC_target_MLPGGV);
        
        % convert mcc back to sp
        sp_target_MLPGGV = mcc2sgram(MCC_target_MLPGGV,513,fs);
        
        % synthesis
        yhat = exstraightsynth( f0, sp_target_MLPGGV, ap, fs, prmP);
        yhat = yhat/M;

        if max(abs(yhat)) > 1
            yhat = yhat/max(abs(yhat));
        end
        audiowrite([result_path_wav,source_filename,'.wav'],yhat,fs);
    end
end