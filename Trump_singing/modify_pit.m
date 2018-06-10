% Assume x's pitch is normalized already

function final = modify_pit(x,scale_rate_tbl,Fs)
    if length(x) ~=  length(scale_rate_tbl)
        error('length(x) ~=  length(f_tbl)');
    end
    x_len = length(x);
    
    f_tbl_cum = cumsum(scale_rate_tbl);
    stretch_ratio = f_tbl_cum(end)/(x_len-1);

    %%%stretching input x
    x_str = wsolaTSM(x,stretch_ratio);
    yy = zeros(size(x));
    yy(1) = x_str(1);
    yy(2:end) = spline(1:length(x_str),x_str,f_tbl_cum(2:end));

    % formant preservation
    clear parameter
    parameter.anaHop = 512;
    parameter.win = win(2048,1); % sin window
    parameter.filterLength = 60;
    final = modifySpectralEnvelope(yy,x,parameter);
%     final = yy;
end