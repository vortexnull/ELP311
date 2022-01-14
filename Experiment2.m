%% DSB-SC
fc=1e6;   % Carrier frequency
fm=10;   % Message frequency
fs=4 * 1e6;
t=0:1/fs:1;

m=input("Enter m: ");
Am=1;   % Amplitude of message signal
Ac=Am/m;   % Amplitude of carrier signal

message=Am.*sin(2*pi*fm*t);
carrier=Ac.*sin(2*pi*fc*t);
DSB_SC=carrier.*message;

%% plotting signals
figure(1)
subplot(311)
plot(t, message)
xlabel('Time (in sec)')
ylabel(' Message signal Amplitude')
title('Message signal')
subplot(312)
plot(t, carrier)
xlabel('Time (in sec)')
ylabel('Carrier signal Amplitude')
title('Carrier signal')
subplot(313)
plot(t, DSB_SC)
xlabel('Time (in sec)')
ylabel('DSB-SC signal Amplitude')
title('DSB-SC signal')

%% FFT of carrier
lc=length(carrier);
f=linspace(-fs/2,fs/2,lc);
carrierf=fft(carrier,lc);
carrierF=fftshift(carrierf);
carrierM=abs(carrierF)/lc;
figure(2)
subplot(311);
plot(f,carrierM);
xlabel('frequency(Hz)');
ylabel('Carrier Magnitude');
xlim([-1.5e6,1.5e6]);

%% FFT of message signal
lm=length(message);
f=linspace(-fs/2,fs/2,lm);
messagef=fft(message,lm);
messageF=fftshift(messagef);
messageM=abs(messageF)/lm;
subplot(312);
plot(f,messageM);
xlabel('frequency(Hz)');
ylabel('Message Magnitude');

%% FFT of DSB-SC signal
ld=length(DSB_SC);
f=linspace(-fs/2,fs/2,ld);
DSB_SCf=fft(DSB_SC,ld);
DSB_SCF=fftshift(DSB_SCf);
DSB_SCM=abs(DSB_SCF)/ld;
subplot(313);
plot(f,DSB_SCM);
xlabel('frequency(Hz)');
ylabel('DSB-SC Magnitude');
xlim([-1.5e6,1.5e6]);

%% Demodulation
Dem_signal=DSB_SC.*carrier;
figure(3)
plot(t,Dem_signal)
xlabel('Time (in sec)')
ylabel('Demodulated signal Amplitude')
title('Demodulated signal')

Wp = 15/500;
Ws = 150/500;
[n,Wn] = buttord(Wp,Ws,0.1,5);
[a,b] = butter(n,Wn);

Rec_signal=filter(a,b,Dem_signal);
figure(4)
plot(t,Rec_signal);
xlabel('Time (in sec)')
ylabel('Recieved signal Amplitude')
title('Recieved signal from LPF');

