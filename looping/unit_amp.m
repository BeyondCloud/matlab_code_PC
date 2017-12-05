function y = unit_amp(x,amp)
    if size(x,1)<size(x,2)
        x = x';
    end
    [env_up,env_down] = envelope(x,500,'peak');
    err = env_up-env_down;
    y = x.*(amp./err);
end