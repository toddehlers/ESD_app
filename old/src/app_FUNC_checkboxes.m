function app_FUNC_checkboxes(app)

    InputData = app.InputData; % the number of available data (from DataFinder function)
    vMT = app.vMT;
    vatG = app.vatG;
    vatRE_Ui = app.vatRE_Ui;
    vatRE_Peak = app.vatRE_Peak;
    vatCE_BAP = app.vatCE_BAP;
    vatCE_Ui = app.vatCE_Ui;
    vatCE_Peak = app.vatCE_Peak;
    vPP = app.vPP;
    vststPr = app.vststPr;
    precHOW = app.precHOW;
    prec = app.prec;
    difprec = app.difprec;
    pltHIST = app.pltHIST;
    RP = app.RP;

    n_data = size(InputData,1);
    app.N_map.Value = n_data;
    if n_data > 0
        app.LampGM.Enable = 'on';
        app.LampRM.Enable = 'off';
    else
        app.LampGM.Enable = 'off';
        app.LampRM.Enable = 'on';
    end
% -------------------------------------------------------------
    if n_data > 0
        FUNC_mapcategoryEN(app,'on')
        FUNC_plthistEN(app,'on')
%         FUNC_mapextraEN(app,'on')
        if sum(vMT) > 0
            FUNC_mapatEN(app,'on')
            if sum(vatCE_BAP) > 0
                FUNC_FUNC_mapatENce(app,'on')
            else
                FUNC_FUNC_mapatENce(app,'off')
                FUNC_FUNC_mapatVALce(app,0)
            end
        else
            FUNC_mapatEN(app,'off')
            FUNC_mapatVAL(app,0)
            FUNC_FUNC_mapatENce(app,'off')
            FUNC_FUNC_mapatVALce(app,0)
        end
    else
        FUNC_mapcategoryEN(app,'off')
        FUNC_mapcategoryVAL(app,0)
        FUNC_plthistEN(app,'off')
        FUNC_plthistVAL(app,0)
%         FUNC_mapextraEN(app,'off')
%         FUNC_mapextraVAL(app,0)
        FUNC_mapatEN(app,'off')
        FUNC_mapatVAL(app,0)
        FUNC_FUNC_mapatENce(app,'off')
        FUNC_FUNC_mapatVALce(app,0)
    end
    N_map = FUNC_MapCounter...
    (app,n_data,vMT,vatG,vatRE_Ui,vatRE_Peak,vatCE_BAP,vatCE_Ui,vatCE_Peak);
% -------------------------------------------------------------
    if n_data > 0
        FUNC_profilecategoryEN(app,'on')
        %---------------------------------
        if app.Statistic.Value == 1
            FUNC_profilestatEN(app,'on')
        else
            FUNC_profilestatEN(app,'off')
            FUNC_profilestatVAL(app,0)
        end
        %---------------------------------
        if app.randsample.Value == 1
            FUNC_profilesmplEN(app,'on')
        else
            FUNC_profilesmplEN(app,'off')
            FUNC_profilesmplVAL(app,1)
        end
        %---------------------------------
        if app.randall.Value == 1
            FUNC_profileallEN(app,'on')
        else
            FUNC_profileallEN(app,'off')
            FUNC_profileallVAL(app,1)
        end
        %---------------------------------
        if app.coordinate.Value == 1
            FUNC_profilecordEN(app,'on')
        else
            FUNC_profilecordEN(app,'off')
            FUNC_profilecordVAL(app,0)
        end
        %---------------------------------
    else
        FUNC_profilecategoryEN(app,'off')
        FUNC_profilecategoryVAL(app,0)
        FUNC_profilestatEN(app,'off')
        FUNC_profilestatVAL(app,0)
        FUNC_profilesmplEN(app,'off')
        FUNC_profilesmplVAL(app,1)
        FUNC_profileallEN(app,'off')
        FUNC_profileallVAL(app,1)
        FUNC_profilecordEN(app,'off')
        FUNC_profilecordVAL(app,0)
    end
    N_profile = FUNC_ProfileCounter(app,n_data,vPP,vststPr);
% -------------------------------------------------------------
    if sum(precHOW == 1) > 0
        FUNC_precEN(app,'on')
    else
        FUNC_precEN(app,'off')
        FUNC_precVAL(app,0)
    end
    N_precipitaion = FUNC_PrecipitationCounter(app,precHOW,prec,difprec);
% -------------------------------------------------------------
    if n_data > 0
        FUNC_plthistEN(app,'on')
    else
        FUNC_plthistEN(app,'off')
        FUNC_plthistVAL(app,0)
    end
    N_histogram = FUNC_histcounter(app,pltHIST,n_data);
% -------------------------------------------------------------
    if (N_map + N_profile + N_precipitaion + N_histogram) > 0
        if app.PLOTCheckBox.Value == 1
            app.RUN.Enable = 1;
        elseif (app.SAVECheckBox.Value == 1) && sum(RP(3:6)) > 0
                app.RUN.Enable = 1;
        else
            app.RUN.Enable = 0;
        end
%         FUNC_MenuEN(app,'on')
    else
        app.RUN.Enable = 0;
%         FUNC_MenuEN(app,'off')
    end
end



%% ----------------------------------------------------------
function [] = FUNC_mapcategoryEN(app,v)
    app.RT.Enable = v;
    app.RE.Enable = v;
    app.CE.Enable = v;
    app.RE_Ui.Enable = v;
    app.RE_Peak.Enable = v;
    app.CE_Ui.Enable = v;
    app.CE_Peak.Enable = v;
    app.KPT.Enable = v;
end
function [] = FUNC_mapcategoryVAL(app,val)
        app.RT.Value = val; % map type checkbox value
        app.RE.Value = val;
        app.CE.Value = val;
        app.RE_Ui.Value = val;
        app.RE_Peak.Value = val;
        app.CE_Ui.Value = val;
        app.CE_Peak.Value = val;
        app.KPT.Value = val;
end
%% ----------------------------------------------------------
function [] = FUNC_mapatEN(app,v)
    app.atPeakRE.Enable = v;
    app.atPeakCE.Enable = v;
    app.atTT.Enable = v;
    app.atEnd.Enable = v;

    app.atREUi50.Enable = v;
    app.atREUi40.Enable = v;
    app.atREUi30.Enable = v;
    app.atREUi20.Enable = v;
    app.atREUi10.Enable = v;
    app.atREPeak50.Enable = v;
    app.atREPeak40.Enable = v;
    app.atREPeak30.Enable = v;
    app.atREPeak20.Enable = v;
    app.atREPeak10.Enable = v;

    app.Bpeak.Enable = v;
    app.Apeak.Enable = v;
    vatCE_BAP(1) = app.Bpeak.Value; % @ Change in CE Befor Peak
    vatCE_BAP(2) = app.Apeak.Value; % @ Change in CE After Peak
end
function [] = FUNC_FUNC_mapatENce(app,v)
    app.atCEUi50.Enable = v;
    app.atCEUi40.Enable = v;
    app.atCEUi30.Enable = v;
    app.atCEUi20.Enable = v;
    app.atCEUi10.Enable = v;
    app.atCEPeak50.Enable = v;
    app.atCEPeak40.Enable = v;
    app.atCEPeak30.Enable = v;
    app.atCEPeak20.Enable = v;
    app.atCEPeak10.Enable = v;
end
function [] = FUNC_mapatVAL(app,val)
    app.atPeakRE.Value = val; % @ General
    app.atPeakCE.Value = val;
    app.atTT.Value = val;
    app.atEnd.Value = val;

    app.atREUi50.Value = val; % @ Change in RE(Ui)
    app.atREUi40.Value = val;
    app.atREUi30.Value = val;
    app.atREUi20.Value = val;
    app.atREUi10.Value = val;

    app.atREPeak50.Value = val; % @ Change in RE(Peak)
    app.atREPeak40.Value = val;
    app.atREPeak30.Value = val;
    app.atREPeak20.Value = val;
    app.atREPeak10.Value = val;

    app.Bpeak.Value = val;
    app.Apeak.Value = val;
    vatCE_BAP(1) = app.Bpeak.Value; % @ Change in CE Befor Peak
    vatCE_BAP(2) = app.Apeak.Value; % @ Change in CE After Peak
end
function [] = FUNC_FUNC_mapatVALce(app,val)
    app.atCEUi50.Value = val; % @ Change in CE(Ui)
    app.atCEUi40.Value = val;
    app.atCEUi30.Value = val;
    app.atCEUi20.Value = val;
    app.atCEUi10.Value = val;

    app.atCEPeak50.Value = val; % @ Change in CE(Peak)
    app.atCEPeak40.Value = val;
    app.atCEPeak30.Value = val;
    app.atCEPeak20.Value = val;
    app.atCEPeak10.Value = val;
end
%% ----------------------------------------------------------
function [] = FUNC_mapextraEN(app,v)
    app.border.Enable = v;
    app.stat.Enable = v;
    app.sample.Enable = v;
    app.ice.Enable = v;
end
function [] = FUNC_mapextraVAL(app,val)
    app.border.Value = val;
    app.stat.Value = val;
    app.sample.Value = val;
    app.ice.Value = val;
end
%% ----------------------------------------------------------
function [] = FUNC_plthistEN(app,v)
    app.hist1.Enable = v;
    app.hist2.Enable = v;
end
function [] = FUNC_plthistVAL(app,val)
    app.hist1.Value = val;
    app.hist2.Value = val;
end
%% ----------------------------------------------------------
function [N_map] = FUNC_MapCounter...
    (app,n_data,vMT,vatG,vatRE_Ui,vatRE_Peak,vatCE_BAP,vatCE_Ui,vatCE_Peak)
    N_RT = 0;
    N_RE = 0;
    N_CE = 0;
    N_RE_Ui = 0;
    N_RE_Peak = 0;
    N_CE_Ui = 0;
    N_CE_Peak = 0;
    N_KPT = 0;
    %% RT maps
    if vMT(1) == 1
        N_RT = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end

    %% RE maps
    if vMT(2) == 1
        N_RE = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% CE maps
    if vMT(5) == 1
        N_CE = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% RE_Ui maps
    if vMT(3) == 1
        N_RE_Ui = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% RE_Peak maps
    if vMT(4) == 1
        N_RE_Peak = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% CE_Ui maps
    if vMT(6) == 1
        N_CE_Ui = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% CE_Peak maps
    if vMT(7) == 1
        N_CE_Peak = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    %% KPT maps
    if vMT(8) == 1
        N_KPT = ...
            sum(vatG) + sum(vatRE_Ui) + sum(vatRE_Peak) + (sum(vatCE_BAP)*(sum(vatCE_Ui) + sum(vatCE_Peak)));
    end
    N_RT = N_RT * n_data;
    N_RE = N_RE * n_data;
    N_CE = N_CE * n_data;
    N_RE_Ui = N_RE_Ui * n_data;
    N_RE_Peak = N_RE_Peak * n_data;
    N_CE_Ui = N_CE_Ui * n_data;
    N_CE_Peak = N_CE_Peak * n_data;
    N_KPT = N_KPT * n_data;
    N_map = N_RT + N_RE + N_CE + N_RE_Ui + N_RE_Peak + N_CE_Ui + N_CE_Peak + N_KPT;
    
    app.totalmap.Value = N_map;
    end
%%
%     function FUNC_MenuEN(app,v)
%         app.PLOT.Enable = v;
%         app.SaveMenu.Enable = v;
%         app.Ssavecat.Enable = v;
%         app.SsavecatJPG.Enable = v;
%         app.SsavecatSVG.Enable = v;
%         app.SsavecatBOTH.Enable = v;
%         app.Ssavefold.Enable = v;
%         app.SsavefoldJPG.Enable = v;
%         app.SsavefoldSVG.Enable = v;
%         app.SsavefoldBOTH.Enable = v;
%         app.PlotandSaveMenu.Enable = v;
%         app.PSsavecat.Enable = v;
%         app.PSsavecatJPG.Enable = v;
%         app.PSsavecatSVG.Enable = v;
%         app.PSsavecatBOTH.Enable = v;
%         app.PSsavefold.Enable = v;
%         app.PSsavefoldJPG.Enable = v;
%         app.PSsavefoldSVG.Enable = v;
%         app.PSsavefoldBOTH.Enable = v;
%     end
%%
function [] = FUNC_profilecategoryEN(app,v)
    app.Statistic.Enable = v;
    app.randsample.Enable = v;
    app.randall.Enable = v;
    app.coordinate.Enable = v;
end
function [] = FUNC_profilecategoryVAL(app,val)
    app.Statistic.Value = val;
    app.randsample.Value = val;
    app.randall.Value = val;
    app.coordinate.Value = val;
end
%--------------------------------------
function [] = FUNC_profilestatEN(app,v)
    app.meanpos.Enable = v; 
    app.medpos.Enable = v;
    app.modepos.Enable = v;
    app.maxpos.Enable = v;
    app.meanneg.Enable = v;
    app.medneg.Enable = v;
    app.modeneg.Enable = v;
    app.minneg.Enable = v;
    app.meanov.Enable = v;
    app.medov.Enable = v;
    app.modetot.Enable = v;
end
function [] = FUNC_profilestatVAL(app,val)
    app.meanpos.Value = val;
    app.medpos.Value = val;
    app.modepos.Value = val;
    app.maxpos.Value = val;
    app.meanneg.Value = val;
    app.medneg.Value = val;
    app.modeneg.Value = val;
    app.minneg.Value = val;
    app.meanov.Value = val;
    app.medov.Value = val;
    app.modetot.Value = val;
end
%--------------------------------------
function [] = FUNC_profilesmplEN(app,v)
    app.numrandsample.Enable = v;
end
function [] = FUNC_profilesmplVAL(app,val)
    app.numrandsample.Value = val;
end
%--------------------------------------
function [] = FUNC_profileallEN(app,v)
    app.numrandall.Enable = v; 
end
function [] = FUNC_profileallVAL(app,val)
    app.numrandall.Value = val;
end
%--------------------------------------
function [] = FUNC_profilecordEN(app,v)
    app.latinput.Enable = v;
    app.longinput.Enable = v;
end
function [] = FUNC_profilecordVAL(app,val)
    app.latinput.Value = val;
    app.longinput.Value = val;
end
%% 
function [N_profile] = FUNC_ProfileCounter(app,n_data,vPP,vststPr)
    if vPP(1) == 1
        n_stat = sum(vststPr);
    else
        n_stat = 0;
    end
    if app.randsample.Value == 1
        n_smplrnd = app.numrandsample.Value;
    else
        n_smplrnd = 0;
    end
    if app.randall.Value == 1
        n_allrnd = app.numrandall.Value;
    else
        n_allrnd = 0;
    end
    pnt = 0;
    if vPP(end) == 1
        lat_usr = app.latinput.Value;
        long_usr = app.longinput.Value;
        if lat_usr > -65 && lat_usr < 75
            if long_usr >= -180 && long_usr <= 180
                LLA = app.LatLongAlt;
                lat = LLA(:,1);
                long= LLA(:,2);
                LLA(:,4) = abs(lat_usr - lat);
                LLA(:,5) = abs(long_usr - long);
                LLA(:,6) = sqrt((LLA(:,4).^2) + (LLA(:,5).^2));
                [~,pnt] = min(LLA(:,6));
                pnt = pnt(1);
                n_coord = 1;
            else
                pnt = 0;
                n_coord = 0;
            end
        else
            pnt = 0;
            n_coord = 0;
        end
    else
        n_coord = 0;
    end
    N_profile = (n_stat + n_smplrnd + n_allrnd + n_coord) * n_data;
    if N_profile > 0
        app.totalprofile.Value = N_profile;
    else
        app.totalprofile.Value = 0;
    end
end
%%
function [] = FUNC_precEN(app,v)
    app.PLprec.Enable = v;
    app.LGMprec.Enable = v;
    app.MHprec.Enable = v;
    app.PIprec.Enable = v;
    app.PDprec.Enable = v;
    app.PLLGMdif.Enable = v;
    app.PLMHdif.Enable = v;
    app.PLPIdif.Enable = v;
    app.PLPDdif.Enable = v;
    app.LGMMHdif.Enable = v;
    app.MHPIdif.Enable = v;
    app.LGMPDdif.Enable = v;
    app.LGMPIdif.Enable = v;
    app.MHPDdif.Enable = v;
    app.PIPDdif.Enable = v;
end
function [] = FUNC_precVAL(app,val)
    app.PLprec.Value = val;
    app.LGMprec.Value = val;
    app.MHprec.Value = val;
    app.PIprec.Value = val;
    app.PDprec.Value = val;
    app.PLLGMdif.Value = val;
    app.PLMHdif.Value = val;
    app.PLPIdif.Value = val;
    app.PLPDdif.Value = val;
    app.LGMMHdif.Value = val;
    app.MHPIdif.Value = val;
    app.LGMPDdif.Value = val;
    app.LGMPIdif.Value = val;
    app.MHPDdif.Value = val;
    app.PIPDdif.Value = val;
end
function N_precipitaion = FUNC_PrecipitationCounter(app,precHOW,prec,difprec)
    A = sum(prec == 1);
    A1 = A*precHOW(1);
    if A1 > 1
        A1 = 1;
    end
    precfig = (A1) + (A*precHOW(2));
    
    B = sum(difprec == 1);
    B1 = B*precHOW(1);
    if B1 > 1
        B1 = 1;
    end
    difprecfig = (B1) + (B*precHOW(2));
    
    N_precipitaion = precfig + difprecfig;
    
    if N_precipitaion > 0
        app.totalprecipitation.Value = N_precipitaion;
    else
        app.totalprecipitation.Value = 0;
    end
end
%%
function  N_histogram = FUNC_histcounter(app,pltHIST,n_data)
    N_hist1 = n_data*pltHIST(1); % number of RT histograms
    N_hist2 = n_data*pltHIST(2); % number of RE/CE histograms
    N_histogram = N_hist1 + N_hist2; % total number of histograms
    if N_histogram > 0 % pass it to the 'Number of figures' panel
        app.totalhistogarm.Value = N_histogram;
    else
        app.totalhistogarm.Value = 0;
    end
end