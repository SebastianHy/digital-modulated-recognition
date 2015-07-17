% test_16QAM_64QAM

% step 1
close all;
clear all;

% initialize
snr = 0:100;
signal_type = {'16QAM', '64QAM'};
% signal_type = { '8PSK', '64PSK'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
rate = zeros(200);
type = '';
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 0;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
Tx.data_num = 400;

ra =0.25;


% step 3
% 
figure(1); hold on; grid on;
for i = 1 : n
    for j = snr(1) : snr(end)
        type = signal_type(i);
        type = type{1};
        signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, Tx.data_num);
        c = subclust(abs(signal'), ra);
        rate(1,j-snr(1)+1) = length(c);
    end
    plot(snr(1):snr(end), rate(1, 1:length(snr)), [color(i), '-', symbol(i)]);
    
end
xlabel('����� snr dB');
% axis([snr(1) snr(end) -0.1 1.4]);
ylabel('f1 f2');
legend(signal_type);


