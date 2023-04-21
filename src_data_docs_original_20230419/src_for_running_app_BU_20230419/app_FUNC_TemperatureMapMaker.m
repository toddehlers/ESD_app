function [] = app_FUNC_TemperatureMapMaker(app,precHOW,prec,difprec,plt_xt,ppath)
%------------------------------------------------------------------------
% This function orgonize and make the things reday to plot temperature
% maps and difference temperature maps

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_pushbut

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    %1-app_FUNC_tempMapMakerTemp
    %2-app_FUNC_waitbar
    %3-app_FUNC_tempMapMakerDif
%------------------------------------------------------------------------
    if sum(prec == 1) > 0
        TPind = find(prec == 1);
        if precHOW(1) == 1 % all temperature maps in one figure
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            app.loadinglabel.Text = "Plotting...  (temperature map)";
            pause(0.1);
            app_FUNC_tempMapMakerTemp(app,TPind,plt_xt,ppath);
            app.loadinglabel.Text = "Done :-)";
            app.Nreal = app.Nreal +1;
            prc = app.Nreal/app.Ntot;
            app.loadingbar.Value = prc*100;
            pause(0.1);
        end
        if precHOW(2) == 1 % each temperature map in an individual figure
            for i = 1:length(TPind)
                if app.user_cancel == 1
                    app.loadinglabel.FontColor = [1.00 0.00 0.00];
                    app.loadinglabel.Text = "Operation stopped";
                    pause(0.1);
                    return
                end
                app.loadinglabel.Text = "Plotting...  (temperature map)";
                pause(0.1);
                app_FUNC_tempMapMakerTemp(app,TPind(i),plt_xt,ppath);
                app.loadinglabel.Text = "Done :-)";
                app.Nreal = app.Nreal +1;
                prc = app.Nreal/app.Ntot;
                app.loadingbar.Value = prc*100;
                pause(0.1);
            end
        end
    end
%-------------------------------------
    if sum(difprec == 1) > 0
        TPind = find(difprec == 1);
        if precHOW(1) == 1 % all temperature difference maps in one figure
            if app.user_cancel == 1
                app.loadinglabel.FontColor = [1.00 0.00 0.00];
                app.loadinglabel.Text = "Operation stopped";
                pause(0.1);
                return
            end
            app.loadinglabel.Text = "Plotting...  (temperature difference map)";
            pause(0.1);
            app_FUNC_tempMapMakerDif(app,TPind,plt_xt,ppath);
            app.loadinglabel.Text = "Done :-)";
            app.Nreal = app.Nreal +1;
            prc = app.Nreal/app.Ntot;
            app.loadingbar.Value = prc*100;
            pause(0.1);
        end
        if precHOW(2) == 1 % each temperature difference map in an individual figure
            for j = 1:length(TPind)
                if app.user_cancel == 1
                    app.loadinglabel.FontColor = [1.00 0.00 0.00];
                    app.loadinglabel.Text = "Operation stopped";
                    pause(0.1);
                    return
                end
                app.loadinglabel.Text = "Plotting...  (temperature difference map)";
                pause(0.1);
                app_FUNC_tempMapMakerDif(app,TPind(j),plt_xt,ppath);
                app.loadinglabel.Text = "Done :-)";
                app.Nreal = app.Nreal +1;
                prc = app.Nreal/app.Ntot;
                app.loadingbar.Value = prc*100;
                pause(0.1);
            end
        end
    end
end
