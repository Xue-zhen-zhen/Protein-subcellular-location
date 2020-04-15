truelabel = importdata('.\excel\TRUELabel.xlsx');
for i=1:795
    TNlabel = truelabel{i,1};
    b1 = strfind(TNlabel,';');
    if length(b1)==0
        a1 = strcmp(truelabel{i,1},PredictLabel{i,1});
    else
        TNlabel=strsplit(TNlabel,';');
        a1 = strcmp(PredictLabel{i,1},TNlabel);
    end
    %     a1 = strcmp(truelabel{i,1},PredictLabel{i,1});
    TClabel = truelabel{i,2};
    b = strfind(TClabel,';');
    if length(b)==0
        a2 = strcmp(truelabel{i,2},PredictLabel{i,2});
    else
        TClabel=strsplit(TClabel,';');
        a2 = strcmp(PredictLabel{i,2},TClabel);
    end
    if ~isempty(find(a1==1)) && ~isempty(find(a2==1))
        if ~isempty(find(h(i,:)==1))
            Y{i,1} = 'yes';
        else
            Y{i,1} = 'no';
        end
    else
        Y{i,1} = 'no';
    end
end

