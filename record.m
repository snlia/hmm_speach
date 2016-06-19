% --- Executes on button press in pushbutton_Recording.
function pushbutton_Recording_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Recording (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ChannelNo = 1;
Fs = 16000;
TimePeriod = 2;

handles.DataRecord = wavrecord(TimePeriod * Fs, Fs, ChannelNo);

handles.Fs16000 = Fs;

% Update handles structure
guidata(hObject, handles);
