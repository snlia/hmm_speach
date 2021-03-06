%mfcc (Mel-frequency cepstrum)
%输入一个时域采样信息y以及采样频率fs，返回mfcc得到的特征向量。

function ccc = mfcc (y, fs)

%设定mfcc相关系数
Ms = 16; %mel滤波器组数
frameLen = 128;%fs * 0.02; %桢长，20ms
frameInc = frameLen * 0.5; % 桢移，桢长一半

%生成mel滤波器组
[mels, mn, mx] = melbankm(Ms,frameLen,fs);

%加窗并分桢
yy = enframe_muti (y, Hamming (frameLen), frameLen, frameInc);
res = [];
%mfcc计算
for i = (1:size (yy, 1))
    nowy = yy (i, : );
    Nowy = fft (nowy); %傅里叶变换得到频域特征
    Nowy = abs (Nowy).^2; %转为能量谱
    Nowy = Nowy';
    Nowy = mels * Nowy(1 : size (mels, 2));
    Nowy = log (Nowy); %求对数
    nowy = dct (Nowy); %进行离散余弦变换
    res (i, :) = nowy';
end

dtm = zeros (size (res));
for i= (3 : size(res, 1) - 2)
  dtm(i, :) = - 2 * res (i - 2, :) - res (i - 1, :) + res (i + 1, :) + 2 * res (i + 2, :);
end
dtm = dtm / 3;

ccc = [res dtm];
ccc = ccc (3 : size (res, 1) - 2, :);
