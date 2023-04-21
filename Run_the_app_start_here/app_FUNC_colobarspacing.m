function spacing = app_FUNC_colobarspacing(P,dp,mn,mx,space)
%------------------------------------------------------------------------
% This function tries to make a meaningful spacing for the colorbars

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_MapMaker2
    %2-app_FUNC_precMapMakerPrec ????
    %3-app_FUNC_precMapMakerDif ????
    %4-app_FUNC_TargetLabel

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None

    % functions written out of the script:
    % None
%------------------------------------------------------------------------
PP = P(:);
dst = mn:dp:mx;
val = histcounts(PP,dst);
sm = sum(val);
tnprc = sm/space;
ind = 1;
t1 = 0;
t2 = [];
for i = 1 : length(val)
    t1 = t1 + val(i);
    if t1 >= tnprc
        ind = [ind i];
        t2 = [t2 t1];
        t1 = 0;
        if ind(end) == ind(end-1)
            ind(end) = i+1;
        end
    end
end

t3 = sum(t2 - tnprc);
if t1 <= t3
    ind(end) = length(dst);
else
    ind(end+1) = length(dst);
end
spacing = dst(ind);





% figure,
% histogram(PP,dst);
% 
% figure,
% histogram(PP,spacing);