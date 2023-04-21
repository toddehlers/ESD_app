function app_FUNC_mapaxesmakerprecipitation(app,sz,iii,typ,latFIG,longFIG,rtio)
%------------------------------------------------------------------------
% This function makes map axis for precipitation maps

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_precMapMakerPrec
    %2-app_FUNC_precMapMakerDif
    %3-app_FUNC_tempMapMakerTemp
    %4-app_FUNC_tempMapMakerDif

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
    
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
%     tmp1 = abs(spc1(1) - spc1(2))/2;
%     tmp2 = abs(spc2(1) - spc2(2))/2;
%     spc1 = linspace(LBlat+tmp1,TRlat-tmp1,lt-1);
%     spc2 = linspace(LBlong+tmp2,TRlong-tmp2,lg-1);

    sz2 = sz;
    if sz2 > 1
        sz2 = sz2/2;
    end

    mx = max(latFIG,longFIG);
    mn = min(latFIG,longFIG);
    if mx >= 90
        spc = 30*sz2;
    elseif mx < 90 && mx >= 60
        spc = 20*sz2;
    elseif mx < 60 && mx >= 30
        spc = 10*sz2;
    elseif mx < 30 && mx >= 15
        spc = 5*sz2;
    elseif mx < 15 && mx >= 6
        spc = 2*sz2;
    else 
        spc = 1*sz2;
    end
    if spc > mn/2
        tmp1 = round(mn/2,0);
        tmp2 = rem(tmp1,10);
        spc = (tmp1 - tmp2) + 10;
    end
    
    spc1 = spc;
    spc2 = spc;
    
    axesm('MapProjection','eqdcylin','MapLatLimit',[LBlat TRlat],'MapLonLimit',[LBlong TRlong],'Frame', 'on', 'FLineWidth',0.5, 'Grid', 'on',...
        'PLineLocation',spc1,'MLineLocation',spc2);
    
    if typ == 'p' %------------- for precipitation maps
        if rtio < 0.75 % landscape maps
            plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
            if iii == 1
                mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
            end
        else % portrait mode
            if iii == 1
                plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
            end
            mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
        end
    elseif typ == 'd' %------------- for diff precipitation maps
        if rtio < 0.75 % landscape maps
            if sz <= 3
                plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
                if iii == sz
                    mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
                end
            else
                if iii <= ceil(sz/2)
                    plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
                end
                if iii == ceil(sz/2) || iii == sz
                    mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
                end
            end
        else % portrait mode
            if sz <= 5
                mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
                if iii == 1
                    plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
                end
            else
                if iii == 1 || iii == ceil(sz/2)+1
                    plabel('PlabelLocation',spc1,'FontSize',10,'FontWeight','bold');
                end
                if iii > ceil(sz/2)
                    mlabel('MlabelLocation',spc2,'MlabelParallel', 'south','FontSize',10,'FontWeight','bold');
                end
            end
        end
    end
    axis tight
    axis off
    
    
    
    
    
    
    
    
    
    