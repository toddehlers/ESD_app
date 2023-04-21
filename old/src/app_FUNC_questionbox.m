function [run] = app_FUNC_questionbox(app)
    N_eMap = app.totalmap.Value;
    N_eProfile = app.totalprofile.Value;
    N_pMap = app.totalprecipitation.Value;
    txt_emap = "";
    txt_eprof = "";
    txt_pmap = "";

    if N_eMap > 0
        txt_emap = sprintf("\nErosion map: %.0f",N_eMap);
    end
    if N_eProfile > 0
        txt_eprof = sprintf("\nErosion profile(s) %.0f",N_eProfile);
    end
    if N_pMap > 0
        txt_pmap = sprintf("\nPrecipitation map(s) %.0f",N_pMap);
    end
    
    info = "You are about to plot: "+txt_emap+txt_eprof+txt_pmap;
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