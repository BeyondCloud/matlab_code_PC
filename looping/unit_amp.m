function y = unit_amp(x,amp)
    x = x(3000:end-3000);
    xt = x';
    [env_up,env_down] = envelope(xt',500,'peak');
    err = env_up-env_down;
    y = x.*(0.3./err);
end