function [] = app_FUNC_ProfileMaker1...
    (app,selected_data,ppath,wb,N_wb) 
    allpnts = app.allpnts;
    alltype = app.alltype;
    allIPT = app.allIPT;
    cosmovar = app.COSM;
    %--------------------------------------
    for i = 1:size(selected_data,1)
        dta = load(selected_data{i,6});   dta = dta.BriefOP;
        TPi = string(selected_data{i,1});
        TPn = string(selected_data{i,2});
        L = str2num(selected_data{i,3});
        Ui = str2num(selected_data{i,4});
        K = str2num(selected_data{i,5});
%         RT = dta(:,8:41)/1000;
        RE = dta(:,42:75); 
        RE_Ui = dta(:,76:109); 
%         RE_Peak = dta(:,110:143);
%         CE_Ui = dta(:,178:211);
%         CE_Peak = dta(:,212:245);
        %----------------------------------------------------- 
%% ---------------------------------- data modification is necessary
        tmp1 = find(isnan(RE(:,3))); % if it couldn't reach to (tt)
        RE(tmp1,3) = RE(tmp1,4); % then it already reached to (EQ) so the value is same as value at the end
        RE_Ui(tmp1,3) = RE_Ui(tmp1,4);
%         RE_Peak(tmp1,3) = RE_Peak(tmp1,4);
%         tmp2 = [10 20 30 40 50];
%         for ii = 1:length(tmp2)
%             % if the maximum change relative to Ui is bigger than a value (e.g. 50%), then it
%             % needs more time than end of the model (500 kyr) to reach to it
%             RT((isnan(RT(:,ii+4)) & abs(RE_Ui(:,1)) > tmp2(ii)),ii+4) = 500;
%             RT((isnan(RT(:,ii+19)) & abs(CE_Ui(:,2)) > tmp2(ii)),ii+19) = 500;
%             % if the final change relative to Max is smaller than a value (e.g. 50%), then it
%             % needs more time than end of the model (500 kyr) to reach to it
%             RT((isnan(RT(:,ii+9)) & abs(RE_Peak(:,4)) < tmp2(ii)),ii+9) = 500;
%             RT((isnan(RT(:,ii+29)) & abs(CE_Peak(:,4)) < tmp2(ii)),ii+29) = 500;
% 
%             RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+4)))      &     (abs(RE_Ui(:,1)) > tmp2(ii))     ,ii+4) = 500;
%             RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+19)))      &     (abs(CE_Ui(:,2)) > tmp2(ii))     ,ii+19) = 500;
%             RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+9)))      &     (abs(RE_Ui(:,end)) < tmp2(ii))     ,ii+4) = 500;
%             RT(     (RT(:,4) == 500)     &     (isnan(RT(:,ii+29)))      &     (abs(CE_Ui(:,end)) < tmp2(ii))     ,ii+19) = 500;
%         end
%         RT(:,3) = RT(:,4);
%% -----------------------------------        
        %------------------------------------- get the interesting points
%         [allpnts,alltype,allIPT] = app_FUNC_pointfinder(app,RE,RE_Ui,vPP,vststPr,vsmplrnd,vallrnd,vcord);
        %-------------------------------------
        [d_input,Ti,Tn] = app_FUNC_PrecipitationLoader(app,TPi,TPn);
        d_input(d_input(:,1)>75,:) = []; % delete all the data higher than 75N
        d_input(d_input(:,1)<-60,:) = []; % delete all the data lower than 60S
        d_cosmo = cosmovar(:,4:6);
        %-----------------------------------
        d_input = d_input(allpnts(i,:),:);
        d_cosmo = d_cosmo(allpnts(i,:),:);
        %-----------------------------------
        L = L * 1000;
        Ui = Ui/1000;
        Un = Ui; % final rock uplift rate same as initial
        tt = abs(Ti - Tn); % total time of the model duration;
        lat_temp = d_input(:,1); % latitude
        long_temp = d_input(:,2); % longitude
        alt_temp = cosmovar (:,3); % altitude
        Pi_temp = d_input(:,3) / 1000; % [m/yr]
        Pn_temp = d_input(:,4) / 1000; % [m/yr]
        for k = 1:size(d_input,1) % loop of pixels
            plttype = alltype(k);
            typix = allIPT(k);
            Npixel = allpnts(i,k); % number of the pixel
            latt = lat_temp(k); % latitude
            longg = long_temp(k); % longitude
            alt = alt_temp(k); % altitude
            Pi = Pi_temp(k); % [m/yr]
            Pn = Pn_temp(k); % [m/yr]
            app_FUNC_ProfileMaker2(app,Npixel,TPi,TPn,latt,longg,alt,Pi,Pn,Ui,Un,L,K,tt,d_cosmo(k,:),plttype,typix,ppath);   
            N_wb(end-1) = N_wb(end-1)+1;         
            prc = (N_wb(end-1)/N_wb(end));
            app_FUNC_waitbar(wb,prc,char("Erosion Profile... " + string(round(prc*100,1)) + " %"))
        end
    end
end