clear all; close all; clc; 
%% Setup
    % dataset
    load('source_train_file.mat');
    load('target_train_file.mat');
    source_gender = 'F';
    target_gender = 'M';
    % dictionary
    dictionary_file = 'dictionary\F002_to_M003.mat';
    % option
    opt.mccDIM = 39;
    opt.dynamic_flag = 2;
    opt.K = 1024;
    opt.tol = 1e-3;
    opt.fs = 16000;

%% Off-line: Build dictionary
% % Step 1: feature extracion
%     % source speaker
%     opt.speaker_gender = source_gender;
%     feature_extract(source_train_file,opt);
%     % target speaker
%     opt.speaker_gender = target_gender;
%     feature_extract(target_train_file,opt);
    
% Step 2: alignment
%     disp('Step 2: alignment')
%     build_dictionary( source_train_file, target_train_file, dictionary_file, opt);

% Step 3: generate statistic parameter for MLPG & GV
%     disp('Step 3: generate statistic parameter for MLPG & GV')
%     parameter_generater( dictionary_file, opt);

%% On-line: Voice Conversion
    source_test_file = {'VC_COSPRO_VAD\F002\COSPRO 03_F002phr723_d.wav'};
    %%don't need this one if we're not estimating quality
%     target_test_file = {'VC_COSPRO_VAD\M003\COSPRO 03_M003phr720_d.wav'};

% Step 1: feature extracion
    % source speaker
%     disp('Step 1: feature extracion')
%     opt.speaker_gender = source_gender;
%     feature_extract(source_test_file,opt);
    % target speaker
%     opt.speaker_gender = target_gender;
%     feature_extract(target_test_file,opt);

% % Step 2: LLE mapping
%     disp('Step 2: LLE mapping')
%     LLE_converter(source_test_file, dictionary_file, opt);
% 
% % Step 3: Poster Filtering
%     disp('Step 3: Poster Filtering')
%     poster_filter(source_test_file, dictionary_file, opt);

% % Step 4: Synthesis
    disp('Step 4: Synthesis')
    feature_synthesis(source_test_file,opt);
% 
% % Step *: Quality Estimation
% %     disp('Step *: Quality Estimation')
% %     quality_estimate( source_test_file, target_test_file, opt);
