function [final_output,OUT,T,Tlong,RE,RElong,CE,CElong,KPT,KPTlong] = ...
    app_FUNC_ExtractParameters(FileInfo,PixelInfo,RiverData,CosmoData)
%% Read the data
% File info
    TPi = FileInfo(1); %initial time period
    TPn = FileInfo(2); % final time period
    tt = str2num(char(FileInfo(3)));  % time duration between TPi and TPn
    L = str2num(char(FileInfo(4)));  % river length
    K = str2num(char(FileInfo(5)));  % Bedrock detachment
    Ui = str2num(char(FileInfo(6)));  % initial rock uplift rate
    Ndt = str2num(char(FileInfo(7)));  % new time increament
% Pixel info 
    Npixel = PixelInfo(1); % pixels number
    lat = PixelInfo(2); %latitude
    long = PixelInfo(3);  % longitude
    alt = PixelInfo(4);  % altitude
    Pi = PixelInfo(5);  % initial precipitation
    Pn = PixelInfo(6);  % final precipitation
    Tn = PixelInfo(7);  % time at end of the model
% data from neegative time to end (long data)
    Tlong = CosmoData(1,:); % time vector (long)
    zro = find(Tlong == 0); % find the time zero index
    befor_strt = abs(size(CosmoData,2) - size(RiverData,2)); % number of negative time cells
    
    REtemp = Ui * ones(1,befor_strt); 
    RElong = [REtemp RiverData(2,:)];
    RElong(2,:) = ((RElong(1,:)-Ui)/Ui)*100;
    [~,ipk] = max(abs(RElong(2,zro:end))); % index of the peak
    ipk = ipk+zro-1;
    pk_RE = RElong(1,ipk); % peak value [mm/yr]
    RElong(3,:) = ((RElong(1,:)-pk_RE)/pk_RE)*100; %  amount of change relative to peak [%]

    KPTtemp = L * ones(1,befor_strt);
    KPTlong = [KPTtemp RiverData(5,:)];
    KPTlong(2,:) = (L-KPTlong(1,:))/L*100;
    
    CElong = CosmoData(2,:);
    CElong(2,:) = ((CElong(1,:)-Ui)/Ui)*100;
    [~,ipk] = max(abs(CElong(2,zro:end)));
    ipk = ipk+zro-1;
    pk_CE = CElong(1,ipk);
    CElong(3,:) = ((CElong(1,:)-pk_CE)/pk_CE)*100; %  amount of change relative to peak [%]
% data from zero to end
    RE = RElong(:,zro:end);
    CE = CElong(:,zro:end);
    KPT = KPTlong(:,zro:end);
    T = Tlong(:,zro:end);
%% find the indices
    %----------------------------------- fixed indices @ (Peak_RE , Peak_CE , tt , end)
    [~,IPR] = max(abs(RE(2,:))); 
    [~,IPC] = max(abs(CE(2,:))); 
    if tt <= Tn
        i_tt = find(T == tt); % index at model duration
    else
        i_tt = NaN;
    end
    i_end = length(T); % index of model end
    %----------------------------------- find indices:
    i_REui = NaN(1,5); % River Erosion relative to Ui @ (10,20,30,40,50)
    i_REpk = NaN(1,5); % River Erosion relative to PEAK @ (10,20,30,40,50)
    i_CEui = NaN(1,10); % Cosmo Erosion relative to Ui @ (10,20,30,40,50 , 10,20,30,40,50)
    i_CEpk = NaN(1,10); % Cosmo Erosion relative to PEAK @ (10,20,30,40,50 , 10,20,30,40,50)
    % index of "CHANGES"
    tmp1 = [10 20 30 40 50];
    for k = 1:length(tmp1)
        %-------------------------- find where the change of RE relative to Ui is (10,20,30,40,50) percente 
        [tmp3,ind3] = min(abs(abs(RE(2,:)) - tmp1(k)));
        if tmp3 < 0.5
            i_REui(k) = ind3;
        end
        %-------------------------- find where the change of RE relative to PEAK is (10,20,30,40,50) percente
        [tmp3,ind3] = min(abs(abs(RE(3,:)) - tmp1(k)));
        if tmp3 < 0.5
            i_REpk(k) = ind3;
        end
        %-------------------------- find where the change of CE relative to Ui is (10,20,30,40,50,10,20,30,40,50) percente
        [tmp3,ind3] = min(abs(abs(CE(2,1:IPC)) - tmp1(k)));
        if tmp3 < 0.5
            i_CEui(k) = ind3;
        end
        [tmp3,ind3] = min(abs(abs(CE(2,IPC:end)) - tmp1(k)));
        if tmp3 < 0.5
            i_CEui(k+5) = ind3+IPC-1;
        end
        %-------------------------- find where the change of CE relative to PEAK is (10,20,30,40,50,10,20,30,40,50) percente
        [tmp3,ind3] = min(abs(abs(CE(3,1:IPC)) - tmp1(k)));
        if tmp3 < 0.5
            i_CEpk(k) = ind3;
        end
        [tmp3,ind3] = min(abs(abs(CE(3,IPC:end)) - tmp1(k)));
        if tmp3 < 0.5
            i_CEpk(k+5) = ind3+IPC-1;
        end
    end
    i_Gen = [IPR , IPC , i_tt , i_end];
    ind_RE = [i_REui , i_REpk];
    ind_CE = [i_CEui , i_CEpk];
%% find the values based on the indices
    temp1 = NaN(9,length(i_Gen));
    for k = 1:length(i_Gen)
        if not(isnan(i_Gen(k)))
            temp1(1,k) = T(i_Gen(k)); %response time
            temp1(2,k) = RE(1,i_Gen(k)); % RE
            temp1(3,k) = round(RE(2,i_Gen(k)),1); % change of RE relative to Ui
            temp1(4,k) = round(RE(3,i_Gen(k)),1); % change of RE relative to PEAK_RE
            temp1(5,k) = CE(1,i_Gen(k)); % CE
            temp1(6,k) = round(CE(2,i_Gen(k)),1); % change of CE relative to Ui
            temp1(7,k) = round(CE(3,i_Gen(k)),1); % change of CE relative to PEAK_CE
            temp1(8,k) = KPT(2,i_Gen(k)); % lateral shift in knick point position
            temp1(9,k) = i_Gen(k); % the index
        end
    end
    temp1(1,3) = tt;
    temp2 = NaN(9,length(ind_RE));
    for k = 1:length(ind_RE)
        if not(isnan(ind_RE(k)))
            temp2(1,k) = T(ind_RE(k)); %response time
            temp2(2,k) = RE(1,ind_RE(k)); % RE
            temp2(3,k) = round(RE(2,ind_RE(k)),1); % change of RE relative to Ui
            temp2(4,k) = round(RE(3,ind_RE(k)),1); % change of RE relative to PEAK_RE
            temp2(5,k) = CE(1,ind_RE(k)); % CE
            temp2(6,k) = round(CE(2,ind_RE(k)),1); % change of CE relative to Ui
            temp2(7,k) = round(CE(3,ind_RE(k)),1); % change of CE relative to PEAK_CE
            temp2(8,k) = KPT(2,ind_RE(k)); % lateral shift in knick point position
            temp2(9,k) = ind_RE(k); % the index
        end
    end
    temp3 = NaN(9,length(ind_CE));
    for k = 1:length(ind_CE)
        if not(isnan(ind_CE(k)))
            temp3(1,k) = T(ind_CE(k)); %response time
            temp3(2,k) = RE(1,ind_CE(k)); % RE
            temp3(3,k) = round(RE(2,ind_CE(k)),1); % change of RE relative to Ui
            temp3(4,k) = round(RE(3,ind_CE(k)),1); % change of RE relative to PEAK_RE
            temp3(5,k) = CE(1,ind_CE(k)); % CE
            temp3(6,k) = round(CE(2,ind_CE(k)),1); % change of CE relative to Ui
            temp3(7,k) = round(CE(3,ind_CE(k)),1); % change of CE relative to PEAK_CE
            temp3(8,k) = KPT(2,ind_CE(k)); % lateral shift in knick point position
            temp3(9,k) = ind_CE(k); % the index
        end
    end 
    %----------------------------------------- How the "OUT" matrix is sorted:
    % 1:       @ peak of RE
    % 2:       @ peak of CE
    % 3:       @ model duration
    % 4:       @ end of the model
    %-----------------------------------------
    % 5-9:       @ 10 to 50 % RE relative to Ui
    % 10-14:   @ 10 to 50 % RE relative to PeakRE
    %-----------------------------------------
    % 15-19:   @ 10 to 50 % CE relative to Ui before the peakCE
    % 20-24:   @ 10 to 50 % CE relative to Ui after the peakCE
    %-----------------------------------------
    % 25-29:   @ 10 to 50 % CE relative to PeackCE before the peakCE
    % 30-34:   @ 10 to 50 % CE relative to PeakCE after the peakCE
    %-----------------------------------------
    OUT = [temp1 temp2 temp3]; %272
%%  Generate the final output as a vector
    OUT_RT = OUT(1,:); %34
    OUT_RE = OUT(2,:); %34
    OUT_REui = OUT(3,:); %34
    OUT_REpeak = OUT(4,:); %34
    OUT_CE = OUT(5,:); %34
    OUT_CEui = OUT(6,:); %34
    OUT_CEpeak = OUT(7,:); %34
    OUT_KPT = OUT(8,:); %34
    OUT_IND = OUT(9,:); %34
    final_output = [Npixel lat long alt Pi Pn Tn OUT_RT OUT_RE OUT_REui OUT_REpeak OUT_CE OUT_CEui OUT_CEpeak OUT_KPT OUT_IND]; % 313
    % final output coulmns
    %----------------------------------------------------------------%1:7 -------> Npixel , lat, long, Pi, Pn
    %----------------------------------------------------------------%8:41 -------> RT
    %----------------------------------------------------------------%42:75-------> RE
    %----------------------------------------------------------------%76:109----------> RE(Ui)
    %----------------------------------------------------------------%110:143 --------> RE(Peak)
    %----------------------------------------------------------------%144:177 -------> CE
    %----------------------------------------------------------------%178:211 -------> CE(Ui)
    %----------------------------------------------------------------%212:245 -------> CE(Peak)
    %----------------------------------------------------------------%246:279 -------->KPT
    
    %-------------------------------------------- for each parameters @:
    % 6:9 -------> peak of RE, peak of CE, model duration, end of the model
    % 10:14 -------> 10,20,30,40,50 of RE(Ui)
    % 15:19 -------> 10,20,30,40,50 of RE(Peak)
    % 20:24 -------> 10,20,30,40,50 of CE(Ui) before peak
    % 25:29 -------> 10,20,30,40,50 of CE(Ui) after peak
    % 30:34 -------> 10,20,30,40,50 of CE(Peak) before peak
    % 35:39 ------->10,20,30,40,50 of CE(Peak) after peak
end