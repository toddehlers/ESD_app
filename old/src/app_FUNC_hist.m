function [] = app_FUNC_hist(app,ppath,wb,N_wb)
% this function makes histogram of:
%1- calculated response time at peak of cosmo erosin rate / observed response time
%2- pick of the river erosion rate / pick of the cosmo erosion rate

    %---------- load the pixel coordinates
    LLA = app.LatLongAlt;
    lat = LLA(:,1);
    long= LLA(:,2);
    %---------- limit the coordinate to selected area and find the sample
    %points which are located in the selected area
    latLB = app.LBlat.Value;
    latRT = app.TRlat.Value;
    longLB = app.LBlong.Value;
    longRT = app.TRlong.Value;
    indData = lat >= latLB & lat <= latRT & long >= longLB & long <= longRT;
    smpl = app.SMPL; % load sample points xls sheet
    a3 = app.A3; % read the closest pixel to the sample points
    a3_area = smpl(:,1) >= latLB & smpl(:,1) <= latRT & smpl(:,2)>= longLB & smpl(:,2) <= longRT;
    Nsmpl = smpl(a3_area,:);
    a3n = a3(a3_area);
    %---------- load selected data files
    selected_data = app.InputData ;
    %---------- plot the histograms one by one for each selected data
    for i = 1:size(selected_data,1)
        %---------- pick the parameters we need from the selected data
        [RT,RE,CE,Ui,L,K,TPi,TPn,fp] = FUNC_data(app,selected_data(i,:),indData,a3n);
        %-------------------- RT histogram
        if app.hist1.Value == 1
            [~,~,rtio] = app_FUNC_figureratio(app); % figure aspect ratio
            f = app_FUNC_setthefiguresize(app,rtio); % generate a figure
            hist_RT(app,RT,2,Nsmpl,Ui,L,K,TPi,TPn,fp); % RT histogram function (in this script)
            %---------- save
            if app.SAVECheckBox.Value == 1
                FUNC_savehist(app,TPi,TPn,L,K,Ui,f,ppath,"ResponseTime_hist") % save histogram function (in this script)
            end
            %---------- update waitbar
            N_wb(end-1) = N_wb(end-1) + 1;
            prc = (N_wb(end-1)/N_wb(end));
            app_FUNC_waitbar(wb,prc,char("Plot histograms... " + string(round(prc*100,1)) + " %"))
            %---------- close the figure if plot checkbox is not selected
            if app.PLOTCheckBox.Value == 0
                close(f)
            end
        end
         %-------------------- Ui histogram
        if app.hist2.Value == 1
            [~,~,rtio] = app_FUNC_figureratio(app); % figure aspect ratio
            f = app_FUNC_setthefiguresize(app,rtio); % generate a figure
            hist_ReCe(app,RE(:,1),CE(:,2),Ui,L,K,TPi,TPn,fp); % Erosion rate histogram function (in this script)
            %---------- save
            if app.SAVECheckBox.Value == 1
                FUNC_savehist(app,TPi,TPn,L,K,Ui,f,ppath,"Erosion_hist") % save histogram function (in this script)
            end
            %---------- update waitbar
            N_wb(end-1) = N_wb(end-1) + 1;
            prc = (N_wb(end-1)/N_wb(end));
            app_FUNC_waitbar(wb,prc,char("Plot histograms... " + string(round(prc*100,1)) + " %"))
            %---------- close the figure if plot checkbox is not selected
            if app.PLOTCheckBox.Value == 0
                close(f)
            end
        end
    end % end forloop
end % end function
%% Histogram of RT
function hist_RT(app,RT,at,Nsmpl,Ui,L,K,TPi,TPn,fp)
    % this function make a histogram of the ratio of calculated RT / observed RT
    data = RT(:,at); % select second column of RT (response time at the pick of cosmo erosion rate)
    Nsmpl(:,7) = data; % add RT to last column of sample points
    smpl_500 = Nsmpl(:,7) >= 500; % find the RT >= 500 ky
    r_mod_obs(:,1) = Nsmpl(:,7); % calculated RT
    r_mod_obs(:,2) = Nsmpl(:,3); % observed RT
    r_mod_obs(smpl_500,:) = []; % remove all the points with RT >= 500 ky
    r_mod_obs(:,3) = r_mod_obs(:,1)./r_mod_obs(:,2); % make the ratio of calculated RT / Observed

    h = histogram(r_mod_obs(:,3),[0:0.05:2]); % plot the histogram
    %---------- calculate some info from the histogram
    st = length(r_mod_obs);
    s1 = sum(r_mod_obs(:,3)<1);
    s2 = sum(r_mod_obs(:,3)==1);
    s3 = sum(r_mod_obs(:,3)>1 & r_mod_obs(:,3)<=2);
    s4 = sum(r_mod_obs(:,3)>2 & r_mod_obs(:,3)<=10);
    s5 = sum(r_mod_obs(:,3)>10);
    hold on
    %---------- vertical red line at x = 1
    plot([1 1],[0 max(h.Values)+(0.1*max(h.Values))],'r','linewidth',2)
    hold off
    %------ axis modification
    ylim([0 max(h.Values)+(0.1*max(h.Values))])
    xlim([0 2])
    title('Calculated response time @ peak of cosmogenic erosion rate  / observed response time','fontsize',14,'FontWeight','bold')
    xlabel('RT@Peak CE / Observed RT','fontsize',14,'FontWeight','bold')
    ylabel('Number of pixels','fontsize',14,'FontWeight','bold')
    yticklabels({yticks})    
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    ax.XAxis.FontWeight = 'bold';
    ax.YAxis.FontWeight = 'bold';
    %---------- show the calculated info as sting on the top right corner of the plot
    annotation('textbox',[0.55586670799752 0.762983951172376 0.317730926859475 0.145420203690714],...
    'String',{'Number of pixels with cosmogenic sample points \rightarrow   '+string(st),...
                  'Number of pixels with ratio smaller than 1 \rightarrow   '+string(s1),...
                  'Number of pixels with ratio equal to 1 \rightarrow   '+string(s2),...
                  'Number of pixels with ratio between 1 and 2 \rightarrow   '+string(s3),...
                  'Number of pixels with ratio between 2 and 10 \rightarrow   '+string(s4),...
                  'Number of pixels with ratio greater than 10 \rightarrow   '+string(s5)},...
                  'FitBoxToText','on','FontSize',14);
    %---------- show the parameters of the selected data as string on top
    %left of the plot
    rvrparam = sprintf("%s - %s (L:%.0f [km], K:%.0e [(m.yr)^{-0.5}], Ui:%.2f [mm/yr])",TPi,TPn,L,K,Ui);
    annotation('textbox',[0.00380385852090027 0.957493067116206 0.290192917636162 0.0387984973393632],'String',rvrparam,'FitBoxToText','on',...
    'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',14,'FontWeight','bold');
    %---------- show the file path of the selected data on bottom left of
    %the plot
    annotation('textbox',[0.00370509092106273 0.00645759523862835 0.350255962512091 0.0307486625836495],...
    'String',{fp},'fontsize',8,'FitBoxToText','on','interpreter','none','EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1]);

% add small box of the whole histogram inside the main figure
%     axes('Position',[.65 .5 .2 .2])
%     box on
%     h = histogram(r_mod_obs(:,3),0:10:round(max(r_mod_obs(:,3)),1)); % plot the histogram
%     xlim([0 round(max(r_mod_obs(:,3)),1)])
%     ylim([0 max(h.Values)+(0.1*max(h.Values))])
%     grid on
end
%% Histogram of erosion
function hist_ReCe(app,RE,CE,Ui,L,K,TPi,TPn,fp)
    % this function make a histogram of the ratio of RE at its own peak / CE at its own pick

    r_RE_CE = [RE,CE]; % new variable with Peak of RE & Peak of CE
    r_RE_CE(:,3) = RE./CE; % add third column as NaN

    h = histogram(r_RE_CE(:,3),[round(min(r_RE_CE(:,3)),2):0.01:round(max(r_RE_CE(:,3)),2)]); % plot the histogram
    hold on
    plot([1 1],[0 max(h.Values)+(0.1*max(h.Values))],'r','linewidth',2) % add a ertical line at 1
    
    %------ statistic values of the histogram (mean,median,standard deviation)
    hist_mean = round(mean(h.BinEdges),2);
    hist_med = round(median(h.BinEdges),2);
    hist_std = round(std(h.BinEdges),2);
    %-------plot the statistic values of the histogram and their name as string
    plot([hist_mean hist_mean],[0 max(h.Values)+(0.05*max(h.Values))],'k','linewidth',3)
    text(hist_mean,max(h.Values)+(0.07*max(h.Values)),"Mean",'fontsize',12)
    plot([hist_med hist_med],[0 max(h.Values)+(0.05*max(h.Values))],'--g','linewidth',1)
    text(hist_med,max(h.Values)+(0.055*max(h.Values)),"Mdn.",'Color',[0 1 0],'fontsize',12)
    plot([hist_mean+hist_std hist_mean+hist_std],[0 max(h.Values)+(0.05*max(h.Values))],'--b','linewidth',1)
    text(hist_mean+hist_std,max(h.Values)+(0.06*max(h.Values)),"Mean + S.D.",'Color',[0 0 1],'fontsize',12)
    plot([hist_mean-hist_std hist_mean-hist_std],[0 max(h.Values)+(0.05*max(h.Values))],'--b','linewidth',1)
    text(hist_mean-hist_std,max(h.Values)+(0.06*max(h.Values)),"Mean - S.D.",'Color',[0 0 1],'fontsize',12)
    %------ axis modification
    xlim([round(min(r_RE_CE(:,3)),2)-0.01 round(max(r_RE_CE(:,3)),2)+0.01])
    ylim([0 max(h.Values)+(0.1*max(h.Values))])
    yticklabels({yticks})
    title('Peak of the mean catchment river erosion rate / Peak of the mean catchment cosmogenic erosion rate','fontsize',14,'FontWeight','bold')
    xlabel('RE@Peak / CE@Peak','fontsize',14,'FontWeight','bold')
    ylabel('Number of pixels','fontsize',14,'FontWeight','bold')
    ax = gca;
    ax.XAxis.FontSize = 14;
    ax.YAxis.FontSize = 14;
    ax.XAxis.FontWeight = 'bold';
    ax.YAxis.FontWeight = 'bold';
    %---------- show the statistics on top left of the plot  
     annotation('textbox',[0.145451332920025 0.830028330638132 0.0740855528435498 0.0774315371616929],...
    'String',{'Mean : '+string(hist_mean),...
                  'Mdn. : '+string(hist_med),...
                  'S.D. : '+string(hist_std)},...
                  'FitBoxToText','on','FontSize',14);   
    %---------- show the parameters of the selected data as string on top
    %left of the plot
    rvrparam = sprintf("%s - %s (L:%.0f [km], K:%.0e [(m.yr)^{-0.5}], Ui:%.2f [mm/yr])",TPi,TPn,L,K,Ui);
    annotation('textbox',[0.00380385852090027 0.957493067116206 0.290192917636162 0.0387984973393632],'String',rvrparam,'FitBoxToText','on',...
    'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',14,'FontWeight','bold');
    %---------- show the file path of the selected data on bottom left of
    %the plot
    annotation('textbox',[0.00370509092106273 0.00645759523862835 0.350255962512091 0.0307486625836495],...
    'String',{fp},'fontsize',8,'FitBoxToText','on','interpreter','none','EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1]);
end
%% read data
function [RTn,REn,CEn,Ui,L,K,TPi,TPn,fp] = FUNC_data(app,selected_data,indData,a3n)
% this function applies some correction on the selected data (BriefData)
% and give the needed histogram parameters as output
    dta = load(selected_data{6});   
    dta = dta.BriefOP;
    Ui = str2num(selected_data{4});
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
    
    RTn = RT(a3n,:);
    REn = RE(indData,:);
    CEn = CE(indData,:);
end
%% save map
function [] = FUNC_savehist(app,TPi,TPn,L,K,Ui,f,ppath,fil_nm)
    set(f,'PaperUnits','centimeters');
    set(f, 'Units', 'centimeters');
    ppsz_org = get(f,'PaperSize');
    ppsz_pdf = get(f, 'OuterPosition');
    set(f, 'Units', 'Normalized');
%-----------------------------------------------
    if app.CategorizedButton.Value == 1
        temppath = string(ppath)+"\SavedFigures\Histograms\"+TPi+"_"+TPn+"\"...
                         +num2str(L,'%.d')+"_"+num2str(Ui,'%.2f')+"_"+num2str(K,'%.0e');
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
        print(f,char(fn_map+".pdf"),'-dpdf','-r600','-painters','-fillpage') % save the figure as PDF
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
        print(f,char(fn_map+".bmp"),'-dbmp16m','-r600') % save the figure as BMP
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