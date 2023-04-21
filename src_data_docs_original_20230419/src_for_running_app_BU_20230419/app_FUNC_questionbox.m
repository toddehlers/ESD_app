function [run] = app_FUNC_questionbox(app)
%------------------------------------------------------------------------
% It shows the user how many plots is about to get generated and if the
% user agree

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_pushbut

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
    N_eMap = app.totalmap.Value;
    N_eProfile = app.totalprofile.Value;
    N_pMap = app.totalprecipitation.Value;
    N_tMap = app.totaltemperature.Value;
    N_hist = app.totalhistogarm.Value;
    txt_emap = "";
    txt_eprof = "";
    txt_pmap = "";
    txt_tMap = "";
    txt_hist = "";

    if N_eMap > 0
        txt_emap = sprintf("\nErosion map: %.0f",N_eMap);
    end
    if N_eProfile > 0
        txt_eprof = sprintf("\nErosion profile(s) %.0f",N_eProfile);
    end
    if N_pMap > 0
        txt_pmap = sprintf("\nPrecipitation map(s) %.0f",N_pMap);
    end
    if N_tMap > 0
        txt_tMap = sprintf("\nTemperature map(s) %.0f",N_tMap);
    end
    if N_hist > 0
        txt_hist = sprintf("\nHistogram(s) %.0f",N_hist);
    end
    
    info = "You are about to plot: "+txt_emap+txt_eprof+txt_pmap+txt_tMap+txt_hist;
    answer = questdlg(info, ...
        'Are you sure?', ...
        'RUN','Cancel','Cancel');
    % Handle response
    switch answer
        case 'RUN'
            run = 1;
        case 'Cancel'
            run = 0;
    end
end