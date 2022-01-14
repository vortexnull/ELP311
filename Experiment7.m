close all;
startplot = 1;
endplot = 500;

fc = 1000;   % Carrier frequency
fm = 250;    % Modulating frequency 
fs = 10000; % Sample frequency 
N = 5000;    % Number of samples 

Ts = 1/fs; 
t = (0:Ts:N*Ts-Ts);

Am = 1;
Ac = 1;

message = Am.*sin(2*pi*fm*t); 
carrier = Ac.*sin(2*pi*fc*t);

figure (1);
subplot(4,1,1);
plot(t(startplot:endplot), message(startplot:endplot));
title('Message Signal');
xlabel('Time (seconds)');
grid;

figure (1);
subplot(4,1,2);
plot(t(startplot:endplot), carrier(startplot:endplot));
title('Carrier Signal');
xlabel('Time (seconds)');
grid;

dsbsc = message.*carrier;
ssbsc = bandpass(dsbsc, [fc-fm fc], fs);

figure (1);
subplot(4,1,3);
plot(t(startplot:endplot), dsbsc(startplot:endplot));
title('DSBSC Signal');
xlabel('Time (seconds)');
grid;

figure (1);
subplot(4,1,4);
plot(t(startplot:endplot), ssbsc(startplot:endplot));
title('SSBSC - Lower Band');
xlabel('Time (seconds)');
grid;

lm = length(message);
f = linspace(-fs/2,fs/2,lm);
msg_fourier = abs(fftshift(fft(message,lm)))/lm;

figure (2);
subplot(4,1,1);
plot(f,msg_fourier)
title('FFT of Message Signal');
xlabel('f (Hz)');
grid;

lm = length(carrier);
f = linspace(-fs/2,fs/2,lm);
carrier_fourier = abs(fftshift(fft(carrier,lm)))/lm;

figure (2);
subplot(4,1,2);
plot(f,carrier_fourier)
title('FFT of Carrier Signal');
xlabel('f (Hz)');
grid;

lm = length(dsbsc);
f = linspace(-fs/2,fs/2,lm);
dsbsc_fourier = abs(fftshift(fft(dsbsc,lm)))/lm;

figure (2);
subplot(4,1,3);
plot(f,dsbsc_fourier)
title('FFT of DSBSC');
xlabel('f (Hz)');
grid;

lm = length(ssbsc);
f = linspace(-fs/2,fs/2,lm);
ssbsc_fourier = abs(fftshift(fft(ssbsc,lm)))/lm;

figure(2);
subplot(4,1,4);
plot(f,ssbsc_fourier)
title('FFT of SSBSC - Lower Band');
xlabel('f (Hz)');
grid;

product = carrier.*ssbsc;
demodulated = lowpass(product, fm, fs);

figure (3);
subplot(4,1,1);
plot(t(startplot:endplot), product(startplot:endplot));
title('Product of Carrier and SSBSC');
xlabel('Time (seconds)');
grid;

lm = length(product);
f = linspace(-fs/2,fs/2,lm);
product_fourier = abs(fftshift(fft(product,lm)))/lm;

figure (3);
subplot(4,1,2);
plot(f,product_fourier)
title('FFT of Product');
xlabel('f (Hz)');
grid;

figure (3);
subplot(4,1,3);
plot(t(startplot:endplot), demodulated(startplot:endplot));
title('Demodulated Signal');
xlabel('Time (seconds)');
grid;

lm = length(demodulated);
f = linspace(-fs/2,fs/2,lm);
demodulated_fourier = abs(fftshift(fft(demodulated,lm)))/lm;

figure (3);
subplot(4,1,4);
plot(f,demodulated_fourier)
title('FFT of Demodulated Signal');
xlabel('f (Hz)');
grid;
