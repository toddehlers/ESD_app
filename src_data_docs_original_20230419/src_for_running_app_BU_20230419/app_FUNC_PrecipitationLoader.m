function [d_input,Ti,Tn] = app_FUNC_PrecipitationLoader(app,tstart,tend)
%------------------------------------------------------------------------
%This function find precipitation data and load them to the app

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_ProfileMaker1
    
%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
raw_data = [];
% cf = pwd;
% path_rawdata = char(cf+"\Precipitation_data");
% cd(path_rawdata);
temp1 = app.PrecipitationDir;

% i = 1;
% while true
%     a = temp1(i).name;
%     if string(a(end-14:end)) ~= "oceanmasked.txt"
%         temp1(i,:) = [];
%     else
%         i = i+1;
%     end
%     if length(temp1) < i
%         break
%     end
% end

for i = 1:length(temp1)
    raw_txt = temp1(i).name;
    f_ = strfind(raw_txt,'_');
    temp2 = strcat('data_',raw_txt(1:f_-1));
    raw_data.(temp2 ) = load(strcat(app.PathPrecipitationData,filesep,raw_txt),'txt');
end
% cd(cf);
%% load the data;
try
    PL = raw_data.data_1PL;
catch
end
try
    LGM = raw_data.data_2LGM;
catch
end
try
    MH = raw_data.data_3MH;
catch
end
try
    PI= raw_data.data_4PI;
catch
end
try
    PD= raw_data.data_5PD;
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