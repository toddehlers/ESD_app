function [] = app_FUNC_PrecipitationMapMaker(app,precHOW,prec,difprec,plt_xt,ppath,wb,N_wb)
    if sum(prec == 1) > 0
        TPind = find(prec == 1);
        if precHOW(1) == 1
            app_FUNC_precMapMakerPrec(app,TPind,plt_xt,ppath);
            N_wb(end-1) = N_wb(end-1)+1;
            prc = N_wb(end-1)/N_wb(end);
            app_FUNC_waitbar(wb,prc,char("Precipitation Maps... " + string(round(prc*100,1)) + " %"))
        end
        if precHOW(2) == 1
            for i = 1:length(TPind)
                app_FUNC_precMapMakerPrec(app,TPind(i),plt_xt,ppath);
                N_wb(end-1) = N_wb(end-1)+1; 
                prc = N_wb(end-1)/N_wb(end);
                app_FUNC_waitbar(wb,prc,char("Precipitation Maps... " + string(round(prc*100,1)) + " %"))
            end
        end
    end
%-------------------------------------
    if sum(difprec == 1) > 0
        TPind = find(difprec == 1);
        if precHOW(1) == 1
            app_FUNC_precMapMakerDif(app,TPind,plt_xt,ppath);
            N_wb(end-1) = N_wb(end-1)+1;
            prc = N_wb(end-1)/N_wb(end);
            app_FUNC_waitbar(wb,prc,char("Precipitation(diff)Maps... " + string(round(prc*100,1)) + " %"))
        end
        if precHOW(2) == 1
            for j = 1:length(TPind)
                app_FUNC_precMapMakerDif(app,TPind(j),plt_xt,ppath);
                N_wb(end-1) = N_wb(end-1)+1;
                prc = N_wb(end-1)/N_wb(end);
                app_FUNC_waitbar(wb,prc,char("Precipitation(diff) Maps... " + string(round(prc*100,1)) + " %"))
            end
        end
    end
end
