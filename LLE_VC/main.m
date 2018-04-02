clear all; close all; clc; 
%% Setup
    addpath('../MATLAB_TSM-Toolbox_2.01');
    % dataset
    load('src.mat');
    load('tar.mat');

    source_gender = 'F';
    target_gender = 'M';
    % dictionary
    dictionary_file = 'dictionary\F002_to_M003.mat';
    % option
    opt.mccDIM = 39;
    opt.dynamic_flag = 2;
    opt.K = 32;
    opt.tol = 1e-3;
    [~,fs]= audioread(source_train_file{1});
    opt.fs = fs;
    
%     normalize pitch
%     % 329.628
    [path,filename,~] = fileparts(source_train_file{1});
%     [x,fs] = audioread([path,'\',filename,'.wav']); 
%     y = pit_norm(x,329.628);
%     audiowrite([path,'\',filename,'_norm.wav'],y,16000);
    source_train_file = {[path,'\',filename,'_norm.wav']};
   
    [path,filename,~] = fileparts(target_train_file{1});
%     [x,fs] = audioread([path,'\',filename,'.wav']); 
%     y = pit_norm(x,329.628);
%     audiowrite([path,'\',filename,'_norm.wav'],y,16000);
    target_train_file = {[path,'\',filename,'_norm.wav']};

% %% Off-line: Build dictionary
% Step 1: feature extracion
    disp('Step 1: feature extracion');
    % source speaker
    opt.speaker_gender = source_gender;
    feature_extract(source_train_file,opt);
    % target speaker
    opt.speaker_gender = target_gender;
    feature_extract(target_train_file,opt);
%     
% % Step 2: alignment
    disp('Step 2: alignment')
    build_dictionary( source_train_file, target_train_file, dictionary_file, opt);
% 
% % Step 3: generate statistic parameter for MLPG & GV
    disp('Step 3: generate statistic parameter for MLPG & GV')
    parameter_generater( dictionary_file, opt);

    disp('done off line')
    
%% On-line: Voice Conversion
      source_test_file = {'src_train\s6.wav'};
      %norm pit
        [path,filename,~] = fileparts(source_test_file{1});
%         [x,fs] = audioread([path,'\',filename,'.wav']); 
%         y = pit_norm(x,329.628);
%         audiowrite([path,'\',filename,'_norm.wav'],y,16000);
        source_test_file = {[path,'\',filename,'_norm.wav']};
        
%     source_test_file = {'VC_COSPRO_VAD\F002\COSPRO 03_F002phr720_d.wav'};

% Step 1: feature extracion
    disp('Step 1: feature extracion')
    opt.speaker_gender = source_gender;
    feature_extract(source_test_file,opt);


% Step 2: LLE mapping
    disp('Step 2: LLE mapping')
    LLE_converter(source_test_file, dictionary_file, opt);

% % Step 3: Poster Filtering
    disp('Step 3: Poster Filtering')
    poster_filter(source_test_file, dictionary_file, opt);

% % Step 4: Synthesis
    disp('Step 4: Synthesis')
    feature_synthesis(source_test_file,opt);
