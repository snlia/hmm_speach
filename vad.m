%起/终点判断函数
%输入一个时域采样信息y与采样频率fs，返回发音部分的起点与终点。
function [startp, endp] = vad (y, fs)

%设定参数
framlen = fs / 100; % 10ms
framinc = framlen * 0.5; % 桢长一半

%幅度归一化到[-1,1]
y = double(y);
max_y = max(abs(y));
y = y / max_y;

