% debug
Tx.SampleRate = 32e9; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = 0;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = 0;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0

ra = 0.04;
delta = 0.1;

signal1 = generate_signal('2FSK', 50, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, 400);
% [cn c] = sub_clust(signal1, ra, delta);
subplot(121)
% plot(signal1, '.'); hold on; plot(c, 'r*');
plot(psd(signal1));


signal2 = generate_signal('4FSK', 50, Tx.SampleRate, Tx.Linewidth, Tx.Carrier, 400);
% [cn c] = sub_clust(signal2, ra, delta);
subplot(122)
% plot(signal2, '.'); hold on; plot(c, 'r*');
plot(psd(signal2));




