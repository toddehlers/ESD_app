function app_FUNC_mapaxesmaker(app,latFIG,longFIG,rtio)
    LBlat = app.LBlat.Value;
    LBlong = app.LBlong.Value;
    TRlat = app.TRlat.Value;
    TRlong = app.TRlong.Value;
    
%     if rtio < 0.5
%         lt = (13 * rtio * 1.5) + 1;
%         lg = 13; 
%     elseif rtio > 1.25
%         lt = 10;
%         lg = (10 / rtio / 1.5) +1; 
%     else
%         lt = 7;
%         lg = 7; 
%     end
%     if lt < 2
%         lt = 2;
%     end
%     if lg < 2
%         lg = 2;
%     end
% 
%     spc1 = linspace(LBlat,TRlat,lt);
%     spc2 = linspace(LBlong,TRlong,lg);

    mn = max(latFIG,longFIG);
    if mn >= 90
        spc = 30;
    elseif mn < 90 && mn >= 60
        spc = 20;
    elseif mn < 60 && mn >= 30
        spc = 10;
    elseif mn < 30 && mn >= 15
        spc = 5;
    elseif mn < 15 && mn >= 6
        spc = 2;
    else 
        spc = 1;
    end

    
    axesm('MapProjection','eqdcylin','MapLatLimit',[LBlat TRlat],'MapLonLimit',[LBlong TRlong],'Frame', 'on', 'FLineWidth',0.5, 'Grid', 'on',...
        'PLineLocation',spc,'MLineLocation',spc);
    plabel('PlabelLocation',spc,'FontSize',12,'FontWeight','bold');
    mlabel('MlabelLocation',spc,'MlabelParallel', 'south','FontSize',12,'FontWeight','bold');
    axis tight
    axis off