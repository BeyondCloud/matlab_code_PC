function K = getK(roomDimsD)
    img = imread('tube.bmp');
    rs = zeros([size(img,2),1]);
    for i = 1:size(img,2)
        rs(i) = sum(0==img(:,i));
    end

    K = zeros(roomDimsD);
    mid = 25;
    for i = 1:size(K,3)
        [x y] = getmidpointcircle(mid,mid,rs(i));

        for j = 1:size(x,1)
           if y(j) > mid 
               K(x(j),mid:(y(j)-1),i) = 6;
           else
               K(x(j),(y(j)+1):mid,i) = 6;    
           end
        end
        for j = 1:size(x,1)
            K(x(j),y(j),i) = 5;  
        end
    end
end