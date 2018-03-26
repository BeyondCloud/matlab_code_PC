function [ sp, ap, f0] = STRAIGHTvocoder(x, fs, gender)
    addpath('E:\Matlab_code\LLE_VC\STRAIGHT\STRAIGHT\STRAIGHTV40_006b');
    if size(x,2) > size(x,1)
        x = x';
    end

    %STEP: parameter initialize
    frame_length=25; % STRAIGHT analysis, synthesis set up. 25msec.
    frame_shift = 5;
    prmP.defaultFrameLength=frame_length;
    prmP.spectralUpdateInterval=frame_shift;
    
    if gender == 'M'% Male
        prm.F0searchLowerBound = 30; % f0floor
        prm.F0searchUpperBound = 200; % f0ceil
    elseif  gender == 'F'% Female
        prm.F0searchLowerBound = 60; % f0floor
        prm.F0searchUpperBound = 400; % f0ceil
    else
        prm.F0searchLowerBound = 30; % f0floor
        prm.F0searchUpperBound = 400; % f0ceil
    end
    prm.F0defaultWindowLength=25; 
    prm.F0frameUpdateInterval=1;  
    
    f0 = MulticueF0v14(x,fs,prm);
    %STEP: down sample
    f0=downsample(f0,5);
    prm.F0defaultWindowLength=frame_length; 
    prm.F0frameUpdateInterval=frame_shift;  
    %STEP: extract AP
    ap = exstraightAPind(x,fs,f0,prm);
    %STEP: extract FFT
    sp = exstraightspec(x,f0,fs,prmP);    

end