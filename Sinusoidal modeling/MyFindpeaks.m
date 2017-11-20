% Quadratic interpolation for sinusoidal analysis
% Revised Nov 2010, Yi-Wen Liu
% Last updated March 2017
%
% EE6641: Analysis and synthesis of audio signals
% National Tsing Hua University
% 
% This function looks at FFT spectrum X, finds up to MAXNUMPEAKS 
% **highest** peaks and returns a list of amplitudes (dB-scale) AMPS and 
% peak locations FREQS in the order of ascending frequency.

function [amps,freqs]=MyFindpeaks(X, maxNumPeaks)

N=size(X(:),1);
data = 20*log10(abs(X));
data=data(:);
ind=find( (data>[data(1)-100;data((1:N-1)')]) ...
    & (data>=[data((2:N)'); data(N)-100]) );   %find the location of peaks
peaks=zeros(maxNumPeaks,2);
peaks_happen=[data(ind),ind];
peaks_low2high=sortrows(peaks_happen,1);
i=length(ind);
if ~isempty(ind),
%for j=1:maxNumPeaks
    
for j=1:min([maxNumPeaks i]) % Bug fixed by YWL 2014-4-10
        k=peaks_low2high(i+1-j,2);%...maxpeaks location 
        L0=peaks_low2high(i+1-j,1);
        if L0==data(N)
            A=(L0-2*data(k-1)+data(k-2))/2;
            B=A*(1-2*k)+L0-data(k-1);
        elseif L0==data(1)
            A=(data(k+2)-2*data(k+1)+L0)/2;
            B=(data(k+1)-L0)-(1+2*k)*A;
        else
            A=(data(k-1)+data(k+1)-2*L0)/2;
            B=(data(k-1)-data(k+1)-4*A*k)/2;
        end
        C=L0-A*k^2-B*k;
        q=(-B)/(2*A);
        L_est=C-(B^2)/(4*A);
        peaks(j,1)=L_est;
        peaks(j,2)=q;
        
end
end

%% Return the list of amps and freqs in the order of ascending frequency
peaks = sortrows(peaks,2);	
	% sorting in ascending frequency
amps = peaks(:,1);
freqs= peaks(:,2);


