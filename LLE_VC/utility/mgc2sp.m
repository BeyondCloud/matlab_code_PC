%  H = mgc2sp(CC,F,Fs,alpha)
%
%  sample a Mel-generalized-cepstrum spectral envelope
%
%  Input Arguments:
%    CC: [Px1] mel-generalized cepstral coefficients
%    F:  [Kx1] frequencies to sample (in Hz)
%    Fs: [1x1] sampling frequency (in Hz) (default = 16000)
%    alpha: frequency warping factor for the allpass delay element.
%           It can take two forms:
%           [string] either '<mel-scale>' or '<bark-scale>', according 
%              to the following table [Masuko Phd Thesis, November 2008]:
%              
%                 Fs         | 8 kHz  | 10 kHz  | 12 kHz  | 16 kHz  |
%                -----------------------------------------------------
%                 Mel  scale | 0.31   | 0.35    | 0.37    | 0.42    |
%                 Bark scale | 0.42   | 0.47    | 0.50    | 0.55    |
%               for intermediate values of Fs, the warping factor is
%               interpolated.
%           [1x1] the frequency warping factor
%           (default == '<mel-scale>');
%
%  Output Arguments:
%    H: [Kx1] amplitude spectrum 
%
function H = mgc2sp(CC,F,Fs,alpha)
if nargin<3, Fs = 16000; end
if nargin<4, alpha = '<mel-scale>'; end; 
if ischar(alpha)
  if length(findstr('<mel-scale>',alpha))>0
    alpha = interp1([ 0 8000 10000 12000 16000 48000 ],[ 0.31 0.31 0.35 0.37 0.42 0.42 ],Fs);
  elseif length(findstr('<bark-scale>',alpha))>0
    alpha = interp1([ 0 8000 10000 12000 16000 48000 ],[ 0.42 0.42 0.47 0.50 0.55 0.55 ],Fs);    
  else
    error(sprintf('alpha option (%s) can be either "<mel-scale>" or "<bark-scale>"',alpha));
  end
end
F = reshape(F,length(F),1);
omega = (2*pi/Fs)*F;
omega_ = atan2( ((1-alpha*alpha)*sin(omega)),( (1+alpha*alpha)*cos(omega)-2*alpha) );
%omega_ = omega;
% %[ H, W ] = freqz(CC,1,omega_);
% %H = exp(H);
N = length(F);
M = length(CC)-1;
H = cos(omega_*[0:M])*CC;
H = exp(H);