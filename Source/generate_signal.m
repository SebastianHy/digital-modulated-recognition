function signal = generate_signal(type, snr, sampleRate, lineWidth, carrier, data_n)
% ���������ź� �����ͣ�����ȣ���Ԫ���ʣ��߿��ز�Ƶ�ʣ����ݵ������

% step 1
% initialize
type = upper(type); % ��д
if length(type) == 4
    if strcmp(type(1), 'Q')
        n = 4;   
        style = type(2:4);
    elseif strcmp(type(1), 'B')
        n = 2;
        style = type(2:4);
    else
        n = str2double(type(1));
        style = type(2:4);
    end
elseif length(type) == 5
    n = str2double(type(1:2));
    style = type(3:5);
elseif length(type) == 6
    n = str2double(type(1:3));
    style = type(4:6);
else
    error('error input in generate_signal');
    return;
end

% step 2
% ���ò���
System.BitPerSymbol = log2(n); % ��Ԫλ

Tx.SampleRate = sampleRate; % symbol Rate���źŵ���Ԫ���ʣ��������ж���
Tx.Linewidth = lineWidth;% �����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
Tx.Carrier = carrier;% �����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
M = 2^System.BitPerSymbol;% ������

Tx.DataSymbol = randi([0 M-1],1,data_n);% 1*10000��0-M-1�������ÿһ�������������������������ʱ��Ϊ���ݵ����Ϊ10000��

% step 3
% ����
switch style
    case {'ASK'}


    case {'FSK'}
% fskmod����  ��ʽ��y=fskmod(x,M,freq_sep,nsamp) y=fskmod(x,M,freq_sep,nsamp,Fs)  ���У�x����Ϣ�źţ�M����Ϣ�ķ�������������2���������ݣ���Ϣ�ź���0��M-1֮���������freq_sep�����ز�Ƶ��֮���Ƶ�ʼ������λΪHz��nsamp������ź�y��ÿ���ŵĲ������������Ǵ���1����������Fs�ǲ���Ƶ�ʣ�freq_sep��M�������㣨M-1��*freq_sep<=Fs��
            Tx.DataConstel = fskmod(Tx.DataSymbol, M, 10, 8, Tx.SampleRate);
    case {'PSK'}
            h = modem.pskmod('M', M, 'SymbolOrder', 'Gray'); % ������
            Tx.DataConstel = modulate(h,Tx.DataSymbol); % ����
    case {'QAM'}
        if M ~= 8
            h = modem.qammod('M', M, 'SymbolOrder', 'Gray'); % ������
            Tx.DataConstel = modulate(h,Tx.DataSymbol); % ����
        else % �����2^3��8QAM������ʽ�����ó������ã���Ϊ��ʵ�����ŵ�����8QAM����ͼ
            tmp = Tx.DataSymbol;
            tmp2  = zeros(1,length(Tx.DataSymbol));
            for kk = 1:length(Tx.DataSymbol)
                switch tmp(kk)
                    case 0
                        tmp2(kk) = 1 + 1i;
                    case 1
                        tmp2(kk) = -1 + 1i;
                    case 2
                        tmp2(kk) = -1 - 1i;
                    case 3
                        tmp2(kk) = 1 - 1i;
                    case 4
                        tmp2(kk) = 1+sqrt(3);
                    case 5
                        tmp2(kk) = 0 + 1i .* (1+sqrt(3));
                    case 6
                        tmp2(kk) = 0 - 1i .* (1+sqrt(3));
                    case 7
                        tmp2(kk) = -1-sqrt(3);
                end
            end
            Tx.DataConstel = tmp2;
            clear tmp tmp2;
        end
    otherwise
        error('error in generate signal');
        return;
end

% step 4
% Ԥ����
Tx.Signal = Tx.DataConstel;

% ���ݵ��ز����أ����ǵ���λ������
N = length(Tx.Signal);
dt = 1/Tx.SampleRate; % ����������ڣ�
t = dt*(0:N-1);
Phase1 = [0, cumsum(normrnd(0,sqrt(2*pi*Tx.Linewidth/(Tx.SampleRate)), 1, N-1))]; % ��ֵ0 ��׼�� 1xN-1 ��˹��� ÿ���ۼӺ�
carrier1 = exp(1i*(2*pi*t*Tx.Carrier + Phase1));
Tx.Signal = Tx.Signal.*carrier1;

Rx.Signal = awgn(Tx.Signal,snr,'measured');% ���ض�����ȵ�������������AWGN�ŵ��µĽ��գ���measured����ʾ����������֮ǰ�ⶨ�ź�ǿ��

CMAOUT = Rx.Signal;

% normalization�����źŹ��ʹ�һ��
CMAOUT=CMAOUT/sqrt(mean(abs(CMAOUT).^2));

% step 5
% ����
% signal = Tx.Signal;
% signal = Rx.Signal;
signal = CMAOUT;

% plot(t, signal);

end