function [PixelInfo,FinalRiver,FinalCosmo,FinalKPT,BriefOutput] = ...
    FUNC_MainModel(Npixel,TPi,TPn,lat,long,alt,Pi,Pn,Ui,Un,L,K,tt,d_cosmo)
%-------------------
	dx = L/1000;
    dt = 5;
    t_stop = 500000;
%-------------------
    h = 1.69;
    ka = 6.69;
    m = 0.5;
    n = 1;
%-------------------
    ksn = (Ui/(K*(Pi^m)))^(1/n);
    x = 0:dx:L;
    A = ka*(x.^h);
    A(1) = A(2);
    Af = fliplr(A);
    sumAterm = 0;
    for i = 1:length(x)
        sumAterm = Af(i)^-(m/n) + sumAterm;
        chi = sumAterm*dx;
        z(i) = ksn*chi;
    end
    z = fliplr(z);
    Z(1,:) = z;
%------------------- River Output
    [RiverOutput,Z] = FUNC_ModelCalc(t_stop,z,x,dx,K,A,Pn,m,n,Ui,Un,dt,Z);
%------------------- Change the units
    RiverOutput(2,:) = RiverOutput(2,:)*1000;  % erosion rate to [mm/y]
    Ui = Ui*1000; % initial rock uplift rate to [mm/yr]
    Pi = Pi * 1000;
    Pn = Pn * 1000;
%------------------- Find the peak and change relative to peak
    [~,mx_ind] = max(abs(RiverOutput(3,:)));
    mx_EM = RiverOutput(2,mx_ind);
    RiverOutput(4,:) = ((RiverOutput(2,:)-mx_EM)/mx_EM)*100; %  amount of change relative to maximum erosion [%]
%------------------- Extract the river erosion rate every 100 yrs instead of 5 yrs
    ndt = 100; % new dt
    steady = 500000;
    ind = 1:ndt/dt:size(RiverOutput,2);
    RiverData = RiverOutput(:,ind);
    Tn = RiverData(1,end); % time at end of the model
%------------------- Cosmo Output
    CosmoData = FUNC_CosmoErosion_mat(RiverData,Ui,Tn,ndt,d_cosmo,steady);
%------------------- File & Pixel info
    FileInfo = [TPi TPn tt L K Ui ndt];
    PixelInfo = [Npixel lat long alt Pi Pn Tn];
%------------------- Extract
[final_output,OUT,T,Tlong,RE,RElong,CE,CElong,KPT,KPTlong] = ...
    FUNC_ExtractParameters(FileInfo,PixelInfo,RiverData,CosmoData);



FinalRiver = NaN(1,5200);
FinalCosmo = NaN(1,5200);
FinalKPT = NaN(1,5200);
BriefOutput = NaN(1,313);


ten = find(Tlong == -10000);
sz = size(RElong(1,ten:end),2)+7;
FinalRiver(1,1:sz) = [PixelInfo RElong(1,ten:end)];
FinalCosmo(1,1:sz) = [PixelInfo CElong(1,ten:end)];
FinalKPT(1,1:sz) = [PixelInfo KPTlong(1,ten:end)];
BriefOutput(1,:) = final_output;


end
%%
function [RiverOutput,Z] = FUNC_ModelCalc(t_stop,z,x,dx,K,A,Pn,m,n,Ui,Un,dt,Z)
    t = 0:dt:t_stop;
    E_mean = NaN(2,length(t));
    kpt = NaN(1,length(t));
    for j = 1:length(t)
%------------------- calculate the channel slope along the profile
        S = abs(diff(z))./dx;
        S = [S S(end)];
%------------------- calculate discharge at each node. uses eq (2) from Royden and Perron 2013(JGR ES)        
        q = K*((A*Pn).^m);
%------------------- calculate the erosion magnitude over the timestep. uses eq (1) from Royden and Perron 2013 (JGR ES)
        E = q.*(S.^n);
        if j > 1
            E(end) = E(end-1);
        end
        E_mean(1,j) = mean(E); % mean erosion rate
        E_mean(2,j) = ((E_mean(1,j)-Ui)/Ui)*100; %  amount of change relative to Ui [%]
%------------------- estimate the location of the knickpoint by finding where the erosion rate changes the greatest along the profile
        E_grad = abs(diff(E))./dx;
        E_grad = [E_grad E_grad(end)];
        locale = find(E_grad == max(E_grad));
        if length(locale) > 1 % if there is two max value
            locale = locale(end); % then pick the first one
        end
%------------------- calculate the postion of the knickpoint relative to the profile length
        kpt(j) = x(locale); % location of knick point at each time step in [m]
%------------------- Now calculate the new elevation after "dt" years 
        % calculate the elevation change over the timestep based on the conservation of mass        
        Us = (Un - E)*dt;
        % calculate new elevations for each node
        z = z + Us; 
        z(end) = 0;
        Tn = (j-1)*dt; % last t
        t = 0:dt:Tn; % new t vector
% ----------------------------------------------------------------------------------------------------------------------------
        if (abs(E_mean(2,j)) < 1) && (Tn >= 1000) % if reaches to new steady state
            break
        end
    end
    E_mean = E_mean(:,1:length(t)); % delete extra cells with NaN values
    E_mean(3,:) = NaN(1,size(E_mean,2));
    kpt = kpt(1,1:length(t));
    Z(2,:) = z;
    
    RiverOutput = [t ; E_mean ; kpt];
end
%%
function [CosmoOutput] = FUNC_CosmoErosion_mat(RiverData,Ui,Tn,ndt,d_cosmo,steady)
    TER = RiverData(2,:);
    TER_tmp = Ui*ones(1,steady/ndt);
    TER = flip([TER_tmp TER]);
    TIME = -steady:ndt:Tn;
%-------------------
    prodratenucsurf = 3.92 * d_cosmo(1);                 % Nucleonic Production Rate at SLHL (see evel high latitude)
%     prodratemuonstoppedsurf = 0.012 * d_cosmo(2);        % Stipped Muonic Production Rate at SLHL
%     prodratemuonfastsurf = 0.039 * d_cosmo(3);           % Fast Muonic Production Rate at SLHL
    prodratemuonstoppedsurf = 0.0;        % Stipped Muonic Production Rate at SLHL
    prodratemuonfastsurf = 0.0;           % Fast Muonic Production Rate at SLHL
    a(1) = prodratenucsurf;        % Production parameter
    a(2) = prodratemuonstoppedsurf;
    a(3) = prodratemuonfastsurf;
    absorp(1) = 157;                    % Absorption length in g/cm2
    absorp(2) = 1500;
    absorp(3) = 4320;
    decay = 4.99746e-07;                           % Decay Constant
    rho = 2.7;                                  % Eock density
    cutoff = 0.001;                         % 1 permille Cutoff for Production Calculation at Depth
    interfacedepth = 46;
%-------------------
   for j = 1:length(TER)
            prodrateinstantaneous = 0;
            depth = 0;                          % in cm
            concsurf = 0;
        for k = j:length(TER)
            depth = depth + (TER(k))/10 * ndt * 0.5;
            prodratenuc = a(1) * exp(-rho / absorp(1) * depth);
            prodratemuonstopped = a(2) * exp(-rho / absorp(2) * depth) ;
            prodratemuonfast = a(3) * exp(-rho / absorp(3) * depth) ;
                prodrateinstantaneous =prodratenuc+prodratemuonstopped+prodratemuonfast;
           % if ((cutoff > 0) & (prodrateinstantaneous < cutoff * (prodratenucsurf + prodratemuonfastsurf + prodratemuonstoppedsurf)));
           if ((cutoff > 0) && (prodrateinstantaneous < cutoff * (prodratenucsurf + prodratemuonfastsurf + prodratemuonstoppedsurf)));
                k;
                break
            end
            concdepth = prodrateinstantaneous * ndt * exp(-ndt * decay);
            concdepth = concdepth * exp(-decay * depth / (TER(k)/10));
            concsurf = concsurf + concdepth;
            depth = depth + (TER(k))/10 * ndt * 0.5;
        end                     % end k loop
            cosmorate(j) = 0.1;
            conc = 0;                % First Guess for Concentration
        for q = 1:3
            conc = conc + (a(q) ./ (decay + (cosmorate(j)/10 * rho / (absorp(q)))));
        end
        while abs(conc / concsurf - 1) > 0.0001
            cosmorate(j) = cosmorate(j) - cosmorate(j) * (concsurf - conc) / concsurf;
            conc = 0;
            for p = 1:3
                conc = conc + (a(p) / (decay + (cosmorate(j)/10 * rho / (absorp(p)))));
            end
        end
    end                     % end j loop
%-------------------
        TER = flip(TER);
        cosmorate = flip(cosmorate);
        
        calc_erate (:,1) = TIME';                    % Assign Time t to column 1
        calc_erate (:,2) = TER';       % Assign true erosion rate eratetrue to column 2,4,6,8 etc.
        calc_erate (:,3) = cosmorate';          % Assign cosmogenic erosion rate erosrate to column 3,5,7,9 etc.
        
        CosmoOutput(1,:) = TIME;
        CosmoOutput(2,:) = cosmorate;
end