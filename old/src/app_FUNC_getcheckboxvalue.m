%% --------------------------------------------------------------------------------------------------------------------
% 1st function to use after each change
% it checks the value of all the checkboxes
function [] = app_Func_getcheckboxvalue(app)
%% data panel
        vTPi(1) = app.PLi.Value; % initial time chekcbox value
        vTPi(2) = app.LGMi.Value;
        vTPi(3) = app.MHi.Value;
        vTPi(4) = app.PIi.Value;
        %----------------
        vTPn(1) = app.LGMn.Value; % final time checkbox value
        vTPn(2) = app.MHn.Value;
        vTPn(3) = app.PIn.Value;
        vTPn(4) = app.PDn.Value;
        %----------------
        vL(1) = app.L10.Value; % River length checkbox value
        vL(2) = app.L40.Value;
        vL(3) = app.L80.Value;
        %----------------
        vUi(1) = app.Ui001.Value; % Initial rock uplift checkbox value
        vUi(2) = app.Ui01.Value;
        vUi(3) = app.Ui05.Value;
        vUi(4) = app.Ui1.Value;
        %----------------
        vK(1) = app.K55.Value; % bedrock detachment checkbox value
        vK(2) = app.K16.Value;
        vK(3) = app.K17.Value;
%% Erosion map panel        
        vMT(1) = app.RT.Value; % map type checkbox value
        vMT(2) = app.RE.Value;
        vMT(3) = app.RE_Ui.Value;
        vMT(4) = app.RE_Peak.Value;
        vMT(5) = app.CE.Value;
        vMT(6) = app.CE_Ui.Value;
        vMT(7) = app.CE_Peak.Value;
        vMT(8) = app.KPT.Value;
    %----------------
        vatG(1) = app.atPeakRE.Value; % @ General
        vatG(2) = app.atPeakCE.Value;
        vatG(3) = app.atTT.Value;
        vatG(4) = app.atEnd.Value;
        %----------------
        vatRE_Ui(5) = app.atREUi50.Value; % @ Change in RE(Ui)
        vatRE_Ui(4) = app.atREUi40.Value;
        vatRE_Ui(3) = app.atREUi30.Value;
        vatRE_Ui(2) = app.atREUi20.Value;
        vatRE_Ui(1) = app.atREUi10.Value;
        %----------------
        vatRE_Peak(5) = app.atREPeak50.Value; % @ Change in RE(Peak)
        vatRE_Peak(4) = app.atREPeak40.Value;
        vatRE_Peak(3) = app.atREPeak30.Value;
        vatRE_Peak(2) = app.atREPeak20.Value;
        vatRE_Peak(1) = app.atREPeak10.Value;
        %----------------
        vatCE_BAP(1) = app.Bpeak.Value; % @ Change in CE Befor Peak
        vatCE_BAP(2) = app.Apeak.Value; % @ Change in CE After Peak
        %----------------
        if sum(vatCE_BAP == 1) > 0
            vatCE_Ui(5) = app.atCEUi50.Value; % @ Change in CE(Ui)
            vatCE_Ui(4) = app.atCEUi40.Value;
            vatCE_Ui(3) = app.atCEUi30.Value;
            vatCE_Ui(2) = app.atCEUi20.Value;
            vatCE_Ui(1) = app.atCEUi10.Value;
            %----------------
            vatCE_Peak(5) = app.atCEPeak50.Value; % @ Change in CE(Peak)
            vatCE_Peak(4) = app.atCEPeak40.Value;
            vatCE_Peak(3) = app.atCEPeak30.Value;
            vatCE_Peak(2) = app.atCEPeak20.Value;
            vatCE_Peak(1) = app.atCEPeak10.Value;
        else
            vatCE_Ui(1:5) = 0; % @ Change in CE(Ui)
            %----------------
            vatCE_Peak(1:5) = 0; % @ Change in CE(Peak)
        end
    %----------------
        vat_all = [vatG, vatRE_Ui, vatRE_Peak, vatCE_Ui, vatCE_Peak];
%% Options panel
        vExt(1) = app.border.Value;
        vExt(2) = app.stat.Value;
        vExt(3) = app.sample.Value;
        vExt(4) = app.ice.Value;
        if string(app.colorbar.Value) == "Fixed"
            vExt(5) = 0;
        else
            vExt(5) = 1;
        end
        vExt(6) = app.LBlat.Value;
        vExt(7) = app.LBlong.Value;
        vExt(8) = app.TRlat.Value;
        vExt(9) = app.TRlong.Value;
%% Erosion profile panel        
        vPP(1) = app.Statistic.Value; % change in how to pick points in profiles
        vPP(2) = app.randsample.Value;
        vPP(3) = app.randall.Value;
        vPP(4) = app.coordinate.Value;
    %----------------
        vststPr(1) = app.meanpos.Value; % pick value based on statistic
        vststPr(2) = app.medpos.Value;
        vststPr(3) = app.modepos.Value;
        vststPr(4) = app.maxpos.Value;
        vststPr(5) = app.meanneg.Value;
        vststPr(6) = app.medneg.Value;
        vststPr(7) = app.modeneg.Value;
        vststPr(8) = app.minneg.Value;
        vststPr(9) = app.meanov.Value;
        vststPr(10) = app.medov.Value;
        vststPr(11) = app.modetot.Value;
    %----------------
        vsmplrnd(1) = app.numrandsample.Value; % number of random points from the samples
    %----------------
        vallrnd(1) = app.numrandall.Value; % number of random points from all points
    %----------------
        vcord(1) = app.latinput.Value; % lat
        vcord(2) = app.longinput.Value; % long
%% Precipitation map panel
        precHOW(1) = app.onefig.Value; % plot precipitation maps in one figure
        precHOW(2) = app.sepfig.Value; % plot precipitation maps in seperated figures
        %----------------
        if sum(precHOW == 1) > 0
            prec(1) = app.PLprec.Value;
            prec(2) = app.LGMprec.Value;
            prec(3) = app.MHprec.Value;
            prec(4) = app.PIprec.Value;
            prec(5) = app.PDprec.Value;
            %----------------
            difprec(1) = app.PLLGMdif.Value;
            difprec(2) = app.PLMHdif.Value;
            difprec(3) = app.PLPIdif.Value;
            difprec(4) = app.PLPDdif.Value;
            difprec(5) = app.LGMMHdif.Value;
            difprec(6) = app.LGMPDdif.Value;
            difprec(7) = app.LGMPIdif.Value;
            difprec(8) = app.MHPIdif.Value;
            difprec(9) = app.MHPDdif.Value;
            difprec(10) = app.PIPDdif.Value;
        else
            prec(1:5) = 0;
            %----------------
            difprec(1:10) = 0;
        end
%% Histogram panel
        pltHIST(1) = app.hist1.Value; % plot RT histogram
        pltHIST(2) = app.hist2.Value; % plot RE/CE histogram
%% RUN panel
        RP(1) = app.PLOTCheckBox.Value; % visible plot
        RP(2) = app.SAVECheckBox.Value; % save

        RP(3) = app.JPG.Value; % jpg
        RP(4) = app.PDF.Value; % pdf 
        RP(5) = app.BMP.Value; % bmp
        RP(6) = app.SVG.Value; % svg

        RP(7) = app.AlltogetherButton.Value; % all together
        RP(8) = app.CategorizedButton.Value; % categorized
        
        if app.SAVECheckBox.Value == 1
            app.JPG.Enable = 1;
            app.PDF.Enable = 1;
            app.BMP.Enable = 1;
            app.SVG.Enable = 1;
            app.AlltogetherButton.Enable = 1;
            app.CategorizedButton.Enable = 1;
        else
            app.JPG.Enable = 0;
            app.PDF.Enable = 0;
            app.BMP.Enable = 0;
            app.SVG.Enable = 0;
            app.JPG.Value = 0;
            app.PDF.Value = 0;
            app.BMP.Value = 0;
            app.SVG.Value = 0;
            app.AlltogetherButton.Enable = 0;
            app.CategorizedButton.Enable = 0;
        end
%% map input parameters
        plt_type = find(vMT == 1);

        plt_at_G = vatG;

        plot_at_RE = [vatRE_Ui,vatRE_Peak];

        if vatCE_BAP(1) == 1 && vatCE_BAP(2) == 1
            plot_at_CE = [vatCE_Ui,vatCE_Ui,vatCE_Peak,vatCE_Peak];
        elseif vatCE_BAP(1) == 1
            plot_at_CE = [vatCE_Ui,zeros(1,5),vatCE_Peak,zeros(1,5)];
        elseif vatCE_BAP(2) == 1
            plot_at_CE = [zeros(1,5),vatCE_Ui,zeros(1,5),vatCE_Peak];
        else
            plot_at_CE = [vatCE_Ui,vatCE_Ui,vatCE_Peak,vatCE_Peak];
        end

        plt_at = [plt_at_G,plot_at_RE,plot_at_CE];
        plt_at = find(plt_at == 1);

        plt_xt = vExt;
%% add them to the app
        app.vTPi = vTPi;               % initial time chekcbox value
        app.vTPn = vTPn;               % final time checkbox value
        app.vL = vL;                  % River length checkbox value
        app.vUi = vUi;                 % Initial rock uplift checkbox value
        app.vK =  vK;                 % bedrock detachment checkbox value
        app.vMT = vMT ;                % map type checkbox value
        app.vatG =  vatG ;              % @ General
        app.vatRE_Ui = vatRE_Ui ;            % @ Change in RE(Ui)
        app.vatRE_Peak = vatRE_Peak  ;        % @ Change in RE(Peak)
        app.vatCE_BAP =  vatCE_BAP ;         % @ Change in CE Befor Peak & Change in CE After Peak
        app.vatCE_Ui =  vatCE_Ui  ;         % @ Change in CE(Ui)
        app.vatCE_Peak =  vatCE_Peak ;         % @ Change in CE(Peak)
        app.vExt = vExt  ;              % Options panel
        app.vat_all =  vat_all ;           % [vatG, vatRE_Ui, vatRE_Peak, vatCE_Ui, vatCE_Peak]             
        app.vPP =  vPP;                % change in how to pick points in profiles
        app.vststPr = vststPr ;              % pick value based on statistic
        app.vsmplrnd =  vsmplrnd ;          % number of random points from the samples
        app.vallrnd = vallrnd  ;           % number of random points from all points
        app.vcord = vcord ;              % lat & lon
        app.precHOW = precHOW  ;           % plot precipitation maps in one figure & plot precipitation maps in seperated figures
        app.prec =  prec ;              % Precipitation time period
        app.difprec =   difprec ;          % Preciitation difference time period
        app.pltHIST = pltHIST;     % Histogram plots
        app.RP = RP  ;                % Run panel
        
        app.plt_type = plt_type ;
        app.plt_at = plt_at ;
        app.plt_xt = plt_xt ;
end