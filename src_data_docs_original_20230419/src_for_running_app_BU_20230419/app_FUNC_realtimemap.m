function [] = app_FUNC_realtimemap(app)
%------------------------------------------------------------------------
% This is responsible for the realtime map
% It gets any changes and apply it on the app

%++++++++++++++++
% This function is used in:
    %1-app designer main script

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    %1-app_FUNC_pointfinder
%------------------------------------------------------------------------
    InputData = app.InputData;
    vPP = app.vPP;
    vststPr = app.vststPr;
    vsmplrnd = app.vsmplrnd;
    vallrnd = app.vallrnd;
    vcord = app.vcord;

%% clear
    cla(app.UIAxes);
    rectangle(app.UIAxes,'Position',[-180 -90 360 180],'FaceColor',[0 0 0 0.7],'EdgeColor','none');
    hold(app.UIAxes,'on');
%% LGM full ice cover
    if app.ice.Value == 1
        ice_loc = app.ICE_LOC_full;
        plot(app.UIAxes,ice_loc(:,2),ice_loc(:,1),'+','color',[1 1 0],'MarkerSize',5); %plot LGM ice sheet
        hold(app.UIAxes,'on');
    end
%% selected area
    LBlat = app.LBlat.Value;
    LBlong = app.LBlong.Value;
    TRlat = app.TRlat.Value;
    TRlong = app.TRlong.Value;
    if TRlat <= LBlat
        app.TRlat.Value = 75;
        TRlat = app.TRlat.Value;
    end
    if TRlong <= LBlong
        app.TRlong.Value = 180;
        TRlong = app.TRlong.Value;
    end
    w = abs(LBlong - TRlong);
    h = abs(LBlat - TRlat);
    rectangle(app.UIAxes,'Position',[LBlong LBlat w h],'FaceColor',[0 0 1 0.6],'EdgeColor','none');
%% Country borders  
    Borders = app.brdrs;
    plot(app.UIAxes,Borders(2,:),Borders(1,:),'k','Linewidth',0.25);
    hold(app.UIAxes,'on');
%% cosmo sample points
    if app.sample.Value == 1
        smpl = app.SMPL;
        plot(app.UIAxes,smpl(:,2),smpl(:,1),'o','MarkerEdgeColor',[0 0.8 0],'MarkerFaceColor',[0 0.8 0],'MarkerSize',1.5);
    end
%% selected point
    s_point = [];
    allpnts = [];
    alltype = [];
    allIPT = [];
    if (vPP(1) == 1 && sum(vststPr) > 0) || (vPP(2) == 1 && sum(vsmplrnd) > 0) || (vPP(3) == 1 && sum(vallrnd) > 0) || (vPP(4) == 1)
        for i = 1:size(InputData,1)
            dta = load(InputData{i,7});   dta = dta.BriefOP;
            RE = dta(:,42:75); 
            RE_Ui = dta(:,76:109); 
            tmp1 = find(isnan(RE(:,3))); % if it couldn't reach to (tt)
            RE(tmp1,3) = RE(tmp1,4); % then it already reached to (EQ) so the value is same as value at the end
            RE_Ui(tmp1,3) = RE_Ui(tmp1,4);
            [s_point,alltype,allIPT] = app_FUNC_pointfinder(app,RE,RE_Ui,vPP,vststPr,vsmplrnd,vallrnd,vcord);
            allpnts(i,:) = s_point;
        end
        allpnts(isnan(allpnts)) = [];
        A = isempty(allpnts);
        if A == 0
            LLA = app.LatLongAlt;
            s_coord = LLA(allpnts(:),1:2);
            plot(app.UIAxes,s_coord(:,2),s_coord(:,1),'.','MarkerEdgeColor',[1 0 0],'MarkerFaceColor',[1 0 0],'MarkerSize',20);
        end
    end
    app.allpnts = allpnts ;
    app.alltype = alltype ;
    app.allIPT = allIPT ;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    