function feat = FeatureExtract(channel, selector)

counter = 0;
featureNum = 0;

%% ʱ������
% MAV-mean of absolute value-ƽ��ֵ
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = mean(channel)/10;
end

% STD-standard deviation-��׼��
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = std(channel)/10;
end

% VAR-variance - ����
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = var(channel)/10;
end

% TE-TimeEnergy-ʱ������
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = energy(channel, 1)/10;
end

% RMS-root mean square-������
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = rms(channel)/10;
end

% IQR-interquartile-range-�ķ�λ��
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = IQR(channel')/10;
end

% Skewness-ƫ��
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = skewness(channel)/10;
end

% Kurtosis-���
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = kurtosis(channel)/10;
end

% CM-central moments-���ľ�
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = moment(channel, 3)/10;
end

% MAD-mean absolute deviation-ƽ���������
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = mad(channel, 0)/10;
end

% MAD-median absolute deviation-��λ���Բ�
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = mad(channel, 1)/10;
end

% EN-entropy - ������
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = entropy(channel)/10;
end

%% Ƶ������
FFT = abs(fft(channel,256)/100);
FFT_ = FFT(1:128);
FFT_(1)=[];
% FFE-first frequency energy-��һƵ��λ��
counter = counter + 1;
[~, position] = max(FFT_);
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = position;
end

% MFV-max frequency value-���Ƶ������ֵ
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = max(FFT_);
end

% MDF-median frequency-��ֵƵ��
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = 100*median(FFT_);
end

% MPF-mean power frequency-ƽ������Ƶ��
counter = counter + 1;
if (selector(counter))
    featureNum = featureNum + 1;
    feat(featureNum) = 10*mean(FFT_);
end

feat = normalize(feat);
return

function E = energy(A,dim)
% get the energy of vector A
% E: return value
% A: input vector
MAE = 0.95;
if dim ==1
    [L,M] = size(A);
    E = zeros(1,M);
elseif dim ==2
    [M,L] = size(A);
    E = zeros(M,1);
end

for j = 1:M
    if dim ==1
        A_ = A(:,j);
    elseif dim ==2
        A_ = A(j,:);
    end
    DATA_P = zeros(1, L);
    DATA_A = zeros(1, L-1);
    DATA_P(1) = A_(1);
    for i = 2:L
        DATA_P(i) = DATA_P(i-1) * MAE + A_(i) * (1 - MAE);
        DATA_A(i-1) = abs(A_(i) - DATA_P(i));
    end
    E(j) = mean(DATA_A);
end

function I = IQR(A)

M = size(A,1);
I = zeros(M,1);
for i = 1:M
    A_ = A(i,:);
    I(i) = iqr(A_');
end

function S = entropy(A)
% get the entropy of vector A
% S: return value
% A: input vector
S = 0;
MAX = max(A)+0.01;
MIN = min(A);
SliceNum = 20;
SliceVal = (MAX - MIN) / SliceNum;
RC = zeros(1,SliceNum);
for i = 1:size(A,2)
    sub = floor((A(i) - MIN) / SliceVal) + 1;
    RC(sub) = RC(sub)+1;
end

RC = RC/SliceNum;

for i = 1:SliceNum
    if RC(i)>0
        S = S - RC(i)*log(RC(i));
    end
end