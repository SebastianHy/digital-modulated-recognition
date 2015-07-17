% test_phase

% step 1
clear all;
close all;


% step 2
% initialize
times = 200; % �����������
snr = 10;
signal_type = {'64QAM'};
color = 'bgrcmykb';
symbol = 'o*sdph+x';
n = length(signal_type);
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 0;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
Tx.data_num = 400; % ���ݵ����

Linewidth = 0:1:90;



% step 3
% ʶ���ж�
figure; hold on; grid on;
for i = 1 : n
    disp(signal_type(i));

        
        for t = 1 : length(Linewidth)
            correct = 0;
            for k = 1 : times
                type = signal_type(i);
                type = type{1};
                signal = generate_signal(type, snr, Tx.SampleRate, Linewidth(t), Tx.Carrier, Tx.data_num);
                rtype = recognize(signal);

                if judge(type, rtype)
                    correct = correct + 1;
                end
            end
            rate(t) = correct / times * 100;
        end
  
    plot(Linewidth, rate);
  
    
end
axis([Linewidth(1) Linewidth(end) 0 100]);
xlabel('��λ��');
ylabel('ʶ����ȷ�� % ');
legend(signal_type);

