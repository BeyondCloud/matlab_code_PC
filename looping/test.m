% t1 = 1/100:1/100:1;
% t2 = 1/200:1/200:1;
% q1 = sin(2*pi*t1)*0.5;
% q2 = sin(2*pi*t2)*0.5;
% 
% qt = [q1 zeros(1,100)];
% final = repmat(qt,1,441);
% target = repmat(q2,1,441);
% plot(q2)
% % sound(final,44100);
% sound(target,44100);
% 
% hold off
Y = zeros([35200,10]);
Y(:,1:10) = y_formantAdapted(1:end-80,1:10) ;
