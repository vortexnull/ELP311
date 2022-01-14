close all;
startplot = 1;
endplot = 5000;

fs = 10000;   % Sample frequency 
N = 5000;     % Number of samples 

Ts = 1/fs; 
t = (0:Ts:N*Ts-Ts);

fm = 100;       % Refernce frequency 
phi_ref = pi/6; % Refernce phase
phi_los = phi_ref + pi/4;

ref = sin(2*pi*fm*t + phi_ref); % refernce signal
los = sin(2*pi*fm*t + phi_los); % local oscillator signal

figure(1);
subplot(5,1,1);
plot(t(startplot:endplot), ref(startplot:endplot), t(startplot:endplot), los(startplot:endplot));
title('Reference Signal and Local Oscillator Signal');
xlabel('Time (seconds)');
legend('Reference', 'Local Oscillator');
grid;

product = ref .* los; % product of ref and los

subplot(5,1,2);
plot(t(startplot:endplot), product(startplot:endplot));
title('Product of Refernce and Local Oscillator signal');
xlabel('Time (seconds)');
grid;

lm = length(product);
f = linspace(-fs/2,fs/2,lm);
fourier = fft(product,lm);
fft_product = abs(fftshift(fourier))/lm;    % fft of product

subplot(5,1,3);
plot(f,fft_product)
title('FFT of product signal');
xlabel('f (Hz)');
grid;

% butterworth filter
Wp = 2*20/fs;
Ws = 2*50/fs;
[n,Wn] = buttord(Wp,Ws,0.1,5);
[a,b] = butter(n,Wn);

filtered_signal = filter(a, b, product);    % passing product signal through low pass Butterworth filter

subplot(5,1,4);
plot(t(startplot:endplot), filtered_signal(startplot:endplot));
title('Filtered product signal');
xlabel('Time (seconds)');
grid;

phi = 0:pi/180:pi;
DCvalues = zeros(1, 180);

for i = 1:length(phi)
    los = sin(2*pi*fm*t + phi_ref + phi(i));
    product = ref .* los;
    
    DCvalues(i) = mean(product);
end

subplot(5,1,5);
plot(phi, DCvalues);
title('DC value v/s Phase offset');
grid;

figure (2)
freqz(a, b);
title('Response of lowpass filter');

kp = 0.3;
phi1 = 83 * pi/180;
count = 0;

while(1)
    los = sin(2*pi*fm*t + phi1);
    product = ref .* los;
    
    DC = mean(product);
    phi1 = phi1 +  kp*(DC-0.5);
    count = count + 1;
    
    if or((rem(count, 200) == 0), (count == 10))
        figure;
        plot(t(startplot:endplot/5), ref(startplot:endplot/5), t(startplot:endplot/5), los(startplot:endplot/5));
        hold on 
        title(sprintf("convergence after %d iterations", count));
        xlabel('Time (seconds)');
        legend('Reference', 'Local Oscillator');
        grid;
    end
    
    if abs(DC-0.5) < 1e-4
        break
    end
end

figure;
plot(t(startplot:endplot/5), ref(startplot:endplot/5), t(startplot:endplot/5), los(startplot:endplot/5));
hold on 
title(sprintf("Final convergence after %d iterations", count));
xlabel('Time (seconds)');
legend('Reference', 'Local Oscillator');
grid; 

