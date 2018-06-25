% x1y1------------ x2y1
% |                 |
% |                 |
% x1y2------------x2y2

function K = createWall2(K,x_1,x_2,y_1,y_2)
    %wall
    K(y_1:y_2,x_1:x_2,2:end-1)=0;            
    %four sides of wall
    K(y_1,x_1:x_2,2:end-1)=5;
    K(y_2,x_1:x_2,2:end-1)=5;
    K(y_1:y_2,x_2,2:end-1)=5;
    K(y_1:y_2,x_1,2:end-1)=5;
%     K(y_1,x_2,2:end-1)=6;
    K(y_2,x_2,2:end-1)=6;
    K(y_1,x_1,2:end-1)=6;
    K(y_2,x_1,2:end-1)=6;
end