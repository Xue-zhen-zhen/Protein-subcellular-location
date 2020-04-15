% load('.\4_classification\predict\densenet201\normal\densenet201_slf+lbp.mat', 'alabels', 'predlabels')
% IDgooglenetN = alabels; PLabelGooN = predlabels;
% load('.\4_classification\predict\densenet201\cancer\densenet201_slf+lbp.mat', 'alabels', 'predlabels')
% ID50C = alabels; PLabel50C = predlabels;
load('SLFs_LBPsbiomarkerC2.mat')
load('SLFs_LBPsbiomarkerN2.mat')
antibodyID = unique(antibodyIDN);
for i=1:length(antibodyID)
    indN = find(antibodyIDN==antibodyID(i));
    indC = find(antibodyIDC==antibodyID(i));
%     ind0 = find(IDgooglenetN==antibodyID(i));
%     ind1 = find(ID50C==antibodyID(i));
    trueLabel(i,1) = unique(labelsN(indN));
%     trueLabel(i,2) = unique(labelsC(indC));
%     LN = PLabelGooN(ind0);
%     LC = PLabel50C(ind1);
    LN = PredLabelN(indN);
    LC = PredLabelC(indC);
    L_N = unique(LN);  L_C =  unique(LC);
    if length(L_N)==1
        if L_N==1
           PredictLabel{i,1}= 'Cytoplasmic&membranous';
        elseif L_N==2
           PredictLabel{i,1}= 'Cytoplasmic&membranous&nuclear';
        elseif L_N==3
           PredictLabel{i,1}= 'Nuclear';
        end
    else
        countN = hist(LN,L_N);
        [m1,n1] = max(countN);
        a = L_N(n1);
        if a==1
           PredictLabel{i,1}= 'Cytoplasmic&membranous';
        elseif a==2
           PredictLabel{i,1}= 'Cytoplasmic&membranous&nuclear';
        elseif a==3
           PredictLabel{i,1}= 'Nuclear';
        end        
    end
    if length(L_C)==1
        if L_C==1
           PredictLabel{i,2}= 'Cytoplasmic&membranous';
        elseif L_C==2
           PredictLabel{i,2}= 'Cytoplasmic&membranous&nuclear';
        elseif L_C==3
           PredictLabel{i,2}= 'Nuclear';
        end
    else
        countC = hist(LC,L_C);
        [m0,n0] = max(countC);
         b = L_C(n0);
         if b==1
           PredictLabel{i,2}= 'Cytoplasmic&membranous';
        elseif b==2
           PredictLabel{i,2}= 'Cytoplasmic&membranous&nuclear';
        elseif b==3
           PredictLabel{i,2}= 'Nuclear';
        end
    end
    WN = WeightN(indN,:);
    WC = WeightC(indC,:);
    [h(i,:),p_value(i,:)]=ttest2(WC,WN,0.05);
end
