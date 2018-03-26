function [output_seq] = fast_MLGV_ver1(converted_seq,var_Mean)

var_est_y = var(converted_seq,1,2);
mean_est_y = mean(converted_seq,2);            
T=size(converted_seq,2);
output_seq = ((var_Mean./var_est_y).^0.5)*ones(1,T).*(converted_seq-mean_est_y*ones(1,T))+mean_est_y*ones(1,T); 
