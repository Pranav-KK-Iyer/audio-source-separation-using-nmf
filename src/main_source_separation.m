% Blind Audio Source Separation using STFT and NMF
% Author: Pranav KK Iyer
% Description:
% Performs time-frequency analysis, NMF-based decomposition,
% and reconstruction of bass, drum, and guitar.

clear all;
close all;
clc

[x fs]=audioread('Drum+Bass.wav');
%x==s;
%%STFT
FFTSIZE=1024;
HOPSIZE=256;
WINDOWSIZE=512;

X = myspectrogram(x,FFTSIZE,fs,hann(WINDOWSIZE),-HOPSIZE);
V=abs(X(1:(FFTSIZE/2+1),:));%Non-negative
F=size(V,1);
T=size(V,2);

%sound(x,fs)
%%NMF

K=3;%number of basis vectors
MAXITER=100;%total number of iterations to run

%%TODO:NMF

[W,H] = nmf(V,K,MAXITER);

%%ISTFT/RECONSTRUCTION METHOD 1(SYSNTHESIS)

%get the mixture phase

phi=angle(X);
for i=1:K
    XmagHat=W(:,i)*H(i,:);
    %create upper half of frequency before istft
    XmagHat=[XmagHat;conj(XmagHat(end-1:-1:2,:))];
    %Multiply with phase
    Xhat=XmagHat.*exp(1i*phi);
    xhat1(:,i)=real(invmyspectrogram(Xhat,HOPSIZE));
end

%sound(xhat1(:,1),fs)
%sound(xhat1(:,2),fs)
%sound(xhat1(:,3),fs)
%%ISTFT/RECONSTRUCTION METHOD2(FILTERING)
%get the mixture phase
phi=angle(X)

for i=1:K
    %create masking filture
    Mask=(W(:,i)*H(i,:)./(W*H));
    %filter
    XmagHat=V.*Mask;
    %create upper half of frequency before istft
    XmagHat=[XmagHat;conj(XmagHat(end-1:-1:2,:))];
    %Multiply with phase
    XhAT=XmagHat.*exp(1i*phi);
    %create upper half of frequency before istft
    xhat2(:,i)=real(invmyspectrogram(XmagHat.*exp(1i*phi),HOPSIZE));
end

%soundsc(x,fs)
%soundsc(xhat1(:,1),fs)
%soundsc(xhat1(:,2),fs)
soundsc(xhat1(:,3),fs)




