function [latFIG,longFIG,rtio] = app_FUNC_figureratio(app)
%     margdist  = 0;
    LBlat = app.LBlat.Value;
    LBlong = app.LBlong.Value;
    TRlat = app.TRlat.Value;
    TRlong = app.TRlong.Value;
%     dst_LBlat = abs( -60 - LBlat );
%     dst_LBlong = abs( -180 - LBlong );
%     dst_TRlat = abs( 75 - TRlat );
%     dst_TRlongt = abs( 180 - TRlong);
%     if dst_LBlat < margdist || dst_TRlat < margdist
%         LBlat = LBlat - min(dst_LBlat,dst_TRlat);
%         TRlat = TRlat + min(dst_LBlat,dst_TRlat);
%     else
%         LBlat = LBlat - margdist;
%         TRlat = TRlat + margdist;
%     end
%     if dst_LBlong < margdist || dst_TRlongt < margdist
%         LBlong = LBlong - min(dst_LBlong,dst_TRlongt);
%         TRlong = TRlong + min(dst_LBlong,dst_TRlongt);
%     else
%         LBlong = LBlong - margdist;
%         TRlong = TRlong + margdist;
%     end
    latFIG = abs(LBlat - TRlat);
    longFIG = abs(LBlong - TRlong);
    rtio = latFIG / longFIG; % latitude / longitude
end