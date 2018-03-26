function poster_filter( source_file, dictionary_file, opt)
%% Setup
    if nargin < 3
        opt.none = 0;
    end
    if isfield(opt, 'dynamic_flag')
        dynamic_flag = opt.dynamic_flag; 
    else
        dynamic_flag = 2; 
    end    
    if isfield(opt, 'mccDIM')
        mccDIM = opt.mccDIM; 
    else
        mccDIM = 39; 
    end    
    
    addpath('utility');
    load(dictionary_file);
    
    result_path = ['result\mcc\',num2str(mccDIM),'dim\'];
    
%% MLPG & GV
    ndata = length(source_file);
    for ni = 1:ndata
        [~,source_filename,~] = fileparts(source_file{ni});
        load([result_path,source_filename,'.mat']);

        % do MLPG & GV
        MCC_target_MLPG = generalized_MLPG_ver2(MCC_target,target_Cov,dynamic_flag,size(MCC_target,1));
        MCC_target_MLPGGV = fast_MLGV_ver1(MCC_target_MLPG,target_GV);

        save([result_path,source_filename,'.mat'],...
                'MCC_target_MLPG','MCC_target_MLPGGV',...
                '-append');
    end
end