%vad (Voice Activity Detection) 起/终点判断函数
%输入一个时域采样信息y与采样频率fs，返回发音部分的起点startp与终点endp，以及这个语音的权重。
function [startp, endp, value] = vad (y, fs)

%将数值映射到[-1, 1], 方便参数设定

y = double (y);
y = y / max(abs(y));

%设定参数

framelen = fs * 0.02; % 桢长，20ms
frameinc = framelen * 0.5; % 桢移，桢长一半

%幅度归一化到[-1,1]

y = double(y);
max_y = max(abs(y));
y = y / max_y;

%计算短时过零率szcr (short-time zero crossing rate)

theTmp = enframe_muti (y(1:end - 1), ones (1, framelen), framelen, frameinc);
theTmpp = enframe_muti (y(2:end), ones (1, framelen), framelen, frameinc);
theTmppp = abs (theTmp - theTmpp);
theEsp = max (max (theTmppp(1, :)), max (theTmppp(size (theTmppp, 1), :))) * 0.66;
szcr = sum ((theTmp.*theTmpp < 0) .* (theTmppp > theEsp), 2); %过零且两点值相差大于theEsp

%计算短时幅度 sm(short-term magnitude)

sm = sum (abs (theTmp.*theTmp), 2);

%设定幅度上下门限,theMh, theMl, 之间判断为浊音段。

theMh = max (sm) / 4;
theMl = max (sm) / 16;

%设定过零率门限theZ0

theZ0 = max (szcr)*0.074;

%设定一些变量

theLen = length (szcr); %分出多少帧

%第一步，通过theMh判断浊音段

%figure, subplot(4,1,1);
%plot (sm);
%axis([1,length(sm),min(sm),max(sm)]);

for startp = (1:theLen)
    if (sm(startp) >= theMh) 
        break;
    end;
end;

for endp = (theLen:-1:1)
    if (sm(endp) >= theMh) 
        break;
    end;
end;

%line([startp,startp],[min(sm),theMh],'color','green');
%line([endp ,endp],[min(sm),theMh],'color','green');

%第二步，通过theMl向两边拓宽浊音段

for startp = (startp:-1:1)
    if (sm(startp) <= theMl) 
        break;
    end;
end;

for endp = (endp:theLen)
    if (sm(endp) <= theMl)
        break;
    end;
end;

%line([startp ,startp],[min(sm),theMl],'color','red');
%line([endp ,endp],[min(sm),theMl],'color','red');

%第三步，通过短时过零率判断前后轻音段

%subplot(4,1,2);
%plot (szcr);
%axis([1,length(szcr),min(szcr),max(szcr)]);

%for startp = (startp:-1:1)
%    if (szcr(startp) <= theZ0)
%        break;
%    end;
%end;

tmpedp = endp;
len = length (szcr);

for endp = (endp: len)
    if (szcr(endp) <= theZ0)
        break;
    end;
end;

%计算声音质量

%直接取到末尾，说明音质太差，排除
if (endp == len) 
    value = 0;
    return;
end

%计算连续过Z0数量
f = zeros (1, len + 1);
%计算连续过Z0能量
fm = zeros (1, len + 1);
%计算连续过Z0均量
fa = zeros (1, len + 1);
tmpedp2 = endp;
endp = endp + 1;
nowx = endp;
while (endp <= len)
    if (szcr (endp) > theZ0) 
        f (nowx) = f(nowx) + 1;
        fm (nowx) = fm(nowx) + szcr (endp) - theZ0;
        fa (nowx) = fm (nowx) / f (nowx);
    else
        nowx = endp + 1;
    end
    endp = endp + 1;
end

idx = find (max (f) == f, 1);
if ((idx - tmpedp2 > 0) && (idx - tmpedp2 < 5)) 
    endp = idx + f(idx) - 1;
else
    endp = tmpedp2;
end
if (endp >= len) 
    %第二波直接触底，说明音质很差
    value = 1;
else
    %先看有多少时间是在theZ0上
    if (sum (f (endp + 1 : len)) / (len - tmpedp2) > 0.8) value = 1; 
    else
        if (sum (f (endp + 1 : len)) / (len - tmpedp2) < 0.3) value = 5;
        else
            if (max (fa (endp + 1 : len)) > 2.5 * theZ0) value = 1;
            else
                value = 5 - 4 * max (fa (endp + 1 : len)) / (2.5 * theZ0); %0是5分，3.5theZ0是1分
            end
        end
    end
end

endp = tmpedp;
for endp = (endp: min (len, endp + 10 * value))
    if (szcr(endp) <= theZ0)
        break;
    end;
end;

if (value > 1.5) 
    %计算连续过Z0数量
    f = zeros (1, len + 1);
    tmpedp2 = endp;
    endp = endp + 1;
    nowx = endp;
    while (endp <= len)
        if (szcr (endp) > theZ0) 
            f (nowx) = f(nowx) + 1;
        else
            nowx = endp + 1;
        end
        endp = endp + 1;
    end

    idx = find (max (f) == f, 1);
    if ((idx - tmpedp2 > 0) && (idx - tmpedp2 < 5)) 
        endp = idx + f(idx) - 1;
    else
        endp = tmpedp2;
    end
end

%line([startp ,startp],[min(szcr),max(szcr)],'color','red');
%line([endp,endp],[min(szcr),max(szcr)],'color','red');
%line([1, length(szcr)],[theZ0,theZ0],'color','yellow');

startp = (frameinc - 1) * startp;
endp = (frameinc - 1) * endp + framelen;
