%参数设定

function [ignore] = init

ignore = [];

global theNs; % 学号数量
theNs = 3; 
global theWs; %单词数量
theWs = 10;
global theMs; % 采样数
theMs = 20; 

global theWords; %单词集
theWords = cell (1,theWs); 
theWords = {'Close', 'File', 'Happy', 'Lucky', 'Open', 'Sound', 'Speech', 'Start', 'Stop', 'Voice'};

global theNames; %学号集
theNames = cell (1,theNs); 
theNames = {'14307130166', '13307130444', '13307130230'};
%theNames = {'11307120032', '12307130178', '13300160096', '13307130174', '13307130230', '13307130251', '13307130290', '13307130299', '13307130309', '13307130444', '14307130090', '14307130092', '14307130153', '14307130166', '14307130222',  '14307130345', '14307130381'}

global theStates; %每个单词的状态数
theStates = [8, 8, 8, 8, 8, 8, 8, 8, 8, 8];
