% ����ƽ̨��Mac OSX��MATLAB R2014b
% ¼��¼2����
function [] = record ()
    Time = 2;

    FS = 8000;
    nBits = 16;
    recObj = audiorecorder(FS, nBits, 1);
    disp('Start speaking.')
    recordblocking(recObj, Time);
    disp('End of Recording.');

    myRecording = getaudiodata(recObj);

    filename = 'tmp.wav';
    audiowrite(filename, myRecording, FS)
