function [] = app_FUNC_MapMaker2(app,LAT,LONG,P,ind_typ,str_plttyp,plt_xt,stat,ice_loc,smpl,TPi,TPn,at,L,K,Ui,fp,tt)
    [latFIG,longFIG,rtio] = app_FUNC_figureratio(app); % function to apply an appropriate aspect ratio to the figure
    app_FUNC_mapaxesmaker(app,latFIG,longFIG,rtio); % creat map axes
    scb = plt_xt(5); % swtich to default fix colorbar or adaptable
%% ---------------------------------------------------------- % main part of the map
    if ind_typ == 1
        [initial_labels,tlab] = FUNC_mapRT(P,LAT,LONG,Ui,at,tt,scb);
    elseif ind_typ == 2 || ind_typ == 5
        [initial_labels,tlab] = FUNC_mapRECE(P,LAT,LONG,Ui,scb);
    elseif ind_typ == 3 || ind_typ == 4 || ind_typ == 6 || ind_typ == 7     
        [initial_labels,tlab] = FUNC_mapRECE_UiPK(P,LAT,LONG,Ui,scb);
    elseif ind_typ == 8    
        [initial_labels,tlab] = FUNC_mapKPT(P,LAT,LONG,Ui,scb);
    end
    set(gca,'outerposition',[0 0.15 0.9 0.8]);
    cb = colorbar('Ticks',initial_labels,'TickLabels',tlab,'fontsize',11,'FontWeight','bold');
    set(cb,'position', [0.894118365187713 0.213989304812834 0.0218 0.713818181818182]);
    label = cb.Label;
    label.String =str_plttyp;
    label.FontSize = 12;
    label.FontWeight = 'bold';
    %---------------------------------------------------------- BIG BOX AT THE BOTTOM
    annotation('textbox',[0.00300000000000002 0.00505251642784568 0.994588424437299 0.176765665390336],'FontSize',12,'FitBoxToText','off',...
        'EdgeColor',[0 0 0],...
        'BackgroundColor',[1 1 1]);

%% ---------------------------------------------------------- % Extra info on the map
    if plt_xt(1)==1 % add country borders
        Borders = app.brdrs;
        plotm(Borders(1,:),Borders(2,:),'k') %plot borders
    end
   %----------------------------------------------------------
     txtall = {''};
   %---------------------------------------------------------- add ice LGM ice cover
    if plt_xt(4) == 1 % add LGM ice sheet location
        plotm(ice_loc(:,1),ice_loc(:,2),'+','color',[0.8 0.8 0.8],'MarkerSize',1.5) %plot LGM ice sheet
        txtall{end+1} = ['{\color[rgb]{0.3 0.3 0.3}+ \color[{black}LGM ice cover}'];
    end
    %---------------------------------------------------------- add cosmo sample points
    if plt_xt(3) == 1 % add cosmo sample points
        if ind_typ == 1 % two colors sample points for response time maps
            smpl1 = find(smpl(:,3)<smpl(:,7));
            smpl1 = smpl(smpl1,:); % where the samples have smaller value compare to the model values at that point
            smpl2 = find(smpl(:,3)>=smpl(:,7));
            smpl2 = smpl(smpl2,:); % where the samples have bigger value compare to the model values at that point
            if ~isempty(smpl1)
                plotm(smpl1(:,1),smpl1(:,2),'.','MarkerEdgeColor',[1 0.7 0],'MarkerSize',15)
            end
            if ~isempty(smpl2)
                plotm(smpl2(:,1),smpl2(:,2),'.','MarkerEdgeColor','y','MarkerSize',15)
            end
            txtall{end+1} = ['{\color[rgb]{1 0.7 0}\bullet \color{black}cosmo sample t < model t}'];
            txtall{end+1} = ['{\color{yellow}\bullet \color{black}cosmo sample t >= model t}'];
        else % one color sample points for other type of maps
            plotm(smpl(:,1),smpl(:,2),'.','MarkerEdgeColor',[0 0.7 0],'MarkerSize',15);
            txtall{end+1} = ['{\color[rgb]{0 0.4 0}\bullet \color{black}cosmo sample}'];
        end
    end
    %---------------------------------------------------------- add statistic legend to the legend
    if plt_xt(2) == 1
         txtall{end+1} = ['{\color{red}*Points whith a jump and decay in erosion rate\newline\color{blue}*Points whith a drop and growth in erosion rate}'];
    end
    txtall(1) = [];
%% ---------------------------------------------------------- % Strings on the map
    ttl_at = ["peak of the river erosion rate","peak of the cosmogenic erosion rate",string(round(tt,0))+" [kyr]","end of the model (500 [kyr] or earlier)",...
    "10% of river erosion rate relative to Ui","20% of river erosion rate relative to Ui","30% of river erosion rate relative to Ui",...
    "40% of river erosion rate relative to Ui","50% of river erosion rate relative to Ui",...
    "10% of the river erosion rate relative to the peak","20% of the river erosion rate relative to the peak",...
    "30% of the river erosion rate relative to the peak","40% of the river erosion rate relative to the peak",...
    "50% of the river erosion rate relative to the peak",...
    "10% of cosmogenic erosion rate relative to Ui before the peak","20% of cosmogenic erosion rate relative to Ui before the peak",...
    "30% of cosmogenic erosion rate relative to Ui before the peak","40% of cosmogenic erosion rate relative to Ui before the peak",...
    "50% of cosmogenic erosion rate relative to Ui before the peak",...
    "10% of cosmogenic erosion rate relative to Ui after the peak", "20% of cosmogenic erosion rate relative to Ui after the peak",...
    "30% of cosmogenic erosion rate relative to Ui after the peak","40% of cosmogenic erosion rate relative to Ui after the peak",...
    "50% of cosmogenic erosion rate relative to Ui after the peak",...
    "10% of cosmogenic erosion rate relative to the peak before the peak","20 of cosmogenic erosion rate relative to the peak before the peak",...
    "30% of cosmogenic erosion rate relative to the peak before the peak","40% of cosmogenic erosion rate relative to the peak before the peak",...
    "50% of cosmogenic erosion rate relative to the peak before the peak",...
    "10% of cosmogenic erosion rate relative to the peak after the peak","20% of cosmogenic erosion rate relative to the peak after the peak",...
    "30% of cosmogenic erosion rate relative to the peak after the peak","40% of cosmogenic erosion rate relative to the peak after the peak",...
    "50% of cosmogenic erosion rate relative to the peak after the peak"];
    if ind_typ == 1
        ttl_at(3) = "reached to new steady state (before " + string(round(tt,0))+" [kyr])";
        ttl_at(4) = "reached to new steady state (before 500 [kyr])";
    end
   %---------------------------------------------------------- add title
   title(sprintf("%s\n@ %s",str_plttyp,ttl_at(at)),'fontsize',14,'FontWeight','bold')
   %---------------------------------------------------------- add river parameters
    rvrparam = sprintf("%s - %s (L:%.0f [km], K:%.0e [(m.yr)^{-0.5}], Ui:%.2f [mm/yr])",TPi,TPn,L,K,Ui);
    annotation('textbox',[0.00380385852090027 0.957493067116206 0.290192917636162 0.0387984973393632],'String',rvrparam,'FitBoxToText','on',...
    'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',12,'FontWeight','bold');
   %----------------------------------------------------------    add statistic values
    if plt_xt(2) == 1
        tmp = find(~isnan(stat));
        stat(tmp) = round(stat(tmp),3);
        tmp = find(isnan(stat));
        stat = string(stat);
        stat(tmp) = "----";
        stattxt{1} = ['{\color{black}Erosion rate\newlinePoints [#]\newlineMean\newlineS.D.\newlineMdn.\newline\color{red}Max. \color{black}& \color{blue}Min. \color{black}}'];
        stattxt{2} = ['{\color{red}Decr.*\newline'+stat(13)+'\newline'+stat(4)+... % statistic values of the positive points
                                '\newline'+stat(5)+'\newline'+...
                                stat(6)+'\newline'+stat(7)+'}'];
        stattxt{3} = ['{\color{blue}Incr.*\newline'+stat(14)+'\newline'+stat(8)+... % statistic values of the negative points
                                '\newline'+stat(9)+'\newline'+...
                                stat(10)+'\newline'+stat(11)+'}'];
        stattxt{4} = ['{\color{black}Overall\newline'+stat(12)+'\newline'+stat(1)+... % statistic values of the all points
                                '\newline'+stat(2)+'\newline'+stat(3)+'\newline'+stat(16)+' & '+stat(15)+'}'];                
        annotation('textbox',[0.683368941979524 0.0145647143979259 0.0827645029071655 0.156417108036299],'String',stattxt{1},'FitBoxToText','on',...
        'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',10);        
        annotation('textbox',[0.774162457337885 0.0145647143979259 0.0503412956823261 0.156417108036299],'String',stattxt{2},'FitBoxToText','on',...
        'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',10);   
        annotation('textbox',[0.833023549488056 0.0145647143979259 0.0477815687961546 0.156417108036299],'String',stattxt{3},'FitBoxToText','on',...
        'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',10);   
        annotation('textbox',[0.884684641638225 0.0145647143979259 0.0895904412702896 0.156417108036299],'String',stattxt{4},'FitBoxToText','on',...
        'EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1],'interpreter','tex','fontsize',10);                        
    end
   %---------------------------------------------------------- add legend
   if plt_xt(2) == 1 || plt_xt(3) == 1 || plt_xt(4) == 1
        annotation('textbox',[0.00935972696245729 0.064433692588717 0.255119446576049 0.105614970512887],'String',txtall,'FitBoxToText','on',...
        'EdgeColor',[0.8 0.8 0.8], 'BackgroundColor',[0.8 0.8 0.8],'interpreter','tex','fontsize',10);
   end
%    %---------------------------------------------------------- add folder path
    annotation('textbox',[0.00370509092106273 0.00645759523862835 0.350255962512091 0.0307486625836495],...
        'String',{fp},'fontsize',7,'FitBoxToText','on','interpreter','none','EdgeColor',[1 1 1], 'BackgroundColor',[1 1 1]);
end
%% ---------------------------------------------------------- RT
function [initial_labels,tlab] = FUNC_mapRT(P,LAT,LONG,Ui,at,tt,scb)
    Pmin = nanmin(nanmin(P));
    Pmax = nanmax(nanmax(P));
    if at == 3 && tt <= 500 % response time colorbar @ Tn when it is less than 500ky
%         spacing = app_FUNC_colobarspacing(P,0.1,Pmin,tt,10); % make spacing for colorbar
        spacing = linspace(0,tt,10);
        target_labels = [spacing spacing(end) + (spacing(end)-spacing(end-1))];
        target_labels = app_FUNC_roundvalues(target_labels);
        for i = 1:length(target_labels)-1
            if i == length(target_labels)-1
                P(P>=target_labels(i)&P<=10000) = i+10000;
            else
                P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
            end
        end       
        surfm(LAT,LONG,P)
        initial_labels = 1+10000:length(target_labels)+10000;
        contourcmap('cool',initial_labels)
        map = colormap;
        map(end,:) = [0.6 0.6 0.6];
        caxis([initial_labels(1) initial_labels(end)])
        colormap(map)
        tlab = {string(target_labels)};
        tlab = tlab{1};
        tlab(end-1) = string(target_labels(end-1));
        tlab(end) = "\uparrow";
    else % response time colorbar
        if scb == 0 %fixed response time colorbar (always till 500ky)
            target_labels = [0 1 5 10 20 30 50 75 100 150 200 250 300 400 500 525];
            for i = 1:length(target_labels)-1
                if i == length(target_labels)-1
                    P(P>=target_labels(i)&P<=10000) = i+10000;
                else
                    P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
                end
            end       
            surfm(LAT,LONG,P)
            initial_labels = 1+10000:length(target_labels)+10000;
            contourcmap('cool',initial_labels)
            map = colormap;
            map(end,:) = [0.6 0.6 0.6];
            caxis([initial_labels(1) initial_labels(end)])
            colormap(map)
            tlab = {string(target_labels)};
            tlab = tlab{1};
            tlab(end-1) = string(target_labels(end-1));
            tlab(end) = "\uparrow";
        else % adaptable response time colorbar (depends on the max and min of the figure)
            spacing = app_FUNC_colobarspacing(P,0.1,Pmin,Pmax,10);
%             spacing = linspace(Pmin,Pmax,11);
            if Pmax == 500
                target_labels = [spacing spacing(end) + (spacing(end)-spacing(end-1))];
            else
                target_labels = spacing;
            end
            target_labels = app_FUNC_roundvalues(target_labels);
            for i = 1:length(target_labels)-1
                if i == length(target_labels)-1
                    P(P>=target_labels(i)&P<=10000) = i+10000;
                else
                    P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
                end
            end       
            surfm(LAT,LONG,P)
            initial_labels = 1+10000:length(target_labels)+10000;
            contourcmap('cool',initial_labels)
            map = colormap;
            if Pmax == 500
                map(end,:) = [0.6 0.6 0.6];
                caxis([initial_labels(1) initial_labels(end)])
                colormap(map)
                tlab = {string(target_labels)};
                tlab = tlab{1};
                tlab(end-1) = string(target_labels(end-1));
                tlab(end) = "\uparrow";
            else
                caxis([initial_labels(1) initial_labels(end)])
                colormap(map)
                tlab = {string(target_labels)};
                tlab = tlab{1};
            end
        end
    end
end
%% ---------------------------------------------------------- RE & CE
function [initial_labels,tlab] = FUNC_mapRECE(P,LAT,LONG,Ui,scb)
    Pmin = nanmin(nanmin(P));
    Pmax = nanmax(nanmax(P));
%     if scb == 0 % fixed colorbar
        tmp1 = linspace(0,Ui,7);
        tmp1(end) = Ui-(1e-3);
        tmp2 = linspace(Ui,(Ui*2),7);
        tmp2(1) = Ui+(1e-3);
        tmp2(end+1) = tmp2(end) + (tmp2(end)-tmp2(end-1));
        target_labels = [tmp1 Ui tmp2];
        for i = 1:length(target_labels)-1
            if i == length(target_labels)-1
                P(P>=target_labels(i)&P<=10000) = i+10000;
            else
                P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
            end
        end
        surfm(LAT,LONG,P)
        initial_labels = 1+10000:length(target_labels)+10000;        
        contourcmap('jet',initial_labels)
        clrs = redblue(length(target_labels)-1);
        clrs(7,:) = [0.6 0.6 0.6];
        clrs(8,:) = [0.6 0.6 0.6];
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        tlab = {string(round(target_labels,3))};
        tlab = tlab{1};
        tlab(7) = string(Ui-(1e-3));
        tlab(8) = "Ui = " + string(Ui);
        tlab(9) = string(Ui+(1e-3)); 
        tlab(end-1) = string(target_labels(end-1));
        tlab(end) = "\uparrow";
%     else % adaptable colorbar
%         spacing = app_FUNC_colobarspacing(P,0.00001,Pmin,Pmax,10);
% %         spacing = linspace(Pmin,Pmax,11);
%         target_labels = unique(round(spacing,3));
% %         target_labels = app_FUNC_roundvalues(target_labels);
%         for i = 1:length(target_labels)-1
%             if i == length(target_labels)-1
%                 P(P>=target_labels(i)&P<=10000) = i+10000;
%             else
%                 P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
%             end
%         end
%         surfm(LAT,LONG,P)
%         initial_labels = 1+10000:length(target_labels)+10000;
%         contourcmap('jet')
%         clrs = redblue(length(target_labels));
%         clrs((clrs(:,1)==1 & clrs(:,2)==1 & clrs(:,3)==1),:) = [];  
%         caxis([initial_labels(1) initial_labels(end)])
%         colormap(clrs)
%         tlab = {string(target_labels)};
%         tlab = tlab{1};
%     end
end
%% ---------------------------------------------------------- RE(Ui) & RE(Peak) & CE(Ui) & CE(Peak)
function [initial_labels,tlab] = FUNC_mapRECE_UiPK(P,LAT,LONG,Ui,scb)
    P = round(P,0);
    A = unique(P);
    A(isnan(A)) = [];
    if length(A) >0 && length(A) <=2 % only the case with two values (positive and negative of a same value)
        target_labels = [A];
        P(P==A(1)) = 10002;
        P(P==A(2)) = 10004;
        surfm(LAT,LONG,P)
        initial_labels = 10001:10005;
        contourcmap('jet',initial_labels)
        clrs = [0 0 1;0 0 1 ; 1 0 0; 1 0 0];
        caxis([initial_labels(1) initial_labels(end)])
        colormap(clrs)
        tlab = {[" ";string(target_labels(1));" ";string(target_labels(2));" "]};
        tlab = tlab{1};
    else % for normal case
        Pmin = nanmin(nanmin(P));
        Pmax = nanmax(nanmax(P));
%         if scb == 0 % fixed colorbar
            target_labels = [-110 -100 -50 -40 -30 -20 -10 -1 1 10 20 30 40 50 100 110];
            P(P>=target_labels(end-1)) = length(target_labels)+10000;
            P(P>=target_labels(9)&P<target_labels(10)) = 10009;
            P(P>=target_labels(7)&P<=target_labels(8)) = 10007;
            P(P>target_labels(8)&P<target_labels(9)) = 10008;
            for i = 1:length(target_labels)-1
                if (i ~= 10007) && (i ~= 10008) && (i ~= 10009)
                    P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
                end
            end
            surfm(LAT,LONG,P)
            initial_labels = 1+10000:length(target_labels)+10000;
            contourcmap('jet',initial_labels)
            clrs = redblue(length(target_labels)-1);
            clrs(8,:) = [0.6 0.6 0.6];
            caxis([initial_labels(1) initial_labels(end)])
            colormap(clrs)
            tlab = {string(target_labels)};
            tlab = tlab{1};
            tlab(1) = "\downarrow";
            tlab(2) = string(target_labels(2));
            tlab(end-1) = string(target_labels(end-1));
            tlab(end) = "\uparrow";
%         else % adaptable colorbar
%             spacing = app_FUNC_colobarspacing(P,0.01,Pmin,Pmax,10);
%             target_labels = spacing;
%             target_labels = app_FUNC_roundvalues(target_labels);
%             for i = 1:length(target_labels)-1
%                 if i == length(target_labels)
%                     P(P>=target_labels(i)&P<=target_labels(i+1)) = i+10000;
%                 else
%                     P(P>=target_labels(i)&P<target_labels(i+1)) = i+10000;
%                 end
%             end
%             surfm(LAT,LONG,P)
%             initial_labels = 1+10000:length(target_labels)+10000;
%             contourcmap('jet',initial_labels)
%             clrs = redblue(length(target_labels)-1);
%             caxis([initial_labels(1) initial_labels(end)])
%             colormap(clrs)
%             tlab = {string(target_labels)};
%             tlab = tlab{1};
%         end
    end
end
%% ---------------------------------------------------------- KPT
function [initial_labels,tlab] = FUNC_mapKPT(P,LAT,LONG,Ui,scb)
%     if scb == 0 
        surfm(LAT,LONG,P)
        target_labels = 0:10:100;
        initial_labels = 0:10:100;
        tlab = {string(target_labels)};
        tlab = tlab{1};
        contourcmap('cool',initial_labels)
%     else
%         Pmin = nanmin(nanmin(P));
%         Pmax = nanmax(nanmax(P));
%         surfm(LAT,LONG,P)
%         spacing = app_FUNC_colobarspacing(P,0.01,Pmin,Pmax,10);
%         target_labels = spacing;
%         target_labels = app_FUNC_roundvalues(target_labels);
%         tlab = {string(target_labels)};
%         tlab = tlab{1};
%         contourcmap('cool',target_labels)
%     end
end