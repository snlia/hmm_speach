%enframe 加窗函数
%enframe输入一个原始数据y，窗口函数，返回加窗后的数据x。

function x = enframe (y, win)

len = length (y);
for i = (1 : len)
    x(i) = y(i) * win(i);
end
