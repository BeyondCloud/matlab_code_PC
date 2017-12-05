function y = unit_amp(x,amp)
    if size(x,1)<size(x,2)
        x = x';
    end
    N = size(x,1);
    [env_up,env_down] = envelope(x,600,'peak');
    y = zeros(N,1);
    for i = 1:N
        if(x(i)>0)
            y(i) = x(i)*(amp/env_up(i));
        else
            y(i) = -x(i)*(amp/env_down(i));
        end
    end
end