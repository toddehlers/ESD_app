function [] = app_FUNC_MapMaker1(app,selected_data,plt_type,plt_at,plt_xt,ppath,wb,N_wb)
    %% lat,long
    % here we load lat and long of all the available points
    LLA = app.LatLongAlt;
    lat = LLA(:,1);
    long= LLA(:,2);
    %----------------------------------------------- apply the given coordinate
    lat_unq = unique(lat);
    long_unq = unique(long);
    [~,nlat_tmpB] = min(abs(app.LBlat.Value - lat_unq));
    [~,nlat_tmpT] = min(abs(app.TRlat.Value - lat_unq));
    [~,nlong_tmpL] = min(abs(app.LBlong.Value - long_unq));
    [~,nlong_tmpR] = min(abs(app.TRlong.Value - long_unq));
    [LAT,LONG] = meshgrid(lat_unq(nlat_tmpB:nlat_tmpT),long_unq(nlong_tmpL:nlong_tmpR));
    %-----------------------------------------------
    P = NaN(size(LAT));
    j = 1;
    ind_mesh = zeros(length(lat),2);
    for k = 1:length(lat)
        ind_tmp = find(LAT == lat(k) & LONG == long(k));
        if not(isempty(ind_tmp))
            ind_mesh(j,1) = ind_tmp;
            ind_mesh(j,2) = k;
            j = j+1;
        end
    end
    ind_mesh(ind_mesh(:,1) == 0 , :) = [];
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
    %%
    for i = 1:size(selected_data,1)
        FUNC_map...
            (app,selected_data(i,:),plt_type,plt_at,plt_xt,LAT,LONG,P,ind_mesh,ice_loc,smpl,a3,ppath,wb,N_wb);
        N_wb(end-1) = N_wb(end-1) +(N_wb(1)/size(selected_data,1));
    end
end
%%
function FUNC_map...
    (app,selected_data,plt_type,plt_at,plt_xt,LAT,LONG,P,ind_mesh,ice_loc,smpl,a3,ppath,wb,N_wb)

    dta = load(selected_data{6});   
    dta = dta.BriefOP;
    fp = string(selected_data{7});
    TPi = string(selected_data{1});
    TPn = string(selected_data{2});
    L = str2num(selected_data{3});
    Ui = str2num(selected_data{4});
    K = str2num(selected_data{5});
    RT = dta(:,8:41)/1000;
    tt = unique(RT(:,3));
    RE = dta(:,42:75); 
    RE_Ui = dta(:,76:109); 
    RE_Peak = dta(:,110:143); 
    CE = dta(:,144:177);
    CE_Ui = dta(:,178:211);
    CE_Peak = dta(:,212:245);
    KPT = dta(:,246:279);
%----------------------------------------------------- 
%% data modification is necessary
    tmp1 = find(isnan(RE(:,3))); % if it couldn't reach to (tt)
    RE(tmp1,3) = RE(tmp1,4); % then it already reached to (EQ) so the value is same as value at the end
    RE_Ui(tmp1,3) = RE_Ui(tmp1,4);
    RE_Peak(tmp1,3) = RE_Peak(tmp1,4);
    tmp2 = [10 20 30 40 50];
    for ii = 1:length(tmp2)
        % if the maximum change relative to Ui is bigger than a value (e.g. 50%), then it
        % needs more time than end of the model (500 kyr) to reach to it
        RT((isnan(RT(:,ii+4)) & abs(RE_Ui(:,1)) > tmp2(ii)),ii+4) = 500;
        RT((isnan(RT(:,ii+19)) & abs(CE_Ui(:,2)) > tmp2(ii)),ii+19) = 500;
        % if the final change relative to Max is smaller than a value (e.g. 50%), then it
        % needs more time than end of the model (500 kyr) to reach to it
        RT((isnan(RT(:,ii+9)) & abs(RE_Peak(:,4)) < tmp2(ii)),ii+9) = 500;
        RT((isnan(RT(:,ii+29)) & abs(CE_Peak(:,4)) < tmp2(ii)),ii+29) = 500;

        RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+4)))      &     (abs(RE_Ui(:,1)) > tmp2(ii))     ,ii+4) = 500;
        RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+19)))      &     (abs(CE_Ui(:,2)) > tmp2(ii))     ,ii+19) = 500;
        RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+9)))      &     (abs(RE_Ui(:,end)) < tmp2(ii))     ,ii+4) = 500;
        RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+29)))      &     (abs(CE_Ui(:,end)) < tmp2(ii))     ,ii+19) = 500;
    end
    RT(:,3) = RT(:,4);
%%
%----------------------------------------------------- 
    ix = plt_at;
    for j = 1:length(plt_type)
        ind_typ = plt_type(j);
        [DATA,str_plttyp] = FUNC_plttype(ind_typ,RT,RE_Ui,RE_Peak,RE,CE_Ui,CE_Peak,CE,KPT); % plot type (data)
        for i = 1:length(ix)
            at = ix(i); % plot @ what point
            [~,~,rtio] = app_FUNC_figureratio(app); % get the lat/lon ratio 
            f = app_FUNC_setthefiguresize(app,rtio); % generate a figure
%----------------------------------------------------- put data in a mtrix
            data = DATA(:,at);
            ndata = data(ind_mesh(:,2));
            P(ind_mesh(:,1)) = ndata;
%----------------------------------------------------- pick locations with sample
            if plt_xt(3) == 1
%                 a3( a3>(max(ind_mesh(:,2))) | a3<(min(ind_mesh(:,2))) ) = [];
                smpl(:,7) = data(a3);
            end
%----------------------------------------------------- statistic values
            if plt_xt(2) == 1
                stat = somestatistic(RE_Ui(ind_mesh(:,2),1),ndata);
            else
                stat = [];
            end
%----------------------------------------------------- run the map
            app_FUNC_MapMaker2(app,LAT,LONG,P,ind_typ,str_plttyp,plt_xt,stat,ice_loc,smpl,TPi,TPn,at,L,K,Ui,fp,tt);
            set(gca,'PlotBoxAspectRatioMode','manual');
            set(gca,'PlotBoxAspectRatio',[1/rtio  1  1]);
%----------------------------------------------------- save the map
            if app.SAVECheckBox.Value == 1
                FUNC_savemap(app,TPi,TPn,L,K,Ui,ind_typ,str_plttyp,at,tt,f,ppath)
            end
            N_wb(end-1) = N_wb(end-1) + 1;
            prc = (N_wb(end-1)/N_wb(end));
            app_FUNC_waitbar(wb,prc,char("Erosion Maps... " + string(round(prc*100,1)) + " %"))
        end
        if app.PLOTCheckBox.Value == 0
            close(f)
        end
    end
end
%% save map
function [] = FUNC_savemap(app,TPi,TPn,L,K,Ui,ind_typ,str_plttyp,at,tt,f,ppath)
    set(f,'PaperUnits','centimeters');
    set(f, 'Units', 'centimeters');
    ppsz_org = get(f,'PaperSize');
    ppsz_pdf = get(f, 'OuterPosition');
    set(f, 'Units', 'Normalized');
%-----------------------------------------------
    folder_at = ["General","RiverErosionRelativeTo(Ui)","RiverErosionRelativeTo(Peak)",...
                         "CosmoErosionRelativeTo(Ui)BeforePeak","CosmoErosionRelativeTo(Peak)BeforePeak",...
                         "CosmoErosionRelativeTo(Ui)AfterPeak","CosmoErosionRelativeTo(Peak)AfterPeak"];
    file_at = ["PeakRE","PeakCE",string(tt)+"[kyr]","End",...
    "50%RE(Ui)","40%RE(Ui)","30%RE(Ui)","20%RE(Ui)","10%RE(Ui)",...
    "10%RE(Peak)","20%RE(Peak)","30%RE(Peak)","40%RE(Peak)","50%RE(Peak)",...
    "10%CE(Ui)BP","20%CE(Ui)BP","30%CE(Ui)BP","40%CE(Ui)BP","50%CE(Ui)BP",...
    "50%CE(Peak)BP", "40%CE(Peak)BP","30%CE(Peak)BP","20%CE(Peak)BP","10%CE(Peak)BP",...
    "50%CE(Ui)AP","40%CE(Ui)AP","30%CE(Ui)AP","20%CE(Ui)AP","10%CE(Ui)AP",...
    "10%CE(Peak)AP","20%CE(Peak)AP","30%CE(Peak)AP","40%CE(Peak)AP","50%CE(Peak)AP"];
    if ind_typ == 1
        file_at(4) = "N.S.S.";
    end
    fl_nm1 = ["R.T.","R.E","R.E.Ui.","R.E.Peak.","C.E","C.E.Ui.","C.E.Peak","KPT."];
    if at <= 4
        fld_nm =  folder_at(1);
    elseif at >= 5 && at <= 9
        fld_nm =  folder_at(2);
    elseif at >= 10 && at <= 14
        fld_nm =  folder_at(3);
    elseif at >= 15 && at <= 19
        fld_nm =  folder_at(4);
    elseif at >= 20 && at <= 24
        fld_nm =  folder_at(5);
    elseif at >= 25 && at <= 29
        fld_nm =  folder_at(6);
    elseif at >= 30 && at <= 34
        fld_nm =  folder_at(7);
    end
%-----------------------------------------------
    if app.CategorizedButton.Value == 1
        temppath = string(ppath)+"\SavedFigures\ErosionMaps\"+TPi+"_"+TPn+"\"...
                         +num2str(L,'%.d')+"_"+num2str(Ui,'%.2f')+"_"+num2str(K,'%.0e')+"\"...
                         +str_plttyp+"\"+fld_nm;
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
    % make the map file name
    fil_nm = fl_nm1(ind_typ)+"@"+file_at(at);
    fn_map = sprintf("%s%s_(%s_%s)_(%d_%.2f_%.0e)",map_path,fil_nm,TPi,TPn,L,Ui,K);
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
                    fn_map = char(fn_map);
                    fn_map = string(fn_map(1:a(end)-1));
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
        print(f,char(fn_map+".pdf"),'-dpdf','-r600','-painters','-fillpage') % save the figure as SVG (Scalable Vector Graphics)
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
        print(f,char(fn_map+".bmp"),'-dbmp16m','-r600') % save the figure as SVG (Scalable Vector Graphics)
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
        print(f,char(fn_map+".svg"),'-dsvg','-r600','-painters') % save the figure as SVG (Scalable Vector Graphics)
    end
%-----------------------------------------------
end
%% Statistic
function [stat] = somestatistic(RE_Ui,input_data)
    ind_pos = find(RE_Ui > 0); % find all the points with + sign in erosion change (Erosion rate decreases after a jump)
    ind_neg = find(RE_Ui < 0); % find all the points with - sign in erosion change (Erosion rate increases after a drop)
    mean_tot = nanmean(input_data);
    std_tot = nanstd(input_data);
    med_tot = nanmedian(input_data);

    min_tot = nanmin(input_data);
    max_tot = nanmax(input_data);

    mean_pos = nanmean(input_data(ind_pos));
    std_pos = nanstd(input_data(ind_pos));
    med_pos = nanmedian(input_data(ind_pos));
    max_pos = nanmax(input_data(ind_pos));
    mean_neg = nanmean(input_data(ind_neg));
    std_neg = nanstd(input_data(ind_neg));
    med_neg = nanmedian(input_data(ind_neg));
    min_neg = nanmin(input_data(ind_neg));
    stat = [mean_tot std_tot med_tot mean_pos std_pos med_pos max_pos mean_neg std_neg med_neg min_neg length(input_data) length(ind_pos) length(ind_neg) min_tot max_tot];
end
%% PlotType
function [DATA,str_plttyp] = FUNC_plttype(plt_type,RT,RE_Ui,RE_Peak,RE,CE_Ui,CE_Peak,CE,KPT)
    PLT_TYPE = ["Response Time [kyr]",...
                      "Mean Catchment River Erosion Rate [mm/yr]",...
                      "Change In Mean Catchment River Erosion Rate Relative To Ui [%]",...
                      "Change In Mean Catchment River Erosion Rate Relative To Peak [%]",...
                      "Mean Catchment Cosmogenic Erosion Rate [mm/yr]",...
                      "Change In Mean Catchment Cosmogenic Erosion Rate Relative To Ui [%]",...
                      "Change In Mean Catchment Cosmogenic Erosion Rate Relative To Peak [%]",...
                      "Lateral Shift In Knick Point Position [%]"];
    if plt_type == 1
        DATA = RT;
        str_plttyp = PLT_TYPE(1);
    elseif plt_type == 2
        DATA = RE;
        str_plttyp = PLT_TYPE(2);
    elseif plt_type == 3
        DATA = RE_Ui;
        str_plttyp = PLT_TYPE(3);
    elseif plt_type == 4
        DATA = RE_Peak;
        str_plttyp = PLT_TYPE(4);
    elseif plt_type == 5     
        DATA = CE; 
        str_plttyp = PLT_TYPE(5);
    elseif plt_type == 6
        DATA = CE_Ui;
        str_plttyp = PLT_TYPE(6);
    elseif plt_type == 7
        DATA = CE_Peak; 
        str_plttyp = PLT_TYPE(7);
    elseif plt_type == 8    
        DATA = KPT; 
        str_plttyp = PLT_TYPE(8);
    end  
end