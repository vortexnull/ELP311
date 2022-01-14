clc;
close all;
clear variables;
%% Parameters
m = input("Enter value of modulation index(m): ");

% message signal parameters

Am = 5;% in Volts
fa = 3000; %Hertz
Ta = 1/fa;
t = 0:Ta/999:6*Ta; %Total simulation time

% Carrier signal parameters
Ac = Am/m;
fc = 1e5;
Tc = 1/fc;

%% Modulating signal plot
ym = Am*sin(2*pi*fa*t);   %Modulating signal eqn
subplot(5, 1, 1);
plot(t, ym); grid on;
title('  Modulating Signal  ');
xlabel('  time(sec)  ')
ylabel('  Amplitude(Volts)  ')

%% carrier signal plot
yc = Ac*sin(2*pi*fc*t);   %Carrier signal eqn
subplot(5, 1, 2)
plot(t, yc); grid on;
title('  Carrier Signal  ');
xlabel('  time(sec)  ')
ylabel('  Amplitude(Volts)  ')

%% Modulated signal plot
y = Ac*(1+m*sin(2*pi*fa*t)).*sin(2*pi*fc*t);
subplot(5, 1, 3)
plot(t, y); grid on;
title('  Amplitude Modulated Signal  ');
xlabel('  time(sec)  ')
ylabel('  Amplitude(Volts)  ')

%% trapezoid plot
subplot(5,1,4)
plot(ym, y); grid on;
title('  Trapezoid plot  ');
xlabel('  Modulating signal  ');
ylabel('  Modulated signal  ');

%% Demodulation
envelope = abs(hilbert(y)); %This gets the envelope of signal
subplot(5,1,5)
plot(t, envelope, 'r'); grid on;
title('  AM demodulated signal  ');
xlabel('  time(sec)  ');
ylabel('  Amplitude(Volts)  ');