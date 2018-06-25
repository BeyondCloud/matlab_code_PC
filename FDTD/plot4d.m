z = find(K==0);
KK = K;
KK(z) = NaN;
z = find(K==6);
KK(z) = NaN;

[X,Y,Z] = ndgrid(1:size(KK,1), 1:size(KK,2), 1:size(KK,3));
pointsize = 30;
nonans = ~isnan(KK);
scatter3(X(nonans), Y(nonans), Z(nonans), pointsize, KK(nonans));
xlim([0 250])
ylim([0 250])
zlim([0 250])
% slice(KK, [], [], 1:10:size(KK,3));
% shading  interp  