function LLE_converter(source_file, dictionary_file, opt)
%% Setup
    if nargin < 3
        opt.none = 0;
    end
    if isfield(opt, 'mccDIM')
        mccDIM = opt.mccDIM;
    else
        mccDIM = 39;
    end
    if isfield(opt, 'K')
        K = opt.K;
    else
        K = 1024;
    end
    if isfield(opt, 'tol')
        tol = opt.tol;
    else
        tol = 1e-3;
    end
    if isfield(opt, 'dynamic_flag')
        dynamic_flag = opt.dynamic_flag; 
    else
        dynamic_flag = 2; 
    end    

    addpath('utility');
    load(dictionary_file);

    mcc_path = ['feature\mcc_data\',num2str(mccDIM),'dim\'];
    f0_path = 'feature\f0_data\';
    result_path = ['result\mcc\',num2str(mccDIM),'dim\'];
    
%% LLE mapping
    ndata = length(source_file);
    for ni = 1:ndata
        [~,source_filename,~] = fileparts(source_file{ni});
        load([f0_path,source_filename,'.mat']);
        load([mcc_path,source_filename,'.mat']);

        MCC_power = mcc(1,:);
        MCC_source = dynamic_feature_ver1(mcc(2:end,:), dynamic_flag);

        MCC_target = zeros(size(MCC_source));
        f0_target = zeros(size(f0));
        nframe = size(MCC_source,2);

        for t = 1:nframe
        % convert sp
            Xt = MCC_source(:,t);
            % LLE
            dist = repmat(Xt,[1,size(source_dictionary,2)]) - source_dictionary;
            dist = sum(abs(dist).^2,1);
            [~,I] = sort(dist);
            %KNN             
            At = source_dictionary(:,I(1:K));
            
            %Lagrange method
            l = ones(K,1);
            Gt =  At-repmat(Xt,1,K); 
            Gt = Gt'*Gt; 
            Gt = Gt + eye(K,K)*tol*trace(Gt);
            Wt = Gt\l;
            Wt = Wt/(l'*Wt); %see eq(7) in paper
            % VC
            MCC_target(:,t) = target_dictionary(:,I(1:K)) * Wt;

        % convert f0
            if f0(t) ~= 0
                f0_target(t) = sqrt(f0_target_var/f0_source_var)*(f0(t)-f0_source_mean) + f0_target_mean;
            end
            
        end
        save([result_path,source_filename,'.mat'],'MCC_power','MCC_target','f0_target');
       
    end
end