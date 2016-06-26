%mfcc (Mel-frequency cepstrum)
%输入一个时域采样信息y以及采样频率fs，返回mfcc得到的特征向量。

function res = mfcc (y, fs)

%设定mfcc相关系数

Ms = 16; %mel滤波器组数
frameLen = fs * 0.02; %桢长，20ms
frameInc = frameLen * 0.5; % 桢移，桢长一半

%生成mel滤波器组
[melbanks, mn, mx] = melbankm(Ms,frameLen,fs);

%加窗并分桢
yy = enframe_muti (y, Hamming (frameLen), frameLen, frameInc);

for i = (1:size (yy, 1))
    nowy = yy (i, : );
    Nowy = fft (nowy); %傅里叶变换得到频域特征
    Nowy = abs (Nowy).^2; %转为能量谱
    Nowy = mels * (Nowy'(1:size (mels, 2))); %换成mel谱
    Nowy = log (Nowy); %求对数
    nowy = dct (Nowy); %进行离散余弦变换
    res (i:) = nowy'

