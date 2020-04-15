clear all;clc;
load('./matfile/finallyProteinInfo.mat');
load('./matfile/SLFs_LBPsbiomarkerN2.mat');
GENE = unique(InfoProtein(:,1));
for i=1:length(GENE)
    index = find(strcmp(InfoProtein(:,1),GENE{i}));
    for j=1:length(index)
        proteinID(j,1) =str2num(InfoProtein{index(j),3}(4:end));
    end
    % ÏÈÑ¡³öÍ¼Ïñ
    [is,pos]=ismember(antibodyIDN(1:2365),proteinID);
    ID_index = find(is==1);
    if length(ID_index)==1
        H(i,:)=[2,2,2];P_value(i,:)=[2,2,2]; CI(i,1) = {[2,2,2]};
        selectImage{i,1}=[];
        clear proteinID
    else
        rand_index = randperm(length(ID_index));
        draw_rand_index = rand_index(1:2);
        SelectID = ID_index(draw_rand_index);
        SelectImage = imN(SelectID);
        selectImage(i,1) = { SelectImage};
        for Im=1:length(SelectImage)
            Im_index = find(strcmp(imN,SelectImage{Im}));
            Im_weight((Im-1)*7+1:Im*7,:) = WeightN(Im_index,:);
        end
        [h,p,ci] = ttest2(Im_weight(1:7,:),Im_weight(8:14,:));
        H(i,:)=h;P_value(i,:)=p; CI(i,1) = {ci};
        clear proteinID Im_weight
    end
    %     m=0;
    %     for q=1:length(proteinID)
    %         id_index = find(antibodyIDN==proteinID(q));
    %         imageNum = length(id_index)/7;
    %         Image = imN(id_index(1:imageNum));
    %         for k=1:length(Image)
    %             Im_index = find(strcmp(imN,Image{k}));
    %             Im_weight = mean(WeightN(Im_index,:),1);
    %             ID_Image_weight(k,:) = Im_weight;
    %         end
    %         ID_save(m+1:m+imageNum,1) = id_index(1:imageNum);
    %         Im_Weight(m+1:m+imageNum,:) = ID_Image_weight(:,:);
    %         [m,n] = size(ID_save);
    %         clear ID_Image_weight
    %     end
    %     if length(ID_save)==1
    %         H(i,:)=2; P_value(i,:)=2; CI(i,:) = [2,2];
    %     else
    %         rand_index = randperm(length(ID_save));
    %         draw_rand_index = rand_index(1:2);
    %         SelectID = ID_save(draw_rand_index);
    %         Prot_W = Im_Weight(draw_rand_index,:);
    %         [h,p,ci] = ttest2(Prot_W(1,:),Prot_W(2,:));
    %         H(i,:)=h; P_value(i,:)=p; CI(i,:) = ci;
    %         clear proteinID ID_save Im_Weight
    %     end
end
index0=find(H(:,1)==2);
H(index0,:)=[];
P_value(index0,:)=[];
CI(index0,:)=[];
selectImage(index0,:)=[];