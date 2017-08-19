function r = newtonForm(x,y)
    if size(x,2) ~= size(y,2)
        error('error:size x != size y');
    end
    coeff = [];
    tmp_y = y;
    while 1
        coeff(end+1) = tmp_y(1);
        if size(coeff,2) == size(y,2)
            break;
        end
        for i = 1:size(y,2)-size(coeff,2)
            tmp_y(i) = (tmp_y(i)-tmp_y(i+1))/(x(i)-x(i+size(coeff,2)));
        end
    end
    r = coeff;
end