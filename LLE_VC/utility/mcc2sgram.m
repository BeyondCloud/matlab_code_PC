function Sgram = mcc2sgram(mcc,fftDIM,Fs)
[Dm,Nm]=size(mcc);
fftLength=(fftDIM-1)*2;
F=0:Fs/(fftLength-1):Fs;
Sgram=zeros(fftDIM,Nm);
for i=1:Nm
    fft=mgc2sp(mcc(:,i),F,Fs,'<mel-scale>');
    Sgram(:,i)=fft(1:fftDIM,1);
end