function [] = app_FUNC_DataFinder(app)
%------------------------------------------------------------------------
% InputData is a file including all the calculated erosion and response time values and specific points
% cf is the path of the main code
% vTPi is a vector with 4 elements which can be 0 or 1 [PL LGM MH PI]
% vTPn is a vector with 4 elements which can be 0 or 1 [LGM MH PI PD]
% vL is a vector with 3 elements which can be 0 or 1 [10000 40000 80000]
% vUi is a vector with 3 elements which can be 0 or 1 [0.01 0.1 1]
% vK is a vector with 3 elements which can be 0 or 1 [5e-5 1e-6 1e-7]

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_GeneralCheckBox

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
    vTPi = app.vTPi; % initial time chekcbox value
    vTPn = app.vTPn; % final time checkbox value
    vL = app.vL; % River length checkbox value
    vUi = app.vUi; % Initial rock uplift checkbox value
    vK = app.vK; % bedrock detachment checkbox value
%-------------------------------------------------------------------------------------------------------------
    TP1 = ["PL","LGM","MH","PI"];
    TP2 = ["LGM","MH","PI","PD"];
    L1 = ["10" "40" "80"];
    Ui1 = ["0.01" "0.10" "0.50" "1.00"];
    K1 = ["5e-05" "1e-06" "1e-07"];
    inpTPi = TP1(vTPi);
    inpTPn = TP2(vTPn);
    inpL = L1(vL);
    inpUi = Ui1(vUi);
    inpK = K1(vK);
    all_data = app.BriefData;
    %-----------------------------------------
    for i = 1:length(all_data)
        vnam = all_data(i).name;
        vdsh = strfind(vnam,"_");
        vbo = strfind(vnam,"(");
        vbc = strfind(vnam,")");
        TPi = vnam(vbo(1)+1:vdsh(2)-1);
        TPn = vnam(vdsh(2)+1:vbc(1)-1);
        L = vnam(vbo(2)+1:vdsh(4)-1);
        Ui = vnam(vdsh(4)+1:vdsh(5)-1);
        K = vnam(vdsh(5)+1:vbc(2)-1);
        % extracted info of each *.mat file
        S_data{i,1} = TPi;
        S_data{i,2} = TPn;
        S_data{i,3} = L;
        S_data{i,4} = Ui;
        S_data{i,5} = K;
        S_data{i,6} = string(all_data(i).name);
        S_data{i,7} = string(all_data(i).folder) + filesep + string(all_data(i).name);
    end
    j = 0;
    pick_mdl = 0;
    for tpi = 1:length(inpTPi)
        TPi1 = inpTPi(tpi);
        for tpn = 1:length(inpTPn)
            TPn1 = inpTPn(tpn);
            for l = 1:length(inpL)
                L1 = inpL(l);
                for ui = 1:length(inpUi)
                    Ui1 = inpUi(ui);
                    for k = 1:length(inpK)
                        K1 = inpK(k);
                        B = string(TPi1)+string(TPn1)+string(L1)+string(Ui1)+string(K1);
                        for i = 1:length(all_data)
                            A = string(S_data(i,1))+string(S_data(i,2))+string(S_data(i,3))+string(S_data(i,4))+string(S_data(i,5));
                            if A == B
                                j = j+1;
                                pick_mdl(j) = i;
                            end
                        end
                    end
                end
            end
        end
    end
    %-----------------------------------------
    if pick_mdl ~= 0
        for i = 1:length(pick_mdl)
            % pick the path of the selected models (e.g. ...\OutputAsMatrix\LGM_MH\10_0.01_1e-06)
            InputData(i,:) = S_data(pick_mdl(i),:); 
        end
    else
        InputData = [];
    end
    app.InputData = InputData;
end