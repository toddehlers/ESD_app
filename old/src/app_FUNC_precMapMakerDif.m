function [] = app_FUNC_precMapMakerDif(app,TP_DIFFind,plt_xt,ppath)
    %% Read the data and make the maps
    all_dir = app.PrecipitationDir; % precipitations directory
    all_data = app.PrecipitationData;  % precipitations data
    file = [["PL_MAP_oceanmasked.txt"],["LGM_MAP_oceanmasked.txt"],...
        ["MH_MAP_oceanmasked.txt"],["PI_MAP_oceanmasked.txt"],["PD_MAP_oceanmasked.txt"]]; 
    TP_DIFFinp = [  "PLIO-LGM","PLIO-MH","PLIO-PI","PLIO-PD",...
                                "LGM-MH","LGM-PI","LGM-PD",...
                                "MH-PI","MH-PD",...
                                "PI-PD" ];
    tpind = [[1,2];[1,3];[1,4];[1,5];[2,3];[2,4];[2,5];[3,4];[3,5];[4,5]]; % all possible conditions
    TP_DIFF = tpind(TP_DIFFind,:); % chosen conditions by user
    TP = TP_DIFFinp(TP_DIFFind); 
%     path = app.MainPath;
    fp =  char(all_dir(1).folder);
    data = all_data;
%     cd(cf);
    %% Some preparation for plots
    data(data(:,1)>75,:) = []; % delete all the data higher than 75N
    data(data(:,1)<-60,:) = []; % delete all the data lower than 60S
    lat = data(:,1);                         % latitude
    lon = data(:,2);                        % longitude
    lat_unq = unique(lat);
    long_unq = unique(lon);
    [~,nlat_tmpB] = min(abs(app.LBlat.Value - lat_unq)); % where is the closest data index to the selected BL lat
    [~,nlat_tmpT] = min(abs(app.TRlat.Value - lat_unq)); % where is the closest data index to the selected TR lat
    [~,nlong_tmpL] = min(abs(app.LBlong.Value - long_unq)); % where is the closest data index to the selected BL long
    [~,nlong_tmpR] = min(abs(app.TRlong.Value - long_unq)); % where is the closest data index to the selected BL long
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
    mat_diff = NaN(size(LAT,1),size(LAT,2),size(TP_DIFF,1));
    for i=1:size(TP_DIFF,1)
        k1 = TP_DIFF(i,1);
        k2 = TP_DIFF(i,2);
%         data_diff(:,i) = data(:,k1) - data(:,k2);
        mat_diff(:,:,i) = mat_data(:,:,k1) - mat_data(:,:,k2);
    end
    %% sample points
    if plt_xt(3) == 1
        smpl = app.SMPL;
        a3 = app.A3;
    else
        smpl = [];
        a3 = [];
    end
    %% LGM ice cover
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
    funcdiffprecmapmaker(app,fp,TP,LAT,LONG,mat_diff,plt_xt,smpl,ice_loc,ppath);
end
function[] = funcdiffprecmapmaker(app,fp,TP,LAT,LONG,mat_diff,plt_xt,smpl,ice_loc,ppath)
%----------------------------------------------- set the figure
    [latFIG,longFIG,rtio] = app_FUNC_figureratio(app);
    f = app_FUNC_setthefiguresize(app,rtio);
%-----------------------------------------------
    sz = size(mat_diff,3);
    P_max = max(max(max(mat_diff)));
    P_min = min(min(min(mat_diff)));
    [pos] = funcaxispos(app,sz);
    [~,lst] = max(pos(:,1));
%     ha = tight_subplot(5,2,[0.02 0.01],[0.1 0.1],[0.1 0.1]);
    for i = 1:sz
        subplot('Position',pos(i,:))
%         axes(ha(i));
        app_FUNC_mapaxesmakerprecipitation(app,sz,i,'d',latFIG,longFIG,rtio);
        map_DIFF(app,LAT,LONG,mat_diff(:,:,i),TP(i),P_min,P_max,plt_xt,smpl,ice_loc,i,lst);
        set(gca,'PlotBoxAspectRatioMode','manual');
        set(gca,'PlotBoxAspectRatio',[1/rtio  1  1]);
        if i == sz
            annotation('textbox',[0.0011 0.0019 0.1724 0.0302],'String',{fp},'fontsize',6,'FitBoxToText','on','interpreter','none');
        end
    end
%-----------------------------------------------
    if app.SAVECheckBox.Value == 1 % save
        funcpercmapsave(app,ppath,TP,f)
    end
%-----------------------------------------------
    if app.PLOTCheckBox.Value == 0
        close(f)
    end
%-----------------------------------------------
end   
function map_DIFF(app,LAT,LONG,D,TP,D_min,D_max,plt_xt,smpl,ice_loc,i,lst)
    scb = plt_xt(5); % swtich to default fix colorbar or adaptable
    if scb == 0 % fix colorbar
        D(D>-10&D<=10) = 0;
        D(D>-100&D<=-10) = -1;  
        D(D>10&D<=100) = 1;
        D(D>=D_min&D<=-2000) = -7;
        D(D>-2000&D<=-1000) = -6;
        D(D>-1000&D<=-750) = -5;
        D(D>-750&D<=-500) = -4;  
        D(D>-500&D<=-300) = -3;
        D(D>-300&D<=-100) = -2;
        D(D>100&D<=300) = 2;
        D(D>300&D<=500) = 3;
        D(D>500&D<=750) = 4;
        D(D>750&D<=1000) = 5;
        D(D>1000&D<=2000) = 6;
        D(D>2000&D<=D_max) = 7;
        initial_labels = -7:8;
        target_labels = [round(D_min,0) -2000 -1000 -750 -500 -300 -100 -10 10 100 300 500 750 1000 2000 round(D_max,0)];
        surfm(LAT,LONG,D)
        clrs = flip(redblue(length(target_labels)-1));
        clrs(8,:) = [0.8 0.8 0.8];
        contourcmap('jet',-initial_labels)
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        if i == lst 
            tlab = {string(target_labels)};
            tlab = tlab{1};
            tlab(1) = "\downarrow";
            tlab(end) = "\uparrow";
            cb = colorbar('Ticks',initial_labels,'TickLabels',tlab,'FontSize',10,'FontWeight','bold');    
            label = cb.Label;
            label.String = "Mean Annual Precipitation Difference [mm/yr]";
            label.FontSize = 10;
            label.FontWeight = 'bold';
            pscb = cb.Position;
            cb.Position = [pscb(1)+(pscb(1)*0.075)  0.1  0.02  0.8];
            cb.TickLength = 0.035;
        end
    else % adaptable colorbar
        spacing = app_FUNC_colobarspacing(D,1,D_min,D_max,10);
        target_labels = spacing;
        target_labels = app_FUNC_roundvalues(target_labels);
        neg = length(find(target_labels<0));
        pos = length(find(target_labels>0));
        for ii = 1:length(target_labels)-1
            if ii == length(target_labels)-1
                D(D>=target_labels(ii)&D<=100000) = ii+100000;
            else
                D(D>=target_labels(ii)&D<target_labels(ii+1)) = ii+100000;
            end
        end 
        initial_labels = 1+100000:length(target_labels)+100000;
        surfm(LAT,LONG,D)
        clrs_tmp = flip(redblue(max(pos,neg)*2+1));
        if neg == 0
            clrs(1:pos-1,1:3) = clrs_tmp(pos+3:end,1:3);
        elseif pos == 0
            clrs(1:neg-1,1:3) = clrs_tmp(1:neg-1:end,1:3);
        else
            clrs(1:neg-1,1:3) = clrs_tmp(1:neg-1,1:3);
            clrs(end+1,1:3) = [0.8 0.8 0.8];
            clrs(end+1:end+pos-1,1:3) = clrs_tmp(end-pos+2:end,1:3);
        end
        contourcmap('jet',-initial_labels)
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        if i == lst 
            tlab = {string(target_labels)};
            tlab = tlab{1};
            cb = colorbar('Ticks',initial_labels,'TickLabels',tlab,'FontSize',10,'FontWeight','bold');    
            label = cb.Label;
            label.String = "Mean Annual Precipitation Difference [mm/yr]";
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
    if plt_xt(1)==1
        Borders = app.brdrs;
        plotm(Borders(1,:),Borders(2,:),'k') %plot borders 
    end
    %----------------------------------------------------------
    if plt_xt(4) == 1
        plotm(ice_loc(:,1),ice_loc(:,2),'+','color',[0.8 0.8 0.8],'MarkerSize',1.5)
        txtall{end+1} = ['{\color[rgb]{0.3 0.3 0.3}+ \color[{black}LGM ice cover}'];
    end
    %----------------------------------------------------------
    if plt_xt(3) == 1
        plotm(smpl(:,1),smpl(:,2),'.','MarkerEdgeColor',[0 0.7 0],'MarkerSize',15);
        txtall{end+1} = ['{\color[rgb]{0 0.7 0}\bullet \color{black}cosmo sample}'];
    end
    txtall(1) = [];
    %----------------------------------------------------------
    if i == lst
        if plt_xt(3) == 1 || plt_xt(4) == 1
            annotation('textbox',[0.002 0.920 0.114 0.074],'String',txtall,'FitBoxToText','on',...
            'EdgeColor',[0.5 0.5 0.5], 'BackgroundColor',[0.8 0.8 0.8],'interpreter','tex','fontsize',12);
        end
    end
end 
%% axis position
function [pos] = funcaxispos(app,sz)
    [~,~,rtio] = app_FUNC_figureratio(app);
%---------------------------
    lft = 0.1;
    rgt = 0.1;
    bot = 0.1;
    top = 0.1;
    vdist = 0.025;
    hdist = 0.025;
%---------------------------
    if rtio < 0.75 % landscape maps
        for i = 1:sz
            if sz == 1
                wdt = (1 - lft - rgt);
                hgt = (1 - bot - top);
                pos(1,:) =                [lft                              bot                                        wdt     hgt]; 
            elseif sz == 2 || sz == 3
                wdt = (1 - lft - rgt);
                hgt = (1 - bot - top - ((sz-1) * vdist)) / sz;
                if i == 1
                    pos(1,:) =                [lft        bot+((sz-1)*vdist)+((sz-1)*hgt)        wdt     hgt];
                else
                    pos(i,:) =                 [lft        pos(i-1,2)-vdist-hgt                         wdt     hgt];
                end
            elseif sz >= 4
                rw = fix(sz / 2)  + rem(sz,2);
                wdt = (1 - lft - rgt - hdist) / 2;
                hgt = (1 - bot - top - ((rw-1) * vdist)) / rw;
                if i == 1
                    pos(1,:) =                [lft        bot+((rw-1)*vdist)+((rw-1)*hgt)        wdt     hgt];
                elseif i <= ceil(sz/2)   
                    pos(i,:) =                 [lft        pos(i-1,2)-vdist-hgt                          wdt     hgt];
                elseif i > ceil(sz/2)   
                    pos(i,:) =                 [lft+wdt+hdist        pos(i-ceil(sz/2) ,2)                       wdt     hgt];
                end
            end
        end
%---------------------------
    else % portrait maps and square model
        for i = 1:sz
            if sz == 1
                wdt = (1 - lft - rgt);
                hgt = (1 - bot - top);
                pos(1,:) =                [lft      bot     wdt     hgt]; 
            elseif sz >= 2 && sz < 6
                wdt = (1 - lft - rgt - ((sz-1) * hdist)) / sz;
                hgt = (1 - bot - top);
                if i == 1
                    pos(1,:) =                [lft        bot        wdt     hgt];
                else
                    pos(i,:) =                 [pos(i-1,1)+wdt+hdist        bot       wdt     hgt];
                end
            elseif sz >= 6
                cl = fix(sz / 2) + rem(sz,2);
                wdt = (1 - lft - rgt - ((cl-1) * hdist)) / cl;
                hgt = (1 - bot - top - vdist) / 2;
                if i == 1
                    pos(1,:) =                [lft        bot+hgt+vdist        wdt     hgt];
                elseif i <= cl
                    pos(i,:) =                 [pos(i-1,1)+wdt+hdist        pos(1,2)       wdt     hgt];
                else
                    pos(i,:) =                 [pos(i-cl,1)        bot      wdt     hgt];
                end
            end
        end
%---------------------------
    end
end
%% Save
function [] = funcpercmapsave(app,ppath,TP,f)
    set(f,'PaperUnits','centimeters');
    set(f, 'Units', 'centimeters');
    ppsz_org = get(f,'PaperSize');
    ppsz_pdf = get(f, 'OuterPosition');
    set(f, 'Units', 'Normalized');
 %----------------------
    if app.CategorizedButton.Value == 1
        temppath = string(ppath)+"\SavedFigures\PrecipitationDifferenceMaps";
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
%-----------------------------------------------
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
    fn_map = sprintf("%sMeanAnnualPrecipitationDifference_%s",map_path,tp);
    if ismac
        fn_map = strrep(fn_map,'\','/');
    end
%-----------------------------------------------
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
%-----------------------------------------------
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
%-----------------------------------------------
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
%-----------------------------------------------
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