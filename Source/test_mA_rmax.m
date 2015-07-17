% test_mA_rmax

function test_mA_rmax()

% step 1
clear all;
close all;


% step 2
% initialize
snr = 0:100;
signal_type = {'BPSK', 'QPSK', '8PSK', '8QAM', '16QAM', '64QAM'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
rate = zeros(200);
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 0;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
Tx.data_num = 400;

figure(1);
 hold on; grid on;
figure(2);
 hold on; grid on;
for i = 1 : n
    for j = snr(1) : snr(end)
        type = signal_type(i);
        type = type{1};
        signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, Tx.data_num);
        rate(1,j-snr(1)+1) = cal_mA(signal);
        rate(2,j-snr(1)+1) = cal_rmax(signal);
    end
    figure(1);
    plot(snr(1):snr(end), rate(1, 1:length(snr)), [color(i), '-', symbol(i)]);
    figure(2);
     plot(snr(1):snr(end), rate(2, 1:length(snr)), [color(i), '-', symbol(i)]);
    
end

figure(1);
xlabel('����� snr dB');
ylabel('mA');
axis([snr(1) snr(end) -0.01 0.3]);
legend(signal_type);
figure(2);
xlabel('����� snr dB');
ylabel('rmax');
% axis([snr(1) snr(end) -0.01 2]);
legend(signal_type);


end

% mA�������ڷ�ӳ�źŰ���ı仯�̶ȡ�
function mA = cal_mA(signal)
    a = abs(signal);
    u = mean(a);
    v = var(a);
    mA = v / (u*u);
end

% �����Ĺ�һ��˲ʱ����֮���ܶȵ����ֵ�������Ĺ�һ��˲ʱ����֮���ܶȵ����ֵ��~
function rmax = cal_rmax(signal)
a = abs(signal);
ma = mean(a);
an = a ./ ma;
acn = an - 1;
m = max(abs(fft(acn)));
rmax = m^2 / length(signal);
end
