%加窗函数
%enframe_muti 提供桢长framelen以及桢移frameinc，返回一组加窗后的数据x

function x = enframe_muti (y, win, framelen, frameinc)

len = length (y);
theLen = ceil ((len - framelen + frameinc) / frameinc);
x = zeros (theLen, framelen); % creat the res matrix
y = [y zeros(1, framelen + (theLen - 1) * frameinc - len)]; % padding zeros
disp (y);
for i = (0 : theLen - 1)
    theStartIndex = i * frameinc + 1;
    disp (enframe (y(theStartIndex:theStartIndex + framelen - 1), win));
    x(i + 1,:) = enframe (y(theStartIndex:theStartIndex + framelen - 1), win)
end;


