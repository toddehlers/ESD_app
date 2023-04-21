function [] = app_FUNC_pushbut(app)
%------------------------------------------------------------------------
%This function is responsibe for the RUN buttun, all the procedure after
%pushing the RUN happends here:
% what need to be plotted and how is decided here

%++++++++++++++++
% This function is used in:
    %1-app designer main script

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    %1-app_FUNC_questionbox
    %2-app_FUNC_waitbar
    %3-app_FUNC_MapMaker1
    %4-app_FUNC_ProfileMaker1
    %5-app_FUNC_PrecipitationMapMaker
    %6-app_FUNC_TemperatureMapMaker
    %7-app_FUNC_hist
%------------------------------------------------------------------------
    InputData = app.InputData ;
    plt_type = app.plt_type ;
    plt_at = app.plt_at ;
    precHOW =  app.precHOW;
    prec =  app.prec;
    difprec =  app.difprec;
    plt_xt = app.plt_xt ;

    %--------------
    [run] = app_FUNC_questionbox(app);
    h =  findobj('type','figure');
    n = length(h);
    if n > 0 && run == 1
        ansr = questdlg('Close all the open figures ?','Close figures?','Yes','No','No');
        % Handle response
        switch ansr
            case 'Yes'
                close all
            case 'No'
        end
    end
    %--------------
    Nemap = app.totalmap.Value;
    Neprofile = app.totalprofile.Value;
    Npmap = app.totalprecipitation.Value;
    Ntmap = app.totaltemperature.Value;
    Nhist = app.totalhistogarm.Value;
    app.Ntot = Nemap + Neprofile + Npmap + Ntmap + Nhist;
    app.Nreal = 0;
    prc = app.Nreal/app.Ntot;
    app.loadingbar.Value = prc;
    %--------------
    if run == 1
        try
            app.LampRUN.Enable = 'on';
            app.LampSTOP.Enable = 'off';
            ppath = [];
            if app.SAVECheckBox.Value == 1
                while true
                    ppath = uigetdir;
                    if ppath == 0
                        error('No save path');
                    else
                        break
                    end
                end
            else
                ppath = [];
            end
%% -------------------------------------------------------------------------------   Make erosion map
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            if app.totalmap.Value > 0
                app.loadinglabel.Text = "Erosion Map...";
                pause(0.1);
                app_FUNC_MapMaker1(app,InputData,plt_type,plt_at,plt_xt,ppath);
            else
                app.loadingbar.Value = prc;
                app.loadinglabel.Text = "No Erosion Map...";
                pause(0.1);
            end
%% -------------------------------------------------------------------------------    Make erosion profile
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            if app.totalprofile.Value > 0
                app.loadinglabel.Text = "Erosion Profile...";
                pause(0.5)
                app_FUNC_ProfileMaker1(app,InputData,ppath);
            else
                app.loadinglabel.Text = "No Erosion Profile...";
                pause(0.1);
            end
%% -------------------------------------------------------------------------------    Make precipitation map
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            if app.totalprecipitation.Value > 0
                app.loadinglabel.Text = "Precipitation Map...";
                pause(0.1);
                app_FUNC_PrecipitationMapMaker(app,precHOW,prec,difprec,plt_xt,ppath);
            else
                app.loadinglabel.Text = "No Precipitation Map...";
                pause(0.1);
            end
%% -------------------------------------------------------------------------------    Make temperature map
            if app.user_cancel == 1
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            if app.totaltemperature.Value > 0
                app.loadinglabel.Text = "Temperature Map...";
                pause(0.1);
                app_FUNC_TemperatureMapMaker(app,precHOW,prec,difprec,plt_xt,ppath);
            else
                app.loadinglabel.Text = "No Temperature Map...";
                pause(0.1);
            end
%% -------------------------------------------------------------------------------    Make plot histogram
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            if app.totalhistogarm.Value > 0
                app.loadinglabel.Text = "Histogram...";
                pause(0.1);
                app_FUNC_hist(app,ppath)
            else
                app.loadinglabel.Text = "No Histogram...";
                pause(0.1);
            end
%% -------------------------------------------------------------------------------
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            app.loadinglabel.Text = "All done :-)";
            pause(0.1);
            if app.SAVECheckBox.Value == 1
                %--------------
                msgbxTXT = sprintf("Operation Completed\nCheck the path below to find your saved figures:\n%s",ppath);
                msgbox(char(msgbxTXT),'modal');
            else
                uiwait(msgbox('Operation Completed','Operation completed','modal'));
            end
        catch ME
            app.LampRUN.Enable = 'off';
            app.LampSTOP.Enable = 'on';
            app.loadinglabel.Text = "Error!!! Something went wrong";
            pause(0.1);
            uiwait(msgbox(ME.message,'Matlab Error','modal'));
            rethrow(ME)
        end
    end
end