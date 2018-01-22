function [f0,t]=yin_f0(x,p)
% default parameter values ([]: to be determined)
minf0 = 100;			% Hz - minimum frequency
maxf0 = 500;			% Hz - maximum frequency
wsize = []; 		% s - integration window size
lpf = [];			% Hz - lowpass prefiltering cutoff
thresh = 0.1;		% difference function threshold
relflag = 1;		% if true threshold is relative to global min of difference function
bufsize=10000;		% computation buffer size
hop = 32;			% samples - interval between estimates
range=[];			% range of file samples to process
sr=[];				% sampling rate
shift=0;			% flag to control the temporal shift of analysis windows (left/sym/right)
plotthreshold=0.2;	% aperiodicity above which plot is green or yellow



% handle parameters
if nargin<1; help yin; return; end
if nargin<2; p=[]; end
fileinfo=sf_info(x); if ~isempty(fileinfo.sr) p.sr=fileinfo.sr;	end % get sr from file
if fileinfo.nchans > 1
	disp(['warning: using column 1 of ', num2str(fileinfo.nchans), '-column data']); 
end
if isa(p, 'double') p.sr=p; end
if ~isfield(p, 'sr'); p.sr=sr; end
if isempty(p.sr); error('YIN: must specify SR'); end
if ~isfield(p, 'range') | isempty(p.range); p.range=[1 fileinfo.nsamples]; end
if ~isfield(p, 'minf0'); p.minf0=minf0; end
if ~isfield(p, 'thresh'); p.thresh=thresh; end
if ~isfield(p, 'relflag'); p.relflag=relflag; end
if ~isfield(p, 'bufsize'); p.bufsize=bufsize; end
if ~isfield(p, 'hop'); p.hop=hop; end
if ~isfield(p, 'maxf0'); p.maxf0=floor(p.sr/4); end % default
if ~isfield(p, 'wsize'); p.wsize=ceil(p.sr/p.minf0); end % default
if ~isfield(p, 'lpf'); p.lpf=p.sr/4; end % default
if mod(p.hop,1); error('hop should be integer'); end
if ~isfield(p, 'shift'); p.shift=shift; end % default
if ~isfield(p, 'plotthreshold'); p.plotthreshold=plotthreshold; end % default

% estimate period
r=yink(p,fileinfo);
prd=r.r1; % period in samples

%log2 to make them linear scale
%f0 = log2(p.sr ./ prd) - log2(440); 	% convert to octaves ref: 440 Hz
f0 = p.sr ./ prd; %show freq
t = find(~isnan(f0))*p.hop;
% f0 = f0(~isnan(f0));
fprintf('mean:%2f\n',mean(f0));
