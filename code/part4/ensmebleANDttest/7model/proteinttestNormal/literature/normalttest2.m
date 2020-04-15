clear all;clc; %一个模型的结果
load('protein22.mat');
load('E:\works2\work_predict\SLFsfeaturesttestresult\6model\4_classification\literatureclassresult\predict\resnet18\normal\lin_db4_75_205\cytoplasmic&membranous_cytoplasmic&membranous&nuclear_nuclear.mat')
GENE = unique(DataInfo(:,1));
for i=1:length(GENE)
    index = find(strcmp(DataInfo,GENE{i}));
    for j=1:length(index)
        proteinID(j,1) =str2num(DataInfo{index(j),3}(4:end));
    end
    [is,pos]=ismember(alabels,proteinID);
    ID_index = find(is==1);
    Protimage = images(ID_index);
    rand_index = randperm(length(ID_index));
    draw_rand_index = rand_index(1:2);
    SelectID = ID_index(draw_rand_index);
    Prot_W = weights(SelectID,:);
    [h,p,ci] = ttest2(Prot_W(1,:),Prot_W(2,:));
    H(i,:)=h;P_value(i,:)=p; CI(i,:) = ci;
    clear proteinID
end
    
    
    
    
    