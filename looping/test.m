t = 0:1/1000:3;
q1 = sin(2*pi*7*t).*exp(-t/2);
q2 = chirp(t,30,2,5).*exp(-(2*t-3).^2)+2;
q = [q1;q2]';
plot(t,q);
[up,lo]  = envelope(q,300);
hold on
plot(t,up,'-',t,lo,'--')
hold off