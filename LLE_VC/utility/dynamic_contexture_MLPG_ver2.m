% 2015.12.25 constructed by Hwang, Hsin-Te
% 2015.12.25 modified by Hwang, Hsin-Te
% 2015.12.30 modified by Peng, Yu-Huai
% 1.This function performs Maximum likelihood parameter generation (MLPG) algorithm to 
%   smooth ANN-mapping's output
% 2.Modify from ver2
% 3.Major differences with ver2:
%   1) W matrix is construted based on contexture features (triple frames, in current version), e.g, if contexture_flag = 3; then Yt = [yt,yt-3,yt-2,yt-1,yt+1,yt+2,yt+3],
%      instead of dymaic features used in ver1, i.e., Yt=[yt,yt_delta,yt_delta^2]. where Y=Wy
%   2) input Cov also differs from ver1
function [converted_seq_mlpg]=dynamic_contexture_MLPG_ver2(Input_seq,Cov,dynamic_flag,contexture_flag,featureDIM)
extend_num = (contexture_flag*2+1)*(dynamic_flag+1);
converted_seq = zeros(featureDIM/extend_num,size(Input_seq,2));
parfor i=1:(featureDIM/extend_num)
    Cov_new = zeros(extend_num,extend_num);
    Input_seq_new = zeros(extend_num,size(Input_seq,2));
    for j = 1:extend_num
        Input_seq_new(j,:) = Input_seq(i+(featureDIM/extend_num)*(j-1),:); 
        Cov_new(j,j) = Cov(i+(featureDIM/extend_num)*(j-1),...
                            i+(featureDIM/extend_num)*(j-1));  
    end              
    [converted_seq(i,:)] = dynamic_contexture_MLPG_ver1(Input_seq_new,Cov_new,dynamic_flag,contexture_flag); % mcc_dim by lenght, using dynamic features     
end
converted_seq_mlpg=converted_seq;
end
function [output_sequence]=dynamic_contexture_MLPG_ver1(Input_seq,Cov,dynamic_flag,contexture_flag)
%% Input parameters:
% Input_seq: Input sequence obtained by ANN-mapping, 
% e.g., 3D-by-T -> ( Input_seq = (static+delta+delta^2) by T ), where D = dimension of static/contexture, T is total
% number of input frames. 
% Cov: A single Gaussian estimated covariance matrix, e.g., 3D by 3D 
% contexture_flag = 1~5; where 1-> [current frame, left one, right one]; 5 -> [current frame, left five, left four, left three, left two, left one, right one, right two, right three, right four, right five]; 

%% Output parameter:
% output_sequence: Generating smoothed output sequence


%% 1. Intial values setup for MLPG algorithm
sequence_length = size(Input_seq,2);
front_term=0;
back_term=0;

extend_num = (contexture_flag*2+1)*(dynamic_flag+1);
static_dim=size(Input_seq,1)/extend_num;

if dynamic_flag==1
    w_tmp = [[0*eye(static_dim) 1*eye(static_dim) 0*eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])];...
             [-0.5*eye(static_dim) 0*eye(static_dim) 0.5*eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])]];
    extend_flag = contexture_flag+1;
elseif dynamic_flag==2
    w_tmp =[[0*eye(static_dim) 1*eye(static_dim) 0*eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])];...
            [-0.5*eye(static_dim) 0*eye(static_dim) 0.5*eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])];...
            [1*eye(static_dim) -2*eye(static_dim) 1*eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])]];
    extend_flag = contexture_flag+1;
else
    w_tmp = [eye(static_dim) repmat(zeros(static_dim),[1,contexture_flag*2])];
    extend_flag = contexture_flag;
end
w = [];
for i = 1:contexture_flag*2+1
    if i == contexture_flag+1
        w = cat(1,circshift(w_tmp,static_dim*(i-1),2),w);
    else
        w = cat(1,w,circshift(w_tmp,static_dim*(i-1),2));
    end
end
w=sparse(w);
   

CCov_seq = zeros(size(Input_seq,1),size(Input_seq,1),sequence_length); % covariance sequence
for i = 1:sequence_length
    CCov_seq(:,:,i) = Cov(:,:);
end 


%% 2. MLPG algorithm
for j=1:sequence_length
       if j < extend_flag+1
             W=[w(:,(extend_flag+1-j)*static_dim+1:end),...
                 zeros( extend_num*static_dim,(sequence_length-extend_flag-j)*static_dim)];
       elseif j > sequence_length-extend_flag
             W=[zeros( extend_num*static_dim,(j-extend_flag-1)*static_dim),...
                 w(:,1:(sequence_length-j+extend_flag+1)*static_dim)]; 
       else
            W=[zeros( extend_num*static_dim,(j-extend_flag-1)*static_dim),...
                w,...
                zeros( extend_num*static_dim,(sequence_length-j-extend_flag)*static_dim)];
       end                     
                E=Input_seq(:,j);
                D=CCov_seq(:,:,j);
                D=sparse(D);
                Q=W'*(D^-1);
                front_term=sparse(front_term)+Q*W;         
                back_term=sparse(back_term)+Q*E;
end
            est_t=front_term\back_term;
            output_sequence=full(reshape(est_t,static_dim,sequence_length));
end         
