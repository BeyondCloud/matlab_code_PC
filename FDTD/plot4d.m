
KK = getK();
z = find(KK==0);
KK(z) = NaN;
z = find(KK==6);
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

%view Cross-section
% hold on; [X Z] = meshgrid(0:52,0:204);surf(X,X,Z);

%view Longitudinal -section
% hold on; [X Y] = meshgrid(0:52,0:52);F = 25*ones(size(X));surf(X,Y,F);
