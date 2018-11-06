function [] = app_FUNC_ProfileMaker3(TPi,TPn,L,Ui,K,x,tt,BriefOutput,OUT,FinalTime,FinalRiver,FinalCosmo,FinalKPT,Z,plt_type)
    Npixel = BriefOutput(1);
    lat = BriefOutput(2);
    long = BriefOutput(3);
    alt = BriefOutput(4);
    Pi = BriefOutput(5);
    Pn = BriefOutput(6);
    Tn = BriefOutput(7);
%-------------------------------------------------------------- @ tt and Tn
    indG = [OUT(9,3:4)]; %index
    indG(2,:) = [OUT(1,3:4)]; %time
    indG(3,:) = round([OUT(3,3:4)],0); %percentage Ui
    indG(4,:) = round([OUT(4,3:4)],0); %percentage Peak
    tmp = find(isnan(indG(1,:))); % find if there is a NaN
    indG(:,tmp) = [];  %remove NaN
%-------------------------- RE(UI)
    indUI(1,:) = [OUT(9,5:9)]; %ind
    indUI(2,:) = [OUT(1,5:9)]; %time
    indUI(3,:) = round([OUT(3,5:9)],0); %percentage Ui
    indUI(4,:) = round([OUT(4,5:9)],0); %percentage Peak
    tmp = find(isnan(indUI(1,:)));
    indUI(:,tmp) = [];
%-------------------------- RE(PK)
    indPK(1,:) = [OUT(9,10:14)]; %ind
    indPK(2,:) = [OUT(1,10:14)]; %time
    indPK(3,:) = round([OUT(3,10:14)],0); %percentage Ui
    indPK(4,:) = round([OUT(4,10:14)],0); %percentage Peak
    tmp = find(isnan(indPK(1,:)));
    indPK(:,tmp) = [];
%--------------------------
    indALL = [indG indUI];
    [~,tmp2] = sort(indALL(1,:));
    indALL = indALL(:,tmp2);
%--------------------------------------------------------------
    zALL = Z(indALL(1,:),:);
    kptALL = FinalKPT(1,indALL(1,:)+100);
    for i = 1:size(indALL,2)
        kptALL(2,i) = Z(indALL(1,i),(kptALL(1,i)/(L/1000))+1);
    end
%% Elevation
%--------------------------- Elevations (lines)
% pos1 = [0.05 0.555 0.51 0.415];                  pos2 = [0.61 0.6932 0.34 0.2766];
% pos3 = [0.05 0.06 0.51 0.415];                    pos4_1 = [0.61 0.3766 0.34 0.2766];
%                                                                         pos4_2 = [0.61 0.06 0.34 0.2766];
                                                                        
pos1 = [0.06 0.555 0.492 0.415];                  pos2 = [0.612 0.6932 0.328 0.2766];
pos3 = [0.06 0.06 0.492 0.415];                    pos4_1 = [0.612 0.3766 0.328 0.2766];
                                                                        pos4_2 = [0.612 0.06 0.328 0.2766];                          
                                                                        
    subplot('Position',pos1); % plot the elevation change and knick points locations
    
    avtt = find(indALL(2,:) == tt); % find the tt
    
    plot(x,Z(1,:),"b","Linewidth",2); % plot initial elevation
    lgndtxt{1} = 'Initial elevation';
    hold on

    if not(isempty(avtt))
        plot(x,zALL(avtt,:),"--k","Linewidth",0.75); % plot elevation at tt
        lgndtxt{end+1} = char("Elevation@" + string(indALL(3,avtt)) +"%Ui (" + string(indALL(2,avtt)/1000) +"kyr)");
    end
    
%     if size(indALL,2) > 1
%         for i = 1:size(indALL,2)-1
%             if i == avtt
%                 plot(x,zALL(i,:),"--k","Linewidth",0.75); % plot elevation at tt
%                 lgndtxt{i+1} = char("Elevation@" + string(indALL(3,i)) +"%Ui (" + string(indALL(2,i)/1000) +"kyr)");
%             else
%                 plot(x,zALL(i,:),":","Linewidth",1); % plot elevation at 10,20,30,40,50% of Ui
%                 lgndtxt{i+1} = char("Elevation@" + string(indALL(3,i)) +"%Ui (" + string(indALL(2,i)/1000) +"kyr)");
%             end
%         end
%     end
    
    plot(x,zALL(end,:),"r","Linewidth",1.5); % plot final elevation
    lgndtxt{end+1} = {char("Elevation @ " + string(indALL(3,end)) +"%Ui (" + string(indALL(2,end)/1000) +"kyr)")};
    
    if not(isempty(avtt)) % knickpoint at tt
        plot(kptALL(1,avtt),kptALL(2,avtt),'d','MarkerFaceColor','black','MarkerEdgeColor','black','MarkerSize',8);
        lgndtxt{end+1} = char("Knickpoint @ " + string(indALL(3,avtt)) +"%Ui (" + string(indALL(2,avtt)/1000) +"kyr)");
    end
    
    % knickpoint at end
    plot(kptALL(1,end),kptALL(2,end),'d','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',8);
    lgndtxt{end+1} = char("Knickpoint @ " + string(indALL(3,end)) +"%Ui (" + string(indALL(2,end)/1000) +"kyr)");
    
    kptUI = kptALL;
    kptUI(:,end) = [];
    if not(isempty(avtt)) && not(isempty(kptUI))
        kptUI(:,avtt) = [];
    end
    if not(isempty(kptUI)) % knickpoint (others)
        plot(kptUI(1,:),kptUI(2,:),'d','MarkerFaceColor',[0 0.7 0],'MarkerEdgeColor',[0 0.7 0],'MarkerSize',5);
        lgndtxt{end+1} = char("Knickpoint @ 10 to 50%Ui");
    end 
    grid on
    title("River profile elevation")
    xlabel("River length [m]")
    ylabel("Elevation [m]")       
    y_rnd = app_FUNC_roundvalues(linspace(0,(max(max(Z))+max(max(Z))*0.01),8));
    ylim([y_rnd(1) y_rnd(end)]);
    yticks(y_rnd);
    yticklabels({y_rnd});
    xlim([-(L*0.025) L+(L*0.025)])
    xticks(round([0:L/10:L],0));
    legend(string(lgndtxt),'Location','East',"fontsize",10);
    Y_txtloc = max(max(Z)) - (max(max(Z)) * 0.275);
    if ((Pn-Pi)/Pi)*100 > 0
        sgn = "increase";
    elseif ((Pn-Pi)/Pi)*100 < 0
        sgn = "decrease";
    else
        sgn = "";
    end
    text(2000,Y_txtloc,...
        sprintf(['%s to %s (%.0f [kyr]) at Lat:%.2f, Long:%.2f (pixel %.0f)\n',...
                    'Precipitation rate at %s: %.2f [mm/yr]\n',... 
                    '%.1f%% %s in precipitation rate after %.1f [kyr]\n',... 
                    'Precipitation rate at %s: %.2f [mm/yr]\n',...
                    'River length: %.d [km]\n',...
                    'Bedrock detachment: %.0e [(m.yr)^{-0.5}]\n',...
                    'Rock uplift rate: %.2f [mm/yr]\n',...
                    'End of the model: %.1f [kyr]'],...
                    TPi,TPn,tt/1000,lat,long,Npixel,TPi,Pi,abs(((Pn-Pi)/Pi)*100),sgn,tt/1000,...
                    TPn,Pn,L/1000,K,Ui,Tn/1000),'Color','black','FontSize',10);
    text(50,max(max(Z)) - (max(max(Z)) * 0.03),plt_type,'Color','black','FontSize',10,'FontWeight','bold'); % plot type text (@ mean or mod or ...)
%% Mean erosion rate
    strt = find(FinalTime == -10000);
    zro = find(FinalTime == 0);
    subplot('Position',pos3);
    plot([FinalTime(strt) Tn],[Ui Ui],"--k","Linewidth",1); % plot rock uplift rate as a constant line
    hold on
    plot(FinalTime(strt:end),FinalRiver(1,strt:end),"b","Linewidth",2); % plot the mean erosion rate
    hold on
    plot(FinalTime(strt:end),FinalCosmo(1,strt:end),"r","Linewidth",2); % plot the mean erosion rate
    hold on
    vrt = [FinalTime(strt), Ui-(Ui*0.01); FinalTime(strt), Ui+(Ui*0.01); abs(FinalTime(strt)-Tn), Ui+(Ui*0.01); abs(FinalTime(strt)-Tn) Ui-(Ui*0.01)];
    fc = [1, 2, 3, 4];
    patch('vertices', vrt, 'faces', fc,'FaceColor', [0.75 0.75 0.75], 'FaceAlpha', 0.5)
    hold on
    lgndtxt = ["Initia (Ui)","River (RE)","Cosmogenic (CE)","Steady state zone (1%(Ui))","@ Max RE","@ Max CE"];
    mx = max([max(FinalRiver(1,strt:end)),max(FinalCosmo(1,strt:end)),Ui]);
    mn = min([min(FinalRiver(1,strt:end)),min(FinalCosmo(1,strt:end)),Ui]);
    if Ui >= max(FinalRiver(1,strt:end))
        ytxt = -(abs( mn - mx )) * 0.03;
    else   
        ytxt = (abs( mn - mx )) * 0.03;
    end
    if Tn < 10000
        xtxt = (Tn - FinalTime(strt)) * 0.001;
    else
        xtxt = (Tn - FinalTime(strt)) * 0.01;
    end
    plot(OUT(1,1),OUT(2,1),'db','MarkerFaceColor','blue','MarkerEdgeColor','blue','MarkerSize',8); % at max RE
    text(OUT(1,1)+xtxt, OUT(2,1)+ytxt, string(round(OUT(3,1),1))+"%(Ui)",'fontsize',8,'Color','blue');
    hold on 
    plot(OUT(1,2),OUT(5,2),'dr','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',8); % at max CE
    text(OUT(1,2)+xtxt, OUT(5,2)+ytxt, string(round(OUT(6,2),1))+"%(Ui)",'fontsize',8,'Color','red');
%     hold on
%     plot(0,FinalCosmo(1,zro-1),'dk','MarkerFaceColor','black','MarkerEdgeColor','black','MarkerSize',8); % at 0
%     text(xtxt, FinalCosmo(1,zro-1)+ytxt, string(round(FinalCosmo(2,zro-1),1))+"%(Ui)",'fontsize',8,'Color','black');

%     for i = 5:9
%         t = OUT(1,i);
%         y = OUT(2,i);
%         if not(isnan(t))
%             plot(t,y,'dk','MarkerFaceColor','green','MarkerEdgeColor','green','MarkerSize',5); % RE relative to Ui
% %             text(t+5, y+ytxt, string(round(OUT(3,i)))+"%(Ui)",'fontsize',7,'Color,''blue');
%             hold on
%         end
%     end
%     for i = 20:24
%         t = OUT(1,i);
%         y = OUT(5,i);
%         if not(isnan(t))
%             plot(t,y,'dk','MarkerFaceColor','green','MarkerEdgeColor','green','MarkerSize',5); % CE relative to Ui
% %             text(t+5, y+ytxt, string(round(OUT(6,i)))+"%(Ui)",'fontsize',7,'Color,''red');
%             hold on
%         end
%     end

    grid on
    title("Mean catchment erosion rate (RIVER & COSMOGENIC)")
    xlabel("Time duration [kyr]")
    ylabel("Erosion rate [mm/yr]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    yticks(linspace(mn,mx,5));
    dfr = abs(mn-mx);
    if dfr < 0.001
        digrnd = 5;
    elseif dfr >= 0.001 && dfr < 0.01
        digrnd = 4;
    elseif dfr >= 0.01 && dfr < 0.1
        digrnd = 3;
    elseif dfr >= 0.1 && dfr < 1
        digrnd = 2;
    elseif dfr >= 1
        digrnd = 1;
    end
%     yticks(round(linspace(mn,mx,5),digrnd));
    yticklabels({round(linspace(mn,mx,5),digrnd)});
    if Tn < 10000
        xlim([-Tn/4 round(Tn,1)+(Tn/4)]);
        xticks( [round(linspace(0,Tn,7),2) ] );
        xticklabels({[round(linspace(0,Tn/1000,7),2) ]})
    else
        xlim([FinalTime(strt) round(Tn,1)+10000]);
        xticks( [round(linspace(0,Tn,7),0) ] );
        xticklabels({[round(linspace(0,Tn/1000,7),0) ]})
    end
    if Ui >= max(FinalRiver(1,strt:end))
        lgndloc = 'southeast';
    else
        lgndloc = 'northeast';
    end
    legend(lgndtxt,"location",lgndloc,"fontsize",8);
%% Change in mean (river) erosion rate
    % Relative to Ui
    subplot('Position',pos4_1);
    %--------------------------------%
    yyaxis left
    RUI = [OUT(1,5:9);OUT(3,5:9)]; % changes relative to Ui @ points
    aa = find(isnan(RUI(1,:)));
    RUI(:,aa) = [];
    RUI(2,:) = round(RUI(2,:),0);
    REUi = FinalRiver(2,strt:end); 
    mx = max([max(REUi)]);
    mn = min([min(REUi)]);
    plot(FinalTime(strt:end),REUi,'-b',"Linewidth",2);
    hold on
    [~,a2] = max(abs(REUi));
    plot(OUT(1,1),REUi(a2),'db','MarkerFaceColor','blue','MarkerEdgeColor','blue','MarkerSize',8); % at max RE
    hold on 
    if Ui >= max(FinalRiver(1,strt:end))
        ytxt = -(abs( mn - mx )) * 0.03;
    else   
        ytxt = (abs( mn - mx )) * 0.03;
    end
    if Tn < 10000
        xtxt = (Tn - FinalTime(strt)) * 0.001;
    else
        xtxt = (Tn - FinalTime(strt)) * 0.01;
    end
    if not(isempty(RUI))
        plot(RUI(1,:),RUI(2,:),'d','MarkerFaceColor',[0 0.7 0],'MarkerEdgeColor',[0 0.7 0],'MarkerSize',5);
        for i = 1:size(RUI,2)
            text(RUI(1,i)+xtxt,RUI(2,i)+ytxt,string(RUI(2,i))+"%",'fontsize',7,'Color',[0 0.7 0]);
        end
    end
    ylabel("Relative to Ui [%]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    dfr = abs(mn-mx);
    if dfr < 0.001
        digrnd = 5;
    elseif dfr >= 0.001 && dfr < 0.01
        digrnd = 4;
    elseif dfr >= 0.01 && dfr < 0.1
        digrnd = 3;
    elseif dfr >= 0.1 && dfr < 1
        digrnd = 2;
    elseif dfr >= 1
        digrnd = 1;
    end
    yticks(round(linspace(mn,mx,5),digrnd));
    ax = gca;
    ax.YColor = [0 0.7 0];
    % Relative to Peak
    %--------------------------------%
    yyaxis right
    RPK = [OUT(1,10:14);OUT(4,10:14)]; % changes relative to Peak @ points
    aa = find(isnan(RPK(1,:)));
    RPK(:,aa) = [];
    RPK(2,:) = round(RPK(2,:),0);
    REpk = FinalRiver(3,strt:end);
    mx = max([max(REpk)]);
    mn = min([min(REpk)]);
    hold on
    if Ui >= max(FinalRiver(1,strt:end))
        ytxt = -(abs( mn - mx )) * 0.03;
    else   
        ytxt = (abs( mn - mx )) * 0.03;
    end
    if Tn < 10000
        xtxt = (Tn - FinalTime(strt)) * 0.001;
    else
        xtxt = (Tn - FinalTime(strt)) * 0.01;
    end
    if not(isempty(RPK))
        plot(RPK(1,:),RPK(2,:),'d','MarkerFaceColor',[0.49 0.18 0.56],'MarkerEdgeColor',[0.49 0.18 0.56],'MarkerSize',5);
        for i = 1:size(RPK,2)
            text(RPK(1,i)+xtxt,RPK(2,i)+ytxt,string(RPK(2,i))+"%",'fontsize',7,'Color',[0.49 0.18 0.56]);
        end
    end
    ylabel("Relative to Peak [%]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    dfr = abs(mn-mx);
    if dfr < 0.001
        digrnd = 5;
    elseif dfr >= 0.001 && dfr < 0.01
        digrnd = 4;
    elseif dfr >= 0.01 && dfr < 0.1
        digrnd = 3;
    elseif dfr >= 0.1 && dfr < 1
        digrnd = 2;
    elseif dfr >= 1
        digrnd = 1;
    end
    yticks(round(linspace(mn,mx,5),digrnd));
    ax = gca;
    ax.YColor = [0.49 0.18 0.56];
    %--------------------------------%
    title("Change in mean RIVER erosion rate")
%     xlabel("Time duration [kyr]")
    if Tn < 10000
        xlim([-Tn/4 round(Tn,1)+(Tn/4)]);
        xticks( [round(linspace(0,Tn,7),2) ] );
    else
        xlim([FinalTime(strt) round(Tn,1)+10000]);
        xticks( [round(linspace(0,Tn,7),0) ] );
    end
%     xticklabels({[round(linspace(0,Tn/1000,5),0) ]})
    set(gca, 'XTicklabels', {});
%     set(gca, 'Color', [0.9 0.9 0.9]);
%     ax.XGrid = 'on';
    grid on
%% Change in mean (cosmo) erosion rate
    % Relative to Ui
    subplot('Position',pos4_2);
    %--------------------------------%
    yyaxis left
    CUI = [OUT(1,15:24);OUT(6,15:24)]; % changes relative to Ui @ points
    aa = find(isnan(CUI(1,:)));
    CUI(:,aa) = [];
    CUI(2,:) = round(CUI(2,:),0);
    CEUi = FinalCosmo(2,strt:end);
    mx = max([max(CEUi)]);
    mn = min([min(CEUi)]);
    plot(FinalTime(strt:end),CEUi,'-r',"Linewidth",2);
    hold on
    [~,a2] = max(abs(CEUi));
    plot(OUT(1,2),CEUi(a2),'dr','MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',8); % at max CE
    hold on
    if Ui >= max(FinalRiver(1,strt:end))
        ytxt = -(abs( mn - mx )) * 0.03;
    else   
        ytxt = (abs( mn - mx )) * 0.03;
    end
    if Tn < 10000
        xtxt = (Tn - FinalTime(strt)) * 0.001;
    else
        xtxt = (Tn - FinalTime(strt)) * 0.01;
    end
    if not(isempty(CUI))
        plot(CUI(1,:),CUI(2,:),'d','MarkerFaceColor',[0 0.7 0],'MarkerEdgeColor',[0 0.7 0],'MarkerSize',5);
        for i = 1:size(CUI,2)
            text(CUI(1,i)+xtxt,CUI(2,i)+ytxt,string(CUI(2,i))+"%",'fontsize',7,'Color',[0 0.7 0]);
        end
    end
    ylabel("Relative to Ui [%]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    dfr = abs(mn-mx);
    if dfr < 0.001
        digrnd = 5;
    elseif dfr >= 0.001 && dfr < 0.01
        digrnd = 4;
    elseif dfr >= 0.01 && dfr < 0.1
        digrnd = 3;
    elseif dfr >= 0.1 && dfr < 1
        digrnd = 2;
    elseif dfr >= 1
        digrnd = 1;
    end
    yticks(round(linspace(mn,mx,5),digrnd));
    ax = gca;
    ax.YColor = [0 0.7 0];
    % Relative to Peak
    %--------------------------------%
    yyaxis right
    CPK = [OUT(1,25:34);OUT(7,25:34)];
    aa = find(isnan(CPK(1,:)));
    CPK(:,aa) = [];
    CPK(2,:) = round(CPK(2,:),0);
    CEpk = FinalCosmo(3,strt:end);
    mx = max([max(CEpk)]);
    mn = min([min(CEpk)]);
    hold on
    if Ui >= max(FinalRiver(1,strt:end))
        ytxt = -(abs( mn - mx )) * 0.03;
    else   
        ytxt = (abs( mn - mx )) * 0.03;
    end
    if Tn < 10000
        xtxt = (Tn - FinalTime(strt)) * 0.001;
    else
        xtxt = (Tn - FinalTime(strt)) * 0.01;
    end
    if not(isempty(CPK))
        plot(CPK(1,:),CPK(2,:),'d','MarkerFaceColor',[0.49 0.18 0.56],'MarkerEdgeColor',[0.49 0.18 0.56],'MarkerSize',5);
        for i = 1:size(CPK,2)
            text(CPK(1,i)+xtxt,CPK(2,i)+ytxt,string(CPK(2,i))+"%",'fontsize',7,'Color',[0.49 0.18 0.56]);
        end
    end
    ylabel("Relative to Peak [%]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    dfr = abs(mn-mx);
    if dfr < 0.001
        digrnd = 5;
    elseif dfr >= 0.001 && dfr < 0.01
        digrnd = 4;
    elseif dfr >= 0.01 && dfr < 0.1
        digrnd = 3;
    elseif dfr >= 0.1 && dfr < 1
        digrnd = 2;
    elseif dfr >= 1
        digrnd = 1;
    end
    yticks(round(linspace(mn,mx,5),digrnd));
    ax = gca;
    ax.YColor = [0.49 0.18 0.56];
    %--------------------------------%
    grid on
    title("Change in mean COSMOGENIC erosion rate")
    xlabel("Time duration [kyr]")
    if Tn < 10000
        xlim([-Tn/4 round(Tn,1)+(Tn/4)]);
        xticks( [round(linspace(0,Tn,7),2) ] );
        xticklabels({[round(linspace(0,Tn/1000,7),2) ]})
    else
        xlim([FinalTime(strt) round(Tn,1)+10000]);
        xticks( [round(linspace(0,Tn,7),0) ] );
        xticklabels({[round(linspace(0,Tn/1000,7),0) ]})
    end
%     ax.XGrid = 'on';
%     set(gca, 'Color', [0.9 0.9 0.9]);
%% Chnage of knick points location 
    subplot('Position',pos2);
    %--------------------------------%    
    yyaxis left
    kpt1 = FinalKPT(2,strt:end);
    plot(FinalTime(strt:end),kpt1,"k","Linewidth",2);
    mx = max(kpt1);
    mn = min(kpt1);
    ylabel("Shift [%]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    y_rnd = app_FUNC_roundvalues(round(linspace(mn,mx,5),digrnd));
    yticks(y_rnd);
    %--------------------------------%
    yyaxis right
    kpt2 = FinalKPT(1,strt:end);
    mx = max(L-kpt2);
    mn = min(L-kpt2);
    ylabel("Shift [m]")
    ymin = mn - (abs(mn-mx)*0.1);
    ymax = mx + (abs(mn-mx)*0.1);
    ylim([ymin ymax]);
    y_rnd = app_FUNC_roundvalues(round(linspace(mn,mx,5),digrnd));
    yticks(y_rnd);
    %--------------------------------%   
    grid on
    if Tn < 10000
        xlim([-Tn/4 round(Tn,1)+(Tn/4)]);
        xticks( [round(linspace(0,Tn,7),2) ] );
    else
        xlim([FinalTime(strt) round(Tn,1)+10000]);
        xticks( [round(linspace(0,Tn,7),0) ] );
    end
    set(gca, 'XTicklabels', {});
    title("Lateral shift in KNICKPOINT position")        
end
