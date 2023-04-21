function f = app_FUNC_setthefiguresize(app,rtio)
%------------------------------------------------------------------------
% This function make decisions about figure size based on screen size

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_MapMaker1
    %2-app_FUNC_ProfileMaker2
    %3-app_FUNC_precMapMakerPrec
    %4-app_FUNC_precMapMakerDif
    %5-app_FUNC_tempMapMakerTemp
    %6-app_FUNC_tempMapMakerDif
    %7-app_FUNC_hist

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
    if app.PLOTCheckBox.Value ~=1
        f = figure('visible', 'off');
    else
        f = figure;
    end
    set(f,'Color',[1 1 1]);
    set(f, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]); % full screen figure
    set(f, 'Units', 'centimeters');
    scrn = get(f, 'OuterPosition'); % get the size of the screen in CM
%     if rtio >= sqrt(2) % portrait condition based on A4 paper ratio

    nhgt = scrn(4) * 0.8;
    nwdt = nhgt * sqrt(2);


%     nwdt = scrn(3)*0.75; % set width of the figure to 75 percenet of the width of the screen
%     nhgt = nwdt / sqrt(2);  % set height of the figure to any value which fit the A4 paper size ratio
    set(f, 'OuterPosition', [0, scrn(4)-nhgt, nwdt, nhgt]); % change the figure size to the new size
%     else % landscape condition based on A4 paper ratio
%         nwdt = scrn(3)*0.75;
%         nhgt = nwdt / sqrt(2);
%         set(f, 'OuterPosition', [0, scrn(4)-nhgt, nwdt, nhgt]);
%     end
    set(f, 'Units', 'Normalized');
%     set(f,'PaperPositionMode','manual');
%     set(f,'PaperType','a4');
%     set(f,'PaperOrientation','landscape');
    
    
    
end