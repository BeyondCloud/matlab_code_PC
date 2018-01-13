function y = pitch_shift(x,fs,cents)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pitch-shifting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear parameter
parameter.fsAudio = fs;

%%%select time stretch algorithm
% parameter.algTSM = @twoStepTSM;
parameter.algTSM = @wsolaTSM;

y_resamp = pitchShiftViaTSM(x,cents,parameter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% formant adaption
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear parameter
parameter.anaHop = 512;
parameter.win = win(2048,1); % sin window
parameter.filterLength = 60;
y = modifySpectralEnvelope(y_resamp,x,parameter);

