function quality_estimate( source_file, target_file, opt)
%% Setup
    addpath('utility');
    if isfield(opt, 'mccDIM')
        mccDIM = opt.mccDIM; 
    else
        mccDIM = 39; 
    end


    result_path_mcc = ['result\mcc\',num2str(mccDIM),'dim\'];
    result_path_mcd = ['result\mcd\'];
    mcc_path = ['feature\mcc_data\',num2str(mccDIM),'dim\'];

    ndata = length(source_file);
    
%% Calculate MCD & LSD
    for ni = 1:ndata
        tic
        % load data
        [~,source_filename,~] = fileparts(source_file{ni});
        load([result_path_mcc,source_filename,'.mat']);
        load([mcc_path,source_filename,'.mat']);
        mcc_ori = mcc(2:end,:);
        
        [~,target_filename,~] = fileparts(target_file{ni});
        load([mcc_path,target_filename,'.mat']);
        mcc_tar = mcc(2:end,:);

        % get MCD of original signal
        [dtwPath,~] = DTW(mcc_tar(1:mccDIM,:), mcc_ori(1:mccDIM,:));
        MCD_ori = mcd_function(mcc_tar(1:mccDIM,dtwPath(1,:)),mcc_ori(1:mccDIM,dtwPath(2,:)));
        MCD_lle = mcd_function(mcc_tar(1:mccDIM,dtwPath(1,:)),MCC_target_MLPG(1:mccDIM,dtwPath(2,:)));
        save([result_path_mcd,source_filename,'.mat'],'MCD_ori','MCD_lle');
    end

end

