function parameter_generater( dictionary_file, opt)
    if nargin < 3
        opt.none = 0;
    end
    if isfield(opt, 'dynamic_flag')
        dynamic_flag = opt.dynamic_flag; 
    else
        dynamic_flag = 2; 
    end

    load(dictionary_file);
    
    % get GV % Cov
    source_GV = var(source_dictionary(1:end/(dynamic_flag+1),:),1,2);
    target_GV = var(target_dictionary(1:end/(dynamic_flag+1),:),1,2);
    source_Cov = diag(var(source_dictionary,1,2));
    target_Cov = diag(var(target_dictionary,1,2));
    % get f0 mean & var
    source_f0_dictionary = source_f0_dictionary(find(source_f0_dictionary>10));
    f0_source_mean = mean(source_f0_dictionary);
    f0_source_var = var(source_f0_dictionary);
    target_f0_dictionary = target_f0_dictionary(find(target_f0_dictionary>10));
    f0_target_mean = mean(target_f0_dictionary);
    f0_target_var = var(target_f0_dictionary);    
    % save 
    save(dictionary_file,'f0_source_mean','f0_source_var', ...
                                    'f0_target_mean','f0_target_var', ...
                                    'source_GV','source_Cov', ...
                                    'target_GV','target_Cov',...
                                    '-append');
end