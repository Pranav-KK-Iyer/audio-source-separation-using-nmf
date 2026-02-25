function a=invmyspectrogram(b,hop)
[nfft,nframes]=size(b);
No2=nfft/2;
a=zeros(1,nfft+(nframes-1)*hop);
xoff=0-No2;
for col=1:nframes
    fftframe=b(:,col);
    xzp=ifft(fftframe);
    x=[xzp(nfft-No2+1:nfft);xzp(1:No2)];
    if xoff<0
        ix=1:xoff+nfft;
        a(ix)=a(ix)+x(1-xoff:nfft)';
    else
        ix=xoff+1:xoff+nfft;
        a(ix)=a(ix)+x';
    end
    xoff=xoff+hop;
end
end
