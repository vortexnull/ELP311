%%
% Modulating frequency (fixing fm for the case when Wm is constant)
fm=1000;

% Frequency sensitivity (fixing kf for the case when delW is constant)
kf = 5000; 

% Carrier frequency
fc=10000;

% Sampling frequency
fs=10*fc;

% Time vector
t=0:1/fs:(0.002-1/fs);	

% Amplitude of modulating signal
Am=2.5;

beta = [0.01, 1, 2.4, 10, 50];

% %% Case 1: When Wm is constant, delW is varying
% % using fundamental frequency for kf calculation
% kfvar = 2*pi*fm*beta/Am;
% 
% %msg = Am * sin(2*pi*fm*t);
% %msg = Am * square(2*pi*fm*t);
% msg = Am * sawtooth(2*pi*fm*t, 1/2);
% 
% % Message Signal and FM signals
% figure(1);
% subplot(6,1,1);
% plot(t,msg);
% title("Message Signal: triangular wave");
% 
% for  i = 1:length(kfvar)
%    
%     cmsg = cumsum(msg)/fs;
%     FM = sin(2*pi*fc*t + kfvar(i)*cmsg);
%     
%     subplot(6,1,i+1);
%     plot(t,FM);
%     title(sprintf('beta = %d', beta(i)));
% end
% 
% % Frequency Spectrum of above signals
% figure(2);
% subplot(6,1,1);
% plot(fftshift(abs(fft(msg))));
% title("Frequency Spectrum of Message Signal");
% 
% for  i = 1:length(kfvar)
%    
%     cmsg = cumsum(msg)/fs;
%     FM = sin(2*pi*fc*t + kfvar(i)*cmsg);
%     
%     subplot(6,1,i+1);
%     plot(fftshift(abs(fft(FM))));
%     title(sprintf('beta = %d', beta(i)));
% end

%% Case 2: When delW is constant, Wm is varying
Wmvar = (kf * Am)./beta;

% FM signals
figure(3);

for  i = 1:length(Wmvar)
   
    msg = Am * sin(Wmvar(i)*t);
    cmsg = cumsum(msg)/fs;
    FM = sin(2*pi*fc*t + kf*cmsg);
    
    subplot(5,1,i);
    plot(t,FM);
    title(sprintf('beta = %d', beta(i)));
end

% Frequency Spectrum of above signals
figure(4);
subplot(5,1,1);

for  i = 1:length(Wmvar)
   
    msg = Am * sin(Wmvar(i)*t);
    cmsg = cumsum(msg)/fs;
    FM = sin(2*pi*fc*t + kf*cmsg);
    
    subplot(5,1,i);
    plot(fftshift(abs(fft(FM))));
    title(sprintf('beta = %d', beta(i)));
end

