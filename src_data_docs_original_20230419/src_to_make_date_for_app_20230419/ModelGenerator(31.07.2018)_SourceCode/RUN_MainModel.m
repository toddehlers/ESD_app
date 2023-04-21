clear
close all
clc
P1 = genpath('Extra_data');
addpath(P1)
cf = pwd;
%% USER INPUT (PLEASE CHECK BEFORE RUN)
% select the initial and final data from [PL, LGM, MH, PI] (PL can not be final and PI can not be initial)
TT = { ["PL","LGM"] ; ["PL","MH"] ; ["PL","PI"] ; ["PL","PD"] ; ["LGM","MH"] ; ["LGM","PI"] ; ["LGM","PD"] ; 
           ["MH","PI"] ; ["MH","PD"] ; ["PI","PD"] };
LL = [10000 40000 80000];
KK = [5e-5 1e-6 1e-7];
UU = [0.01 0.1 0.5 1];
plt_type = "";
%% data preparation
for i = 1:length(TT)
    disp(string(i) + ": " + string(TT{i}(1)) + " >>> " + string(TT{i}(2)))
end
pick_TP = str2num(input('Pick the time periods you want...\nEntre number: ','s'));
i = 1;
for l = 1:length(LL)
    for k = 1:length(KK)
        for u = 1:length(UU)
            catchment_par(i,:) = [LL(l),KK(k),UU(u)];
            disp(string(i) + ": L = " + string(LL(l)) + " K = " + string(KK(k)) + " Ui = " + string(UU(u))) 
            i = i+1;
        end
    end
end
pick_CP = str2num(input('Pick the catchment parameters you want...\nEntre number(s): ','s'));
cosmovar = load('LatLongAltSF123.txt');
True_path = [];
Cosmo_path = [];
ndt = 100; % dt for both river and cosmo
%%
for i = 1:length(pick_TP) % loop of time periods
    TPi = TT{pick_TP(i)}(1);
    TPn = TT{pick_TP(i)}(2);
    [d_input,Ti,Tn] = FUNC_PrecipitationLoader(TPi,TPn); % use raw_loader function to load the data
    d_input(d_input(:,1)>75,:) = []; % delete all the data higher than 75N
    d_input(d_input(:,1)<-60,:) = []; % delete all the data lower than 60S
    d_cosmo = cosmovar(:,4:6);
%------------------------ chosen points based on statistic can be here
%         pnts = round((size(d_input,1)-1).*rand(npnts,1) + 1,0); % generate (npnts) random points for test run
%         pnts = [1 1000 5000 10933 22964];
        pnts = 1:size(d_input,1);
        d_input = [d_input(pnts,:) pnts'];
        d_cosmo = d_cosmo(pnts,:);
    for j = 1:length(pick_CP) % loop of catchment parameters
        L = catchment_par(pick_CP(j),1);
        K = catchment_par(pick_CP(j),2);
        Ui = catchment_par(pick_CP(j),3);
        Ui = Ui / 1000; % [m/yr]
        Un = Ui; % final rock uplift rate same as initial
        tt = abs(Ti - Tn); % total time of the model duration;
        lat_temp = d_input(:,1); % latitude
        lon_temp = d_input(:,2); % longitude
        alt_temp = cosmovar (:,3); % altitude
        Pi_temp = d_input(:,3) / 1000; % [m/yr]
        Pn_temp = d_input(:,4) / 1000; % [m/yr]
        Npixeltemp = d_input(:,end);
        %-------------------
        RE = NaN(size(d_input,1),5200);
        CE = NaN(size(d_input,1),5200);
        KPT = NaN(size(d_input,1),5200);
        BriefOP = NaN(size(d_input,1),313);
        [fn_RE,fn_CE,fn_KPT,fn_BriefOP] = FUNC_mkfldr(cf,TPi,TPn,L/1000,Ui*1000,K);
        parfor k = 1:size(d_input,1) % loop of pixels
            Npixel = Npixeltemp(k); % number of the pixel
            lat = lat_temp(k); % latitude
            lon = lon_temp(k); % longitude
            alt = alt_temp(k); % altitude
            Pi = Pi_temp(k); % [m/yr]
            Pn = Pn_temp(k); % [m/yr]
            [PixelInfo,FinalRiver,FinalCosmo,FinalKPT,BriefOutput] = ...
                FUNC_MainModel(Npixel,TPi,TPn,lat,lon,alt,Pi,Pn,Ui,Un,L,K,tt,d_cosmo(k,:));
            %------------------------
            RE(k,:) = FinalRiver;
            CE(k,:) = FinalCosmo;
            KPT(k,:) = FinalKPT;
            BriefOP(k,:) = BriefOutput;
        end
        RE = sortrows(RE);
        CE = sortrows(CE);
        KPT = sortrows(KPT);
        BriefOP = sortrows(BriefOP);
        save(fn_RE,'RE')
        save(fn_CE,'CE')
        save(fn_KPT,'KPT')
        save(fn_BriefOP,'BriefOP')
    end
end
%%
function [fn_RE,fn_CE,fn_KPT,fn_BriefOP] = FUNC_mkfldr(cf,TPi,TPn,L,Ui,K)
% make all the necessary folders
%     temppath = "LongOutput\"+...
%     TPi+"_"+TPn+"\"+...
%     num2str(L/1000,'%.d')+"_"+num2str(Ui*1000,'%.2f')+"_"+num2str(K,'%.0e');
%     if not(exist(char(temppath),"dir"))
%         mkdir(char(temppath))
%     end
    
    % go to related folder    
    if not(exist(char("LongOutput"),"dir"))
        mkdir(char("LongOutput"))
    end

    if not(exist(char("BriefOutput"),"dir"))
        mkdir(char("BriefOutput"))
    end
    LongPath = cf+"\LongOutput\";
    BriefPath = cf+"\BriefOutput\";
    
    fn_RE = sprintf("%sRiverErosionRate_(%s_%s)_(%d_%.2f_%.0e).mat",...
    LongPath,TPi,TPn,L,Ui,K);
    fn_CE = sprintf("%sCosmoErosionRate_(%s_%s)_(%d_%.2f_%.0e).mat",...
    LongPath,TPi,TPn,L,Ui,K);
    fn_KPT = sprintf("%sKnickpointShift_(%s_%s)_(%d_%.2f_%.0e).mat",...
    LongPath,TPi,TPn,L,Ui,K);
    fn_BriefOP = sprintf("%sBriefOutput_(%s_%s)_(%d_%.2f_%.0e).mat",...
    BriefPath,TPi,TPn,L,Ui,K);
end