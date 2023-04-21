function [] = app_FUNC_GeneralCheckBox(app)
%------------------------------------------------------------------------
% This is a function which calls some main functions of the app

%++++++++++++++++
% This function is used in:
    %1-app designer main script

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    %1-app_Func_getcheckboxvalue
    %2-app_FUNC_DataFinder
    %3-app_FUNC_checkboxes
%------------------------------------------------------------------------
    app.Cancel.Value = "";
    app.user_cancel = 0;
    app.loadingbar.Value = 0;
    app.loadinglabel.Text = "...";
    app.loadinglabel.FontColor = [0.00 1.00 0.00];
    app.LampRUN.Enable = 'off';
    app.LampSTOP.Enable = 'off';
    
    %-------------- get the values from all the possible parameters
    app_Func_getcheckboxvalue(app);
    %--------------find data
    app_FUNC_DataFinder(app); % find the input data as app.InputData
    %--------------enable disable 
    app_FUNC_checkboxes(app);
end