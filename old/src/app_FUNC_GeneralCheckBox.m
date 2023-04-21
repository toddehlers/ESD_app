function [] = app_FUNC_GeneralCheckBox(app)
    %-------------- get the values from all the possible parameters
    app_Func_getcheckboxvalue(app);
    %--------------find data
    app_FUNC_DataFinder(app); % find the input data as app.InputData
    %--------------enable disable 
    app_FUNC_checkboxes(app);
end