% the main script

% step 1
clear all;
% clc;
close all;

% step 2
% ��ʼ������
times = 200; % �����������
snr = 0:100; % ����ȷ�Χ
% signal_type = {'16QAM', '64QAM'};
signal_type = {'BPSK', 'QPSK', '8PSK', '8QAM', '16QAM', '64QAM'};
color = 'bgrcmykb'; % ��ͼ��ɫ
symbol = 'o*sdph+x'; % ��ͼ����
n = length(signal_type); 
rate = zeros(1,200);
type = '';
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 10000;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
Tx.data_num = 400; % ���ݵ����

% step 3
% ʶ���ж�
figure; hold on; grid on;
for i = 1 : n
    disp(signal_type(i));
    for j = snr(1) : snr(end)
        correct = 0;
        for k = 1 : times
            type = signal_type(i);
            type = type{1};
            signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, Tx.data_num);
            rtype = recognize(signal);
           
            if judge(type, rtype)
                correct = correct + 1;
            else
%                 if strcmpi(type, '16qam')
%                     disp(rtype);
%                     disp(length(subclust(abs(signal'), 0.15)));
%                 end
            end
        end
        rate(j-snr(1)+1) = correct / times * 100;
    end
    plot(snr(1):snr(end), rate(1:length(snr)), [color(i), '-', symbol(i)]);
    
end
axis([snr(1) snr(end) 0 100]);
xlabel('����� snr dB');
ylabel('ʶ����ȷ�� % ');
legend(signal_type);


