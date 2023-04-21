function [allpnts,alltype,allIPT] = app_FUNC_pointfinder(app,RE,RE_Ui,vPP,vststPr,vsmplrnd,vallrnd,vcord)
%------------------------------------------------------------------------
%This helpful functions finds all the selected points to generate profile
%plots, it can be based on statistic values, input coordinate or random
%points

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_realtimemap

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    %1-FUNC_stat
    %2-FUNC_rndsample
    %3-FUNC_rcoord

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
    %--------------------------------------
    LLA = app.LatLongAlt;
    lat = LLA(:,1);
    long= LLA(:,2);
    %--------------------------------------
    if vPP(1) == 1
        [point1,plt_type1,INDplttyp1] = FUNC_stat(RE,RE_Ui,vststPr);
    else
        point1 = [];
        plt_type1 = [];
        INDplttyp1 = [];
    end
    if vPP(2) == 1
        point2 = FUNC_rndsample(app,vsmplrnd,lat,long);
        plt_type2 = repmat("@ a random point from the samples",[1 vsmplrnd]);
        INDplttyp2 = repmat(100,[1 vsmplrnd]);
    else
        point2 = [];
        plt_type2 = [];
        INDplttyp2 = [];
    end
    if vPP(3) == 1
        point3 = round((size(lat,1)-1).*rand(1,vallrnd) + 1,0); 
        plt_type3 = repmat("@ a random location",[1 vallrnd]);
        INDplttyp3 = repmat(200,[1 vallrnd]);
    else
        point3 = [];
        plt_type3 = [];
        INDplttyp3 = [];
    end
    if vPP(4) == 1
        point4 = FUNC_rcoord(vcord,lat,long);
        plt_type4 = "@ nearest location to (lat:" + string(vcord(1)) + " & long:" +string(vcord(2)) +")";
        INDplttyp4 = 300;
    else
        point4 = [];
        plt_type4 = [];
        INDplttyp4 = [];
    end
    allpnts = [point1 point2 point3 point4];
    alltype = [plt_type1 plt_type2 plt_type3 plt_type4];
    allIPT = [INDplttyp1 INDplttyp2 INDplttyp3 INDplttyp4];
end
%%
function [pnts,plt_type,INDplttyp] = FUNC_stat(RE,RE_Ui,vststPr)
% Some statistic and finding some interesting points for profile plots
    ind = NaN(11,size(RE,2));       % find index of points with negative and positive changes
    ind_pos = find(RE_Ui(:,1) > 0);       % find all the points with + sign in erosion change
    ind_neg = find(RE_Ui(:,1) < 0);       % find all the points with - sign in erosion change
    pos_data = RE(ind_pos(:,1));
    neg_data = RE(ind_neg(:,1));
    % do some statistics
    mean_tot = nanmean(RE(:,1));
    std_tot = nanstd(RE(:,1));
    med_tot = nanmedian(RE(:,1));
    [mod_tot,freq_tot] = mode(round(RE_Ui(:,1),1));
    mean_pos = nanmean(pos_data);
    std_pos = nanstd(pos_data);
    med_pos = nanmedian(pos_data);
    [mod_pos,freq_pos] = mode(round(RE_Ui(ind_pos(:,1),1),1));
    max_pos = nanmax(pos_data);
    mean_neg = nanmean(neg_data);
    std_neg = nanstd(neg_data);
    med_neg = nanmedian(neg_data);
    [mod_neg,freq_neg] = mode(round(RE_Ui(ind_neg(:,1),1),1));
    min_neg = nanmin(neg_data);
    %stat = [mean_tot std_tot med_tot mean_pos std_pos med_pos max_pos mean_neg std_neg med_neg min_neg];
    % find some interesting points to plot the profile
    [~,ind_mean_tot_0] = min(abs(RE(:,1) - mean_tot)); % close to total mean
    [~,ind_mean_pos_0] = min(abs(RE(:,1) - mean_pos)); % close to positive mean 
    [~,ind_mean_neg_0] = min(abs(RE(:,1) - mean_neg)); % close to negative mean 
    [~,ind_median_tot_0] = min(abs(RE(:,1) - med_tot)); % close to total median
    [~,ind_median_pos_0] = min(abs(RE(:,1) - med_pos)); % close to positive median
    [~,ind_median_neg_0] = min(abs(RE(:,1) - med_neg)); % close to negative median
    [~,ind_mode_tot_0] = min(abs(RE_Ui(:,1) - mod_tot)); % close to total mode
    [~,ind_mode_pos_0] = min(abs(RE_Ui(:,1) - mod_pos)); % close to positive mode
    [~,ind_mode_neg_0] = min(abs(RE_Ui(:,1) - mod_neg)); % close to negative mode
    [~,ind_max_pos] = nanmax(RE(:,1));
    [~,ind_min_neg] = nanmin(RE(:,1));
    ind = [ind_mean_pos_0;ind_median_pos_0;ind_mode_pos_0;ind_max_pos;...
    ind_mean_neg_0;ind_median_neg_0;ind_mode_neg_0;ind_min_neg;...
    ind_mean_tot_0;ind_median_tot_0;ind_mode_tot_0];
    mn1 = "@ Mean of the greatest change in river erosion rate relative to Ui (+ points)";
    mn2 = "@ Mean of the greatest change in river erosion rate relative to Ui (- points)";
    mn3 = "@ Mean of the greatest change in river erosion rate relative to Ui (overall)";
    mdn1 = "@ Median of the greatest change in river erosion rate relative to Ui (+ points)";
    mdn2 = "@ Median of the greatest change in river erosion rate relative to Ui (- points)";
    mdn3 = "@ Median of the greatest change in river erosion rate relative to Ui (overall)";
    minim = "@ Minimum of the greatest change in river erosion rate relative to Ui (- points)";
    maxim = "@ Maximum of the greatest change in river erosion rate relative to Ui (+ points)";
    md1 = "@ Mode (" + string(freq_pos) + "/" + string(length(ind_pos)) + ") of the greatest change in river erosion rate relative to Ui (+ points)";
    md2 = "@ Mode (" + string(freq_neg) + "/" + string(length(ind_neg)) + ") of the greatest change in river erosion rate relative to Ui (- points)";
    md3 = "@ Mode (" + string(freq_tot) + "/" + string(size(RE,1)) + ") of the greatest change in river erosion rate relative to Ui (overall)";
    pltname = [mn1;mdn1;md1;maxim;mn2;mdn2;md2;minim;mn3;mdn3;md3];
   pnts = [];
   plt_type = [];
   INDplttyp = [];
   for i = 1:length(vststPr)
        if vststPr(i) == 1
            pnts = [pnts ind(i)];
            plt_type = [plt_type pltname(i)];
            INDplttyp = [INDplttyp i];
        end
   end
end
%%
function [points] = FUNC_rndsample(app,vsmplrnd,lat,long)
    smpl = app.SMPL;
    pnts = round((size(smpl,1)-1).*rand(vsmplrnd,1) + 1,0); 
    points = NaN(1,length(vsmplrnd));
    for i = 1:length(pnts)
        lat_usr = smpl(pnts(i),1);
        long_usr = smpl(pnts(i),2);
        A(:,1) = abs(lat_usr - lat);
        A(:,2) = abs(long_usr - long);
        A(:,3) = sqrt((A(:,1).^2) + (A(:,2).^2));
        [~,p] = min(A(:,3));
        points(1,i) = p;
    end
end
%%
function [points] = FUNC_rcoord(vcord,lat,long)
    lat_usr = vcord(1);
    long_usr = vcord(2);
    A(:,1) = abs(lat_usr - lat);
    A(:,2) = abs(long_usr - long);
    A(:,3) = sqrt((A(:,1).^2) + (A(:,2).^2));
    [~,points] = min(A(:,3));
end