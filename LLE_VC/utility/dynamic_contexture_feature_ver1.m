% 2013.11.25 constructed by Hwang, Hsin-Te: 
% 2013.11.25 modified by Hwang, Hsin-Te
% Computing contexture and dynamic features

function output_sequence=dynamic_contexture_feature_ver1(static_feature_seq,dynamic_flag,contexture_flag)
% static_feature_seq: static feature sequence
% dynamic_flag: 1=>delta, 2=> delta^2
% output_sequence: joint static and dynamic feature sequence
output_sequence=[];
[static_dim,seq_length]=size(static_feature_seq);

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
    extend_flag = contexture_flag+0;
end
w = [];
for i = 1:contexture_flag*2+1
    if i == contexture_flag+1
        w = cat(1,circshift(w_tmp,static_dim*(i-1),2),w);
    else
        w = cat(1,w,circshift(w_tmp,static_dim*(i-1),2));
    end
end

for i=1:seq_length
       if i < extend_flag+1
          static=zeros(static_dim,extend_flag*2+1);
          static(:,extend_flag+2-i:end)=static_feature_seq(:,1:i+extend_flag);
       elseif i > size(static_feature_seq,2)-extend_flag
          static=zeros(static_dim,extend_flag*2+1);
          static(:,1:extend_flag+1+(seq_length-i))=static_feature_seq(:,i-extend_flag:end);                                  
       else
          static=static_feature_seq(:,i-extend_flag:i+extend_flag);
       end
      len=size(static,2);    
      y=reshape(static,static_dim*len,1);
      dynamic_feature_vector=w*y;    
      output_sequence=cat(2,output_sequence,dynamic_feature_vector);
end      