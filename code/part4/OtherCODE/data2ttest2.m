TrueLabel(:,3:4)=cellstr(PredictLabel);
m=0;
for i=1:950
    I1 = TrueLabel{i,1};
    ind = strfind(I1,';');
    if isempty(ind)
        a1 = strcmp(TrueLabel{i,1},TrueLabel{i,3});
        a2 = strcmp(TrueLabel{i,2},TrueLabel{i,4});
        if a1==1 && a2==1
            ind1 = find(h(i,:)==1);
            if length(ind1)>=1
                Protein(m+1,1) = antibody_ids(i);
                Protein(m+1,2:5) = TrueLabel(i,:);
                H(m+1,1:3) = h(i,:);
                H(m+1,4:6) = p_value(i,:);
                [m,n] = size(Protein);
            end
        end
    else
        B = strsplit(I1,';');
        ind2 = find(strcmp(B,TrueLabel{i,3}));
        if ~isempty(ind2)
%             a3 = strcmp(TrueLabel{i,1},TrueLabel{i,3});
            a4 = strcmp(TrueLabel{i,2},TrueLabel{i,4});
            if  a4==1
                ind3 = find(h(i,:)==1);
                if length(ind3)>=1
                    Protein(m+1,1) = antibody_ids(i);
                    Protein(m+1,2:5) = TrueLabel(i,:);
                    H(m+1,1:3) = h(i,:);
                    H(m+1,4:6) = p_value(i,:);
                    [m,n] = size(Protein);
                end
            end
        end
    end
end