function [] = app_FUNC_precMapMakerPrec(app,TPind,plt_xt,ppath)
%% Read the data and make the maps
    all_dir = app.PrecipitationDir;
    all_data = app.PrecipitationData;
    fileinp = [["PL_MAP_oceanmasked.txt"],["LGM_MAP_oceanmasked.txt"],...
        ["MH_MAP_oceanmasked.txt"],["PI_MAP_oceanmasked.txt"],["PD_MAP_oceanmasked.txt"]];
    TPinp = ["PLIO","LGM","MH","PI","PD"];
    TP = TPinp(TPind);
    file = fileinp(TPind);
    fp =  char(all_dir(1).folder);
    data(:,1:2) = all_data(:,1:2);
    for i = 1:length(TPind)  % data = [lat      lon        p_PL        p_LGM       p_MH      p_PI      p_PD]
        data(:,i+2) = all_data(:,TPind(i)+2);   
    end
%% Some preparation for plots
    data(data(:,1)>75,:) = []; % delete all the data higher than 75N
    data(data(:,1)<-60,:) = []; % delete all the data lower than 60S
    lat = data(:,1);                         % latitude
    lon = data(:,2);                        % longitude
    lat_unq = unique(lat);
    long_unq = unique(lon);
    [~,nlat_tmpB] = min(abs(app.LBlat.Value - lat_unq));
    [~,nlat_tmpT] = min(abs(app.TRlat.Value - lat_unq));
    [~,nlong_tmpL] = min(abs(app.LBlong.Value - long_unq));
    [~,nlong_tmpR] = min(abs(app.TRlong.Value - long_unq));
    [LAT,LONG] = meshgrid(lat_unq(nlat_tmpB:nlat_tmpT),long_unq(nlong_tmpL:nlong_tmpR));
    P = NaN(size(LAT));
    j = 1;
    ind_mesh = zeros(length(lat),2);
    for k = 1:length(lat)
        ind_tmp = find(LAT == lat(k) & LONG == lon(k));
        if not(isempty(ind_tmp))
            ind_mesh(j,1) = ind_tmp;
            ind_mesh(j,2) = k;
            j = j+1;
        end
    end
    ind_mesh(ind_mesh(:,1) == 0 , :) = [];
    mat_data = NaN(size(LAT,1),size(LAT,2),length(file));
    for k = 1:length(file)
        ndata = data(ind_mesh(:,2),k+2);
        P(ind_mesh(:,1)) = ndata;
        mat_data(:,:,k) = P;
    end
%-----------------------------------------------------
    if plt_xt(3) == 1
        smpl = app.SMPL;
        a3 = app.A3;
    else
        smpl = [];
        a3 = [];
    end
%-----------------------------------------------------
    if plt_xt(4) == 1
        ice_loc = app.ICE_LOC;
    else
        ice_loc = [];
    end
%----------------------------------------------------- pick locations with sample
    if plt_xt(3) == 1
        smpl(:,7) = data(a3);
    end
% %----------------------------------------------------- statistic values
%     if plt_xt(2) == 1
%         stat = somestatistic(RE_Ui(:,1),data);
%     else
%         stat = [];
%     end
    funcprecmapmaker(app,fp,TP,LAT,LONG,mat_data,plt_xt,smpl,ice_loc,ppath);
end
%% make the map ready
function[] = funcprecmapmaker(app,fp,TP,LAT,LON,mat_data,plt_xt,smpl,ice_loc,ppath)
%------------------------------ set the figure
    [latFIG,longFIG,rtio] = app_FUNC_figureratio(app);
    f = app_FUNC_setthefiguresize(app,rtio);
%------------------------------
    sz = size(mat_data,3); % number of axis in a figure
    P_max = nanmax(nanmax(nanmax(mat_data)));
    P_min = nanmin(nanmin(nanmin(mat_data)));
    lst = TP(sz);
    [pos] = funcaxispos(app,sz);
    for i = 1:sz
        subplot('Position',pos(i,:))
        app_FUNC_mapaxesmakerprecipitation(app,sz,i,'p',latFIG,longFIG,rtio);
        map_MAP(app,LAT,LON,mat_data(:,:,i),TP(i),P_min,P_max,lst,plt_xt,smpl,ice_loc);
        set(gca,'PlotBoxAspectRatioMode','manual');
        set(gca,'PlotBoxAspectRatio',[1/rtio  1  1]);
    end
    annotation('textbox',[0.0011 0.0019 0.1724 0.0302], 'String',{fp},'fontsize',7,...
    'FitBoxToText','on','interpreter','none','EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1]);
    if app.SAVECheckBox.Value == 1 % save
        funcpercmapsave(app,ppath,TP,f)
    end
    if app.PLOTCheckBox.Value == 0
        close(f)
    end
end   
%% plot the map
function map_MAP(app,LAT,LON,P,TP,P_min,P_max,lst,plt_xt,smpl,ice_loc)
    scb = plt_xt(5); % swtich to default fix colorbar or adaptable
    if scb == 0 % fix colorbar
        target_labels = [0 25 50 100 150 200 300 400 500 750 1000 1250 1500 2000 2500 3000 50000];
        for i = 1:length(target_labels)-1
            if i == length(target_labels)-1
                P(P>=target_labels(i)&P<=100000) = i+100000;
            else
                P(P>=target_labels(i)&P<target_labels(i+1)) = i+100000;
            end
        end       
        surfm(LAT,LON,P)
        initial_labels = 1+100000:length(target_labels)+100000;
        clrs = flip(redblue(length(target_labels)+1));
        clrs((clrs(:,1)==1 & clrs(:,2)==1 & clrs(:,3)==1),:) = [];
        contourcmap('jet',initial_labels)
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        if TP == lst    
            tlab = {string(target_labels)};
            tlab = tlab{1};
            tlab(end-1) = string(target_labels(end-1));
            tlab(end) = "\uparrow";
            cb = colorbar('Ticks',initial_labels,'TickLabels',tlab,'FontSize',10,'FontWeight','bold');  
            label = cb.Label;
            label.String = "Mean Annual Precipitation [mm/yr]";
            label.FontSize = 10;
            label.FontWeight = 'bold';
            pscb = cb.Position;
            cb.Position = [pscb(1)+(pscb(1)*0.075)  0.1  0.02  0.8];
            cb.TickLength = 0.035;
        end
    else % adaptable colorbar
        spacing = app_FUNC_colobarspacing(P,1,P_min,P_max,10);
        target_labels = spacing;
        target_labels = app_FUNC_roundvalues(target_labels);
        for i = 1:length(target_labels)-1
            if i == length(target_labels)-1
                P(P>=target_labels(i)&P<=100000) = i+100000;
            else
                P(P>=target_labels(i)&P<target_labels(i+1)) = i+100000;
            end
        end       
        surfm(LAT,LON,P)
        initial_labels = 1+100000:length(target_labels)+100000;
        clrs = flip(redblue(length(target_labels)+1));
        clrs((clrs(:,1)==1 & clrs(:,2)==1 & clrs(:,3)==1),:) = [];
        contourcmap('jet',initial_labels)
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        if TP == lst    
            tlab = {string(target_labels)};
            tlab = tlab{1};
            cb = colorbar('Ticks',initial_labels,'TickLabels',tlab,'FontSize',10,'FontWeight','bold');  
            label = cb.Label;
            label.String = "Mean Annual Precipitation [mm/yr]";
            label.FontSize = 10;
            label.FontWeight = 'bold';
            pscb = cb.Position;
            cb.Position = [pscb(1)+(pscb(1)*0.075)  0.1  0.02  0.8];
            cb.TickLength = 0.035;
        end
    end

    title(TP,'fontsize',10,'fontweight','bold');
%% ---------------------------------------------------------- % Extra info on the map
    txtall = {''};
    %----------------------------------------------------------
    if plt_xt(1)==1 % add country borders
        Borders = app.brdrs;
        plotm(Borders(1,:),Borders(2,:),'k') %plot borders
    end
    %----------------------------------------------------------
    if plt_xt(4) == 1 % add LGM ice sheet location
        plotm(ice_loc(:,1),ice_loc(:,2),'+','color',[0.8 0.8 0.8],'MarkerSize',1.5)
        txtall{end+1} = ['{\color[rgb]{0.3 0.3 0.3}+ \color[{black}LGM ice cover}'];
    end
    %----------------------------------------------------------
    if plt_xt(3) == 1 % add cosmo sample points
        plotm(smpl(:,1),smpl(:,2),'.','MarkerEdgeColor',[0 0.7 0],'MarkerSize',15);
        txtall{end+1} = ['{\color[rgb]{0 0.7 0}\bullet \color{black}cosmo sample}'];
    end
    txtall(1) = [];
    %----------------------------------------------------------
    if TP == lst 
        if plt_xt(3) == 1 || plt_xt(4) == 1
            annotation('textbox',[0.002 0.920 0.114 0.074],'String',txtall,'FitBoxToText','on',...
            'EdgeColor',[0.5 0.5 0.5], 'BackgroundColor',[0.8 0.8 0.8],'interpreter','tex','fontsize',12);
        end
    end
end 
%% axis position
function [pos] = funcaxispos(app,sz)
    [~,~,rtio] = app_FUNC_figureratio(app);

    lft = 0.1;
    rgt = 0.1;
    bot = 0.1;
    top = 0.1;
    vdist = 0.025;
    hdist = 0.025;
    
    if rtio < 0.75 % landscape maps
        wdt = (1 - lft - rgt);
        hgt = (1 - bot - top - ((sz-1) * vdist)) / sz;
        if sz == 1
            pos(1,:) = [lft                                             bot            wdt     hgt]; 
        elseif sz == 2
            pos(1,:) = [lft             bot                                        wdt     hgt];    
            pos(2,:) = [lft             pos(1,2)+hgt+vdist             wdt     hgt];
        elseif sz == 3
            pos(1,:) = [lft             bot                                        wdt     hgt];    
            pos(2,:) = [lft             pos(1,2)+hgt+vdist             wdt     hgt];
            pos(3,:) = [lft             pos(2,2)+hgt+vdist             wdt     hgt];
        elseif sz == 4
            pos(1,:) = [lft             bot                                        wdt     hgt];    
            pos(2,:) = [lft             pos(1,2)+hgt+vdist             wdt     hgt];
            pos(3,:) = [lft             pos(2,2)+hgt+vdist             wdt     hgt];
            pos(4,:) = [lft             pos(3,2)+hgt+vdist             wdt     hgt];
        elseif sz == 5
            pos(1,:) = [lft             bot                                        wdt     hgt];    
            pos(2,:) = [lft             pos(1,2)+hgt+vdist             wdt     hgt];
            pos(3,:) = [lft             pos(2,2)+hgt+vdist             wdt     hgt];
            pos(4,:) = [lft             pos(3,2)+hgt+vdist             wdt     hgt];
            pos(5,:) = [lft             pos(4,2)+hgt+vdist             wdt     hgt];
        end
    else % portrait maps
        hgt = (1 - bot - top);
        wdt = (1 - lft - rgt - ((sz-1) * vdist)) / sz;
        if sz == 1
            pos(1,:) = [lft                                             bot            wdt     hgt];
        elseif sz == 2
            pos(1,:) = [lft                                             bot            wdt     hgt];    
            pos(2,:) = [pos(1,1)+wdt+hdist              bot             wdt     hgt];  
        elseif sz == 3
            pos(1,:) = [lft                                             bot            wdt     hgt];    
            pos(2,:) = [pos(1,1)+wdt+hdist              bot             wdt     hgt];   
            pos(3,:) = [pos(2,1)+wdt+hdist              bot             wdt     hgt];        
        elseif sz == 4
            pos(1,:) = [lft                                             bot            wdt     hgt];    
            pos(2,:) = [pos(1,1)+wdt+hdist              bot             wdt     hgt];   
            pos(3,:) = [pos(2,1)+wdt+hdist              bot             wdt     hgt];    
            pos(4,:) = [pos(3,1)+wdt+hdist              bot             wdt     hgt];
        elseif sz == 5
            pos(1,:) = [lft                                             bot            wdt     hgt];    
            pos(2,:) = [pos(1,1)+wdt+hdist              bot             wdt     hgt];   
            pos(3,:) = [pos(2,1)+wdt+hdist              bot             wdt     hgt];    
            pos(4,:) = [pos(3,1)+wdt+hdist              bot             wdt     hgt];    
            pos(5,:) = [pos(4,1)+wdt+hdist              bot             wdt     hgt];
        end
    end
end
%% save
function [] = funcpercmapsave(app,ppath,TP,f)
    set(f,'PaperUnits','centimeters');
    set(f, 'Units', 'centimeters');
    ppsz_org = get(f,'PaperSize');
    ppsz_pdf = get(f, 'OuterPosition');
    set(f, 'Units', 'Normalized');
 %----------------------
    if app.CategorizedButton.Value == 1
        temppath = string(ppath)+"\SavedFigures\PrecipitationMaps";
        if ismac
            temppath = strrep(temppath,'\','/');
        end
        if not(exist(char(temppath),"dir"))
            mkdir(char(temppath))
        end
        % go to related figure folder    
        map_path = temppath+"\";
    elseif app.AlltogetherButton.Value == 1
        map_path = string(ppath) + "\";
    end
    % make a proper name for the fugures to save as jpg or any other format
    tp = "("+TP(1);
    if length(TP) > 1
        for i = 2:length(TP)
            tp = tp+"&"+TP(i);
        end
        tp = tp + ")";
    else
        tp = tp + ")";
    end
    fn_map = sprintf("%sMeanAnnualPrecipitation_%s",map_path,tp);
    if ismac
        fn_map = strrep(fn_map,'\','/');
    end
    %---------------------------------
    if app.JPG.Value == 1
        i = 1;
        while true
            if exist(char(fn_map+".jpg"), 'file') == 2
                if i > 1
                    a = strfind(fn_map,"_");
                    fn_map(a(end):end) = "";
                    fn_map = fn_map+"_"+string(i);
                else
                    fn_map = fn_map+"_"+string(i);
                end
                i = i+1;
            else
                break
            end
        end
        set(f,'PaperSize',[ppsz_org]);
        print(f,char(fn_map+".jpg"),'-djpeg','-r600') % save the figure as jpg
    end
    %---------------------------------
    if app.PDF.Value == 1
        i = 1;
        while true
            if exist(char(fn_map+".pdf"), 'file') == 2
                if i > 1
                    a = strfind(fn_map,"_");
                    fn_map(a(end):end) = "";
                    fn_map = fn_map+"_"+string(i);
                else
                    fn_map = fn_map+"_"+string(i);
                end
                i = i+1;
            else
                break
            end
        end
        set(f,'PaperSize',[ppsz_pdf(3) ppsz_pdf(4)]);
        print(f,char(fn_map+".pdf"),'-dpdf','-r600','-painters','-fillpage') % save the figure as jpg
    end
    %---------------------------------
    if app.BMP.Value == 1
        i = 1;
        while true
            if exist(char(fn_map+".bmp"), 'file') == 2
                if i > 1
                    a = strfind(fn_map,"_");
                    fn_map(a(end):end) = "";
                    fn_map = fn_map+"_"+string(i);
                else
                    fn_map = fn_map+"_"+string(i);
                end
                i = i+1;
            else
                break
            end
        end
        set(f,'PaperSize',[ppsz_org]);
        print(f,char(fn_map+".bmp"),'-dbmp16m','-r600') % save the figure as jpg
    end
    %---------------------------------
    if app.SVG.Value == 1
        i = 1;
        while true
            if exist(char(fn_map+".svg"), 'file') == 2
                if i > 1
                    a = strfind(fn_map,"_");
                    fn_map(a(end):end) = "";
                    fn_map = fn_map+"_"+string(i);
                else
                    fn_map = fn_map+"_"+string(i);
                end
                i = i+1;
            else
                break
            end
        end
        set(f,'PaperSize',[ppsz_org]);
        print(f,char(fn_map+".svg"),'-dsvg','-r600','-painters') % save the figure as jpg
    end
end