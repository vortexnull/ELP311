close all;  

fc=1000;   % Carrier frequency  
fs=100000; % Sample frequency 
N=5000;    % Number of samples 

Ts=1/fs; 
t=(0:Ts:N*Ts-Ts); 

% Create the message signal 
fm=100;             % Modulating frequency 
msg=sin(2*pi*fm*t); 

kf=.0628;           %Modulation index 
 
% Create the real and imaginary parts of a CW modulated carrier to be tracked. 
modulated=exp(1i*(2*pi*fc*t+2*pi*kf*cumsum(msg)));  % Modulated carrier (better to write it as complex exponential) 
carrier=exp(1i*(2*pi*fc*t));                        % Unmodulated carrier  (better to write it as complex exponential) 

% Initilize PLL Loop  
phi_2(1)=50;  
e(1)=0;  
mul(1)=0;  
vco(1)=0;  

% Define Loop Filter parameters (Sets damping) 
kp=0.15;    % Proportional constant  
ki=0.1;     % Integrator constant  

 

% PLL implementation  

for n=2:length(modulated)  

    vco(n) = conj(exp(1i * ((2 * pi * n * fc / fs) + phi_2(n - 1)))); 
    mul(n) = imag(modulated(n) * vco(n)); 
    e(n) = e(n - 1) + (kp * mul(n)) + (ki * (mul(n) - mul(n - 1))); 
    phi_2(n) = phi_2(n - 1) + e(n);

end  

 

% Plot waveforms
startplot = 1;
endplot = 1000;

% message signal
figure(1);
subplot(6,1,1);
plot(t(startplot:endplot), msg(startplot:endplot));
title('Message Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

% carrier signal
figure(1);
subplot(6,1,2);
plot(t(startplot:endplot), real(carrier(startplot:endplot)));
title('Carrier Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

% FM signal
figure(1);
subplot(6,1,3);
plot(t(startplot:endplot), real(modulated(startplot:endplot)));
title('FM Signal');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

% VCO output
figure(1);
subplot(6,1,4);
plot(t(startplot:endplot), real(vco(startplot:endplot)));
title('VCO Output');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

% multiplier output
figure(1);
subplot(6,1,5);
plot(t(startplot:endplot), real(mul(startplot:endplot)));
title('Multiplier Output');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

% filter output
figure(1);
subplot(6,1,6);
plot(t(startplot:endplot), real(e(startplot:endplot)));
title('PLL Loop Filter Output');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid;

periodogram(x,rectwin(length(x)),length(x),fs) % denotes fs sampling frequency 