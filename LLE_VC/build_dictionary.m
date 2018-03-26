function build_dictionary( source_file, target_file, dictionary_file, opt)
%% Setup
    addpath('utility');
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


    f0_path = 'feature\f0_data\';
    mcc_path = ['feature\mcc_data\',num2str(mccDIM),'dim\'];
    
    source_dictionary = [];
    target_dictionary = [];
    source_f0_dictionary = [];
    target_f0_dictionary = [];
    
    ndata = length(source_file);
    
%% Build Dictionary
    for ni = 1:ndata
        tic
        % load data
        [~,source_filename,~] = fileparts(source_file{ni});
        load([mcc_path,source_filename,'.mat']);
        
        %batch 3 neighbor frame together
        % get dynamic feature
        mcc1 = dynamic_feature_ver1(mcc(2:end,:), dynamic_flag); 
        
        [~,target_filename,~] = fileparts(target_file{ni});
        load([mcc_path,target_filename,'.mat']);
        mcc2 = dynamic_feature_ver1(mcc(2:end,:), dynamic_flag); % get dynamic feature

        % alignment
        [dtwPath,~] = DTW(mcc1(1:end/(dynamic_flag+1),:), mcc2(1:end/(dynamic_flag+1),:));
        % find the min one in the same conponent,remove other non min same
        % component
        [P1,P2] = min_unique(mcc1(1:end/(dynamic_flag+1),:),mcc2(1:end/(dynamic_flag+1),:),dtwPath(1,:),dtwPath(2,:));
  
        % get dictionary
        source_dictionary = cat(2,source_dictionary,mcc1(:,P1));
        target_dictionary = cat(2,target_dictionary,mcc2(:,P2));       

        % get f0
        load([f0_path,source_filename,'.mat']);
        f01 = f0(:,:);
        load([f0_path,target_filename,'.mat']);
        f02 = f0(:,:);
        source_f0_dictionary = cat(1,source_f0_dictionary,f01);
        target_f0_dictionary = cat(1,target_f0_dictionary,f02);
        
        fprintf('data %d :, Elapsed time is %f seconds.\n', ni,toc)
    end
    save(dictionary_file,'source_dictionary','target_dictionary', ...
                                    'source_f0_dictionary','target_f0_dictionary');
end

