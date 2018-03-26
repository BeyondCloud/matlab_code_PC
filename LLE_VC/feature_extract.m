function feature_extract(audio_file,opt)
%% Setup
    if nargin < 2
        opt.none = 0;
    end
    if isfield(opt, 'mccDIM')
        mccDIM = opt.mccDIM; 
    else
        mccDIM = 39;
    end
    if isfield(opt, 'speaker_gender')
        speaker_gender = opt.speaker_gender; 
    else
        speaker_gender = 'G'; 
    end
    addpath('utility');
    build_dir(mccDIM);
    ndata = length(audio_file);
    M = 2^15;
%% feature_extraction
    for ni = 1:ndata
        % read audio
        [path,filename,~] = fileparts(audio_file{ni});
        [x,fs] = audioread([path,'\',filename,'.wav']); 
        x = x*M;
        
        % Vocoder
        %[spectrum,aperiodicity,f0]
        [ sp, ap, f0] = STRAIGHTvocoder(x, fs, speaker_gender);
        
        % sp2mcc feature
        % dim = 40,1
        mcc = mgcep_ver1(sp,mccDIM); % get MCC feature
        
        % save mat
        save(['feature\sp_data\',filename,'.mat'],'sp');
        save(['feature\ap_data\',filename,'.mat'],'ap');
        save(['feature\f0_data\',filename,'.mat'],'f0');
        save(['feature\mcc_data\',num2str(mccDIM),'dim\',filename,'.mat'],'mcc');
    end
end

