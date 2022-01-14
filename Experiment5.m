%% AWGN analysis
mu = 0;
sd = 1;

% samples of N(0, 1)
samples = mu+sd*randn(1, 50);

r = (mu-10*sd)/sd:0.1/sd:(mu+10*sd)/sd;
% pdf of the normal distribution with mean mu and standard deviation sd, evaluated at the values in x
y = normpdf(r, mu, sd);
[ys, xs] = ksdensity(samples, r); 
figure (1)
subplot(1, 2, 1)
plot(r, y);
title('analytical pdf of standard normal distribution');

subplot(1, 2, 2)
plot(xs, ys);
title('pdf of standard normal distribution using 50 samples');

% simulated pdf of n^2, n ~ N(0, 1)
t = 0:0.1/sd:(mu+10*sd)/sd;
n = mu+sd*randn(1, 1e6);
m = n.^2;
[f1, t] = ksdensity(m, t);

% analytical pdf of n^2, n ~ N(0, 1)
f2 = exp(-t/2)./sqrt(2*pi.*t);

figure (2)
subplot(1, 2, 1)
plot(f1, t);
title('simuated pdf of m = n^2, n ~ N(0, 1)');

subplot(1, 2, 2)
plot(f2, t);
title('analytical pdf of m = n^2, n ~ N(0, 1)');

%% Parameter Definition
Eb = 1;
snrdb = 0:1:10;
snrlen = length(snrdb);

snr = 10.^(snrdb/10);
sd = sqrt(Eb./snr);
amp = sqrt(Eb);

len = 10^6;
s0 = binornd(1, 0.5, len, 1);
s = repmat(s0, 1, snrlen);

n = randn(len, 1)*sd;

%% BER Analysis for BPSK
x1 = (2*s-1)*amp;

y1 = x1+n;

w1 = double(y1 > 0);
t1 = abs(w1-s);
ber_simulated1 = sum(t1)/len;

ber_analytical1 = qfunc(sqrt(snr));

figure (3)
semilogy(snrdb, ber_analytical1, 'b');
title('Analytical and Simulated Bit Error Rate for BPSK Modulation');
xlabel('SNR in dB');
ylabel('BER');

hold on
semilogy(snrdb, ber_simulated1, 'og');
legend('Analytical', 'Simulated');
hold off

P1 = y1(:, 1).^2;
[p1, k1] = ksdensity(P1);

figure (4)
plot(k1, p1);
title('simulated pdf of received power (BPSK)');
xlabel('Power');
ylabel('pdf');

%% BER analysis for ASK
x2 = s*amp;

y2 = x2+n;

w2 = double(y2 > amp/2);
t2 = abs(w2-s);
ber_simulated2 = sum(t2)/len;

ber_analytical2 = qfunc(sqrt(snr./4));

figure (5)
semilogy(snrdb, ber_analytical2, 'b');
title('Analytical and Simulated Bit Error Rate for ASK Modulation');
xlabel('SNR in dB');
ylabel('BER');

hold on
semilogy(snrdb, ber_simulated2, 'og');
legend('Analytical', 'Simulated');
hold off

P2 = y2(:, 1).^2;
[p2, k2] = ksdensity(P2);

figure (6)
plot(k2, p2);
title('simulated pdf of received power (ASK)');
xlabel('Power');
ylabel('pdf');

%% BER analysis for FSK
ber_analytical3 = qfunc(sqrt(snr/2)); 

f0 = 1; 
f1 = 2; 
t0 = 8;  
  
t = 0 : (1 / t0) : 0.99; 
t1 = kron(ones(1, len), t); 
  
s0 = binornd(1, 0.5, 1, len); 
f = f1 * s0 + (1 - s0) * f0; 
ft = kron(f, ones(1, t0)); 
x = sqrt(2 / t0) * cos(2 * pi * ft.*t1); 
  
n = (randn(1, len * t0) + 1i * randn(1, len * t0)) / sqrt(2); 
  
ref0 = sqrt(2 / t0) * cos(2 * pi * f0 * t); 
ref1 = sqrt(2 / t0) * cos(2 * pi * f1 * t); 
  
ber0 = zeros(1, snrlen); 
yi = zeros(1, len * t0); 
  
for k = 1 : snrlen 
   y = x + sd(k).*n; 
    
   if(k == 1) 
       yi = y; 
   end 
    
   y0 = conv(y, ref0);  
   y1 = conv(y, ref1);   
    
   r = double(real(y0((t0 + 1) : t0 : end)) < real(y1((t0 + 1) : t0 : end))); 
   ber0(k) = sum(abs(s0 - r)); 
end 
  
ber_simulated3 = ber0 / len;

figure (7)
semilogy(snrdb, ber_analytical3, 'b');
title('Analytical and Simulated Bit Error Rate for FSK Modulation');
xlabel('SNR in dB');
ylabel('BER');

hold on
semilogy(snrdb, ber_simulated3, 'og');
legend('Analytical', 'Simulated');
hold off

P3 = abs(yi).^2;
[p3, k3] = ksdensity(P3);

figure (8)
plot(k3, p3);
title('simulated pdf of received power (FSK)');
xlabel('Power');
ylabel('pdf');

%% comparision of different schemes

figure (9)
semilogy(snrdb, ber_analytical1);
xlabel('SNR in dB');
ylabel('BER');
hold on
semilogy(snrdb, ber_analytical2);
semilogy(snrdb, ber_analytical3);
legend('BPSK', 'ASK', 'FSK');
hold off