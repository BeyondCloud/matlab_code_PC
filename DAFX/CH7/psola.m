function out=psola(in,m,alpha,beta)
%     in    input signal
%     m     pitch marks
%     alpha time stretching factor
%     beta  pitch shifting factor

P = diff(m);   %compute pitch periods

if m(1)<=P(1), %remove first pitch mark
   m=m(2:length(m)); 
   P=P(2:length(P)); 
end

if m(length(m))+P(length(P))>length(in) %remove last pitch mark
    m=m(1:length(m)-1);
    else
    P=[P P(length(P))]; 
end

Lout=ceil(length(in)*alpha);   
out=zeros(1,Lout); %output signal

tk = P(1)+1;       %output pitch mark

while round(tk)<Lout
  [minimum i] = min( abs(alpha*m - tk) ); %find analysis segment
  pit=P(i); 
  gr = in(m(i)-pit:m(i)+pit) .* hanning(2*pit+1);
  iniGr=round(tk)-pit;      
  endGr=round(tk)+pit;
  if endGr>Lout, break; end
  out(iniGr:endGr) = out(iniGr:endGr)+gr; %overlap new segment
  tk=tk+pit/beta;
end %while