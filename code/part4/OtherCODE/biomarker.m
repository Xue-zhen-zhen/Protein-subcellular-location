% clear all
% load('weights_cancer1.mat');
% load('weights_normal1.mat');
load('ID_Labels.mat','antibody_ids');
[alabels_normal,weights_normal,predlabels_normal] = normal();
[alabels_cancer,weights_cancer,predlabels_cancer] = cancer();
for i=1:length(antibody_ids)
    ind_n = find(alabels_normal == str2num(antibody_ids{i}));
    ind_c = find(alabels_cancer == str2num(antibody_ids{i}));
    x_n = weights_normal(ind_n,1:3);
    y_c = weights_cancer(ind_c,1:3);
    x_n_label = unique(predlabels_normal(ind_n));
    y_c_label = unique(predlabels_cancer(ind_c));
    [H(i,1),P(i,1),CI]=ttest2(x_n(:,1),y_c(:,1),0.05);
    [H(i,2),P(i,2),CI]=ttest2(x_n(:,2),y_c(:,2),0.05);
    [H(i,3),P(i,3),CI]=ttest2(x_n(:,3),y_c(:,3),0.05);
    if ~isequal(x_n_label,y_c_label)
        d = setdiff(union(x_n_label,y_c_label),x_n_label);
        if length(d)==1
            if H(i,d)==1
                flag(i)=1;
            else
                flag(i)=0;
            end
        elseif length(d)==2
            if H(i,d(1))==1 ||  H(i,d(2))==1
                flag(i)=1;
            else
                flag(i)=0;
            end
        elseif length(d)==3
            if H(i,d(1))==1 ||  H(i,d(2))==1 || H(i,d(3))==1
                flag(i)=1;
            else
                flag(i)=0;
            end
        end
    else
        flag(i)=0;
    end 
end
diff_loca = find(flag==1);
[n,b] = find(H==1);
diff_pvalue=unique(n);
save('./biomarkerID.mat','antibody_ids','diff_loca','diff_pvalue');