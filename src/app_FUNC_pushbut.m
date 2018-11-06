function [] = app_FUNC_pushbut(app)

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
    Nhist = app.totalhistogarm.Value;
    Ntot = Nemap + Neprofile + Npmap + Nhist;
    Nreal = 0;
    N_wb = [Nemap,Neprofile,Npmap,Nhist,Nreal,Ntot];
    prc = N_wb(end-1)/N_wb(end);
    %--------------
    if run == 1
        try
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
            wb = waitbar(0,'Preparing the data...','Name','Please wait...',...
                'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
            pause(.5)
            setappdata(wb,'canceling',0);
%% -------------------------------------------------------------------------------   Make erosion map         
            if app.totalmap.Value > 0
                app_FUNC_waitbar(wb,Nreal,char("Erosion Maps... " + string(round(prc*100,1)) + " %"));
                app_FUNC_MapMaker1(app,InputData,plt_type,plt_at,plt_xt,ppath,wb,N_wb);
            else
                app_FUNC_waitbar(wb,0,char("Erosion Maps... " + string(round(prc*100,1)) + " %"));
            end
            N_wb(end-1) = Nemap;
            prc = N_wb(end-1)/N_wb(end);
%% -------------------------------------------------------------------------------    Make erosion profile
            if app.totalprofile.Value > 0
                app_FUNC_waitbar(wb,prc,char("Erosion Profile... " + string(round(prc*100,1)) + " %"));
                app_FUNC_ProfileMaker1(app,InputData,ppath,wb,N_wb);
            else
                app_FUNC_waitbar(wb,prc,char("No Erosion Profile... " + string(round(prc*100,1)) + " %"));
            end
            N_wb(end-1) = Nemap+Neprofile;
            prc = N_wb(end-1)/N_wb(end);
%% -------------------------------------------------------------------------------    Make precipitation map
            if app.totalprecipitation.Value > 0
                app_FUNC_waitbar(wb,prc,char("Precipitation Maps... " + string(round(prc*100,1)) + " %"));
                app_FUNC_PrecipitationMapMaker(app,precHOW,prec,difprec,plt_xt,ppath,wb,N_wb);
            else
                app_FUNC_waitbar(wb,prc,char("No Precipitation Maps... " + string(round(prc*100,1)) + " %"));
            end
            N_wb(end-1) = Nemap+Neprofile+Npmap;
            prc = N_wb(end-1)/N_wb(end);
%% -------------------------------------------------------------------------------    Make plot histogram
        if app.totalhistogarm.Value > 0
            app_FUNC_waitbar(wb,prc,char("Plot histograms... " + string(round(prc*100,1)) + " %"));
            app_FUNC_hist(app,ppath,wb,N_wb)
        else
            app_FUNC_waitbar(wb,prc,char("No Histogram plots... " + string(round(prc*100,1)) + " %"));
        end
%% -------------------------------------------------------------------------------    
            app_FUNC_waitbar(wb,prc,char("All Done :) " + string(round(prc*100,1)) + " %"));
            delete(wb);
            if app.SAVECheckBox.Value == 1
                %--------------
                msgbxTXT = sprintf("Operation Completed\nCheck the path below to find your saved figures:\n%s",ppath);
                msgbox(char(msgbxTXT),'modal');
            else
                uiwait(msgbox('Operation Completed','Operation completed','modal'));
            end
        catch
            if exist('wb')
                delete(wb)
            end
        end
    end
end