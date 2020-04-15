clear all;clc;
load('protein22.mat');
load('./matfile/SLFs_LBPsliteratureN2.mat');
GENE = unique(DataInfo(:,1));
for i=1:length(GENE)
    index = find(strcmp(DataInfo(:,1),GENE{i}));
    for j=1:length(index)
        proteinID(j,1) =str2num(DataInfo{index(j),3}(4:end));
    end
    % ÏÈÑ¡³öÍ¼Ïñ
    [is,pos]=ismember(antibodyIDN(1:111),proteinID);
    ID_index = find(is==1);
    %Protimage = imN(ID_index);
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
%     rand_index = randperm(length(ID_save));
%     draw_rand_index = rand_index(1:2);
%     SelectID = ID_save(draw_rand_index);
%     Prot_W = Im_Weight(draw_rand_index,:);
%     [h,p,ci] = ttest2(Prot_W(1,:),Prot_W(2,:),'Alpha',0.01);
%     H(i,:)=h; P_value(i,:)=p; CI(i,:) = ci;
%     clear proteinID ID_save Im_Weight
end
save('./matfile/normalttest2.mat','H','P_value','CI','selectImage')
