function spacing = app_FUNC_colobarspacing(P,dp,mn,mx,space)
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