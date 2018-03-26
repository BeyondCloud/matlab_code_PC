function build_dir(mccDIM)
% for feature
    if ~exist('feature','dir')
        system(['mkdir feature']);
    end
    if ~exist('feature\sp_data','dir')
        system(['mkdir feature\sp_data']);
    end
   if ~exist('feature\ap_data','dir')
        system(['mkdir feature\ap_data']);
    end
   if ~exist('feature\f0_data','dir')
        system(['mkdir feature\f0_data']);
    end
   if ~exist('feature\mcc_data','dir')
        system(['mkdir feature\mcc_data']);
   end
    if ~exist(['feature\mcc_data\',num2str(mccDIM),'dim'],'dir')
        system(['mkdir feature\mcc_data\',num2str(mccDIM),'dim']);
    end 
% for dictionary
   if ~exist('dictionary','dir')
        system(['mkdir dictionary']);
   end
% for result
   if ~exist('result','dir')
        system(['mkdir result']);
   end    
   if ~exist('result\mcc','dir')
        system(['mkdir result\mcc']);
   end    
   if ~exist(['result\mcc\',num2str(mccDIM),'dim'],'dir')
        system(['mkdir result\mcc\',num2str(mccDIM),'dim']);
    end 
   if ~exist('result\wav','dir')
        system(['mkdir result\wav']);
   end    
   if ~exist('result\mcd','dir')
        system(['mkdir result\mcd']);
    end    
end