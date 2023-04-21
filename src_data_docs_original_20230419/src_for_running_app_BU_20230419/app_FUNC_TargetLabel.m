function [target_labels] = app_FUNC_TargetLabel(app,mat_data)
%------------------------------------------------------------------------
% The main function to generate difference temperature maps

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_precMapMakerPrec
    %2-app_FUNC_precMapMakerDif
    %3-app_FUNC_tempMapMakerTemp
    %4-app_FUNC_tempMapMakerDif

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    %1-app_FUNC_colobarspacing
    %2-app_FUNC_roundvalues
%------------------------------------------------------------------------
    P_max = ceil(nanmax(nanmax(nanmax(mat_data))));
    P_min = fix(nanmin(nanmin(nanmin(mat_data))));
    
    if app.CT_Eqdstrbtn.Value == 1 % equal distribution
        spacing = app_FUNC_colobarspacing(mat_data,1,P_min,P_max,16);
        target_labels = app_FUNC_roundvalues(spacing);
    elseif app.CT_EqDstnc.Value == 1 % equal spacing
        dt_tmp = [11,13,15,17,19];
        for i = 1:5
            tmp = linspace(P_min,P_max,dt_tmp(i));
            tmp1(i) = abs((tmp(2)-tmp(1)));
            tmp2(i) = round(tmp1(i));
            tmp3(i) = abs(tmp1(i)-tmp2(i));
        end
        [a,b] = min(tmp3);
        dt = tmp2(b);
        n = 1;
        while dt == 0
            dt = max(round(tmp1,n));
            n = n+1;
        end
        target_labels = (P_min:dt:P_max);
        target_labels(1) = P_min;
        target_labels(end) = P_max;
    end
end