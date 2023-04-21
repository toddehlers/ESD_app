function [] = app_FUNC_waitbar(wb,val,txt)
%------------------------------------------------------------------------
% It generates and update the waitbar during the processes

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_pushbut
    %2-app_FUNC_MapMaker1
    %3-app_FUNC_ProfileMaker1
    %4-app_FUNC_PrecipitationMapMaker
    %5-app_FUNC_TemperatureMapMaker
    %6-app_FUNC_hist

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
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