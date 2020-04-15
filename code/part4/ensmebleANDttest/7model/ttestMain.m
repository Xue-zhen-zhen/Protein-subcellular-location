 %Run loadcancer.m and loadnormal.m before executing this code
 % Then The integration results of 7 models are saved in the ./matfile/ folder.
 % 
 
%  load('liter(2).mat')
%  InfoProtein = ProteinSIQL;
%  load('SLFs_LBPsliteratureC1.mat');
%  load('SLFs_LBPsliteratureN1.mat');

 load('finallyProteinInfo.mat');
 load('.\matfile\SLFs_LBPsbiomarkerC2.mat')
 load('.\matfile\SLFs_LBPsbiomarkerN2.mat')
 
 Gene = unique(InfoProtein(:,1));
 m=0;m11=0;
 for i=1:length(Gene)
    index1 = find(strcmp(InfoProtein(:,1),Gene{i})); 
    Genename(i,1) = InfoProtein(index1(1),2);
    for j=1:length(index1)
        AntibodyID = str2num(InfoProtein{index1(j),3}(4:end));
        indN1 = find(antibodyIDN==AntibodyID);
        indC1 = find(antibodyIDC==AntibodyID);
        indN(m+1:m+length(indN1),1)= indN1;
        indC(m11+1:m11+length(indC1),1)= indC1;
        [m,n]= size(indN);
        [m11,n1] = size(indC);
    end
    m=0;m11=0;
    TrueLabel_N = unique(labelsN(indN));
    TrueLabel_C = unique(labelsC(indC));
    trueLabel_N = Iden_Truelabel(TrueLabel_N);
    trueLabel_C = Iden_Truelabel(TrueLabel_C);
    TRUELabel{i,1} = trueLabel_N; 
    TRUELabel{i,2} = trueLabel_C;
    LN = PredLabelN(indN);
    LC = PredLabelC(indC);
    L_N = unique(LN);  L_C =  unique(LC);
    %%%
%     PREDLabel_N = Iden_Truelabel(L_N);
%     PREDLabel_C = Iden_Truelabel(L_C);
%     PredictLabel{i,1} = PREDLabel_N; 
%     PredictLabel{i,2} = PREDLabel_C ;
    %%%
    
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
    clear indN indC indN1 indC1;
 end
ap=1;