% test_data_num

% step 1
clear all;
close all;


% step 2
% initialize
times = 200; % �����������
snr = 0:35;
signal_type = {'64QAM'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
rate = zeros(200);
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 0;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0

data_num = [50 100 200 500];



% step 3
% ʶ���ж�
figure; hold on; grid on;
for i = 1 : n
    disp(signal_type(i));
    for j = snr(1) : snr(end)
        
        for t = 1 : length(data_num)
            correct = 0;
            for k = 1 : times
                type = signal_type(i);
                type = type{1};
                signal = generate_signal(type, j, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, data_num(t));
                rtype = recognize(signal);

                if judge(type, rtype)
                    correct = correct + 1;
                end
            end
            rate(t, j-snr(1)+1) = correct / times * 100;
        end
    end
    for t = 1 : length(data_num)
    plot(snr(1):snr(end), rate(t,1:length(snr)), [color(t), '-', symbol(t)]);
    end
    
end
axis([snr(1) snr(end) 0 100]);
xlabel('����� snr dB');
ylabel('ʶ����ȷ�� % ');
legend('50', '100', '200', '500');

