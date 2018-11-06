function [A] = app_FUNC_roundvalues(A_org)
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
             while (B <= A(i-1)) || (B>A(i+1))
                 if B <= A(i-1)
                     r = r + 1;
                     B =  round(A(i),r);
                 end
                 if B > A(i+1)
                     B = A(i);
                 end
             end
         end
     A(i) = B;
 end