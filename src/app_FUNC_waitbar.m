function [] = app_FUNC_waitbar(wb,val,txt)
    if getappdata(wb,'canceling')
        button = questdlg('Cancel the process?','Exit Dialog','Yes','No','No');
        pause('on');
        switch button
            case 'Yes'
                pause('on');
                uiwait(msgbox('Operation terminated','modal'));
                delete(wb)
                error('Process stopped by the user')
            case 'No'
                pause('on');
                setappdata(wb,'canceling',0);
        end
    end
    waitbar(val,wb,txt);
end