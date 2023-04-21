function [d_input,Ti,Tn] = FUNC_PrecipitationLoader(tstart,tend)
raw_data = [];
cf = pwd;
path_rawdata = char(cf+"\Precipitation_data");
cd(path_rawdata);
temp1 = dir('*.txt');
for i = 1:length(temp1)
    raw_txt = temp1(i).name;
    f_ = strfind(raw_txt,'_');
    temp2 = strcat('data_',raw_txt(1:f_-1));
    raw_data.(temp2 ) = load(raw_txt,'txt');
end
cd(cf);
%% load the data;
try
    PL = raw_data.data_PL;
catch
end
try
    LGM = raw_data.data_LGM;
catch
end
try
    MH = raw_data.data_MH;
catch
end
try
    PI= raw_data.data_PI;
catch
end
try
    PD= raw_data.data_PD;
catch
end
%% Model duration based on chosen data
if tstart == "PL"
    Ti = 3000000;
    d_input = PL;
elseif tstart == "LGM"
    Ti = 21000;
    d_input = LGM;
elseif tstart == "MH"
    Ti = 6000;
    d_input = MH;
elseif tstart == "PI"
    Ti = 300;
    d_input = PI;
end
if tend == "LGM"
    Tn = 21000;
    d_input(:,end+1) = LGM(:,end);
elseif tend == "MH"
    Tn = 6000;
    d_input(:,end+1) = MH(:,end);
elseif tend == "PI"
    Tn = 300;
    d_input(:,end+1) = PI(:,end);
elseif tend == "PD"
    Tn = 0;
    d_input(:,end+1) = PD(:,end);
end