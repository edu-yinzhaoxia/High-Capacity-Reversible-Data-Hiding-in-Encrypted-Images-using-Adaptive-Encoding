f0 = 2;
N = 400;
fs = 100;
Ts = 1/fs;
a = 0.95;
x = (sin (2*pi*f0*(0:N-1)*Ts))+0.2*randn(1,N);
y = zeros(1,N);
y(1) = x(1);
for n = 2:N
    y(n) = a*y(n-1)+x(n);
end
figure(1);
subplot(211);
plot(x)
xlabel('time/s');
subplot(212);
plot(y)
xlabel('time/s');