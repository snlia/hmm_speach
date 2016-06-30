%-------全局变量设定------
global theWs; % 单词数量
global theNs; % 学号数量
global theMs; % 采样数
global theWords; %单词集
global theNames; %学号集
%导入模型集
%start sound file 北京 背景 start stop
record ();
%数字  语音   信号   分析   识别  北京  背景   上海   商行   复旦
%Speech  Voice  Sound  Happy  Lucky  File  Open  Close  Start  Stop
load ('caomao.mat');
[y, fs] = audioread ('tmp.wav');
y=y.';
[stp, edp, val] = vad (y, fs);
disp (val);
sound (y(stp:edp));
%pause ();
init ();
p = zeros (1, theWs);
for i = (1 : theWs)
    p(i) = calcHmm (hmm (i).x, y, fs);
end

disp (p);
disp (theWords (find (max (p) == p)));
