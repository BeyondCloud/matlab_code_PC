function MCC = mgcep_ver1(Spectrum,mccDIM,alpha,Gamma)

    if nargin < 4
        Gamma = 0;
    end
    if nargin < 3
        alpha = 0.42;
    end
    if nargin < 2
        mccDIM = 39;
    end
    
    %restore the other side of spectrum by flip and concatenate
    Spectrum = [Spectrum;Spectrum(end-1:-1:2,:)];
    
    % generalized function
    if Gamma == 0
        g_X = log(Spectrum);
    else
        g_X = (Spectrum.^Gamma-1)/Gamma;
    end
    
    % Mel-scale cepstrum
    
    [nfft,nframe] = size(Spectrum);
    N = (0:nfft-1)'/(nfft-1);
    omega = (2*pi)*N;
    omega_ = atan2( ((1-alpha*alpha)*sin(omega)),( (1+alpha*alpha)*cos(omega)-2*alpha) );
    Z = cos(omega_*[0:mccDIM]);    
    G = (Z'*Z)\Z';
    MCC = G*g_X;
%     MCC = zeros(mccDIM+1,nframe);
%     for t = 1:nframe
%         MCC(:,t) = (Z'*Z)\Z'*g_X(:,t);
%     end
end