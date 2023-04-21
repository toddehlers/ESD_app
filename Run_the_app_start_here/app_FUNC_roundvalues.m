function [A] = app_FUNC_roundvalues(A_org)
%------------------------------------------------------------------------
% This function tries to round the values in the most proper way

%++++++++++++++++
% This function is used in:
    %1-app_FUNC_MapMaker2
    %2-app_FUNC_ProfileMaker3
    %3-app_FUNC_precMapMakerPrec ???
    %4-app_FUNC_precMapMakerDif ???
    %5-app_FUNC_TargetLabel

%++++++++++++++++
% This function uses the following functions
    % functions written in the script:
    % None
    
    % functions written out of the script:
    % None
%------------------------------------------------------------------------
 A = A_org;
 A(1) = round(A(1),0);
 for i = 2 : length(A)
     r = 0;
     B = round(A(i),r);
         if i == length(A)
             while B <= A(i-1)
                 if B <= A(i-1)
                     r = r + 1;
                     B =  round(A(i),r);
                 end
             end
         else
             while (B <= A(i-1)) || (B>=A(i+1))
                      r = r + 1;
                     B =  round(A(i),r);
%                  if B <= A(i-1)
%                      r = r + 1;
%                      B =  round(A(i),r);
%                  end
%                  if B > A(i+1)
%                      B = A(i);
%                  end
             end
         end
     A(i) = B;
 end