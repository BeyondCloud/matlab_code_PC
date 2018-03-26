function [source_parameter, spectrum_parameter] = worldvocoder(x, fs,gender)
    addpath('D:\NTHUWork\world-0.2.0_6_matlab');
    if size(x,2) > size(x,1)
        x = x';
    end
    if nargin < 3 
        gender = 'F';
    end
    
    if gender == 'M'% Male
        opt.f0_floor = 30;
        opt.f0_ceil = 200;
    else % Female
        opt.f0_floor = 60;
        opt.f0_ceil = 400;
    end
    opt.frame_period = 1;
    
    f0_parameter = Dio(x, fs, opt);
    f0_parameter.f0 = downsample(f0_parameter.f0,5);
    f0_parameter.temporal_positions = downsample(f0_parameter.temporal_positions,5);
    f0_parameter.vuv = (f0_parameter.f0 > 10);
    
    % StoneMask is an option for improving the F0 estimation performance.
    % You can skip this processing.
    f0_parameter.f0 = StoneMask(x, fs,...
      f0_parameter.temporal_positions, f0_parameter.f0);

    spectrum_parameter = CheapTrick(x, fs, f0_parameter);
    source_parameter = D4C(x, fs, f0_parameter);
end