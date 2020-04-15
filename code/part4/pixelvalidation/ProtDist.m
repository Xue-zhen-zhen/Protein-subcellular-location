clear all;clc;
load('./matfile/protein22.mat')
load('./matfile/literGene.mat','NotbiomarkerGene')
Gene = NotbiomarkerGene;
% Gene = unique(DataInfo(:,1));
for g=1:length(Gene)
    index = find(strcmp(DataInfo(:,1),Gene{g}));
    for t=1:length(index)
        IDnumber(t,1) = str2num(DataInfo{index(t),3}(4:end));
    end
    m=0;m1=0;
    for i=1:length(IDnumber)
        ImagePath_C = ['E:/works2/work_predict/data/1_images/' num2str(IDnumber(i)) '/cancer/colorectal cancer/'];
        ImagePath_N = ['E:/works2/work_predict/data/1_images/' num2str(IDnumber(i)) '/normal/colon/'];
        ImageDir_C = dir([ImagePath_C '*.jpg']);
        ImageDir_N = dir([ImagePath_N '*.jpg']);
        Image_C(m+1:m+length(ImageDir_C),:) = ImageDir_C;
        Image_N(m1+1:m1+length(ImageDir_N),:) = ImageDir_N;
        [m,C] = size(Image_C);
        [m1,N] = size(Image_N);
    end
    for j=1:length(Image_C)
        imgC = imread([Image_C(j).folder '\' Image_C(j).name]);
        load('Wbasis.mat');
        I = CleanBorders(imgC);
        I_unmixed = linunmix(I,W);
        prot= I_unmixed(:,:,2);
        nuc = I_unmixed(:,:,1);
        [c1,n1]=imhist(prot);
        c1 = c1/size(prot,1)/size(prot,2);
        Bin_C(:,j) =c1;
    end
    a = (sum(Bin_C,2))/size(Bin_C,2);
    C_median  = fix(size(Bin_C,2)/2);
    if C_median>0
        rand_index = randperm(size(Bin_C,2));
        a1 = Bin_C(:,rand_index(1:C_median));
        a2 = Bin_C(:,rand_index(C_median+1:2*C_median));
        a3 = (sum(a1,2))/size(a1,2);
        a4 = (sum(a2,2))/size(a2,2);
        CCdist = pdist2(a3',a4');
    else
        error( 'Please check')
    end
    for q=1:length(Image_N)
        imgN = imread([Image_N(q).folder '\' Image_N(q).name]);
        load('Wbasis.mat');
        I = CleanBorders(imgN);
        I_unmixed = linunmix(I,W);
        protN= I_unmixed(:,:,2);
        nucN = I_unmixed(:,:,1);
        [c2,n2]=imhist(protN);
        c2 = c2/size(protN,1)/size(protN,2);
        Bin_N(:,q) = c2;
    end
    b = (sum(Bin_N,2)) /size(Bin_N,2);
    N_median  = fix(size(Bin_N,2)/2);
    if N_median>0
        rand_indexN= randperm(size(Bin_N,2));
        b1 = Bin_N(:,rand_indexN(1:N_median));
        b2 = Bin_N(:,rand_indexN(N_median+1:2*N_median));
        b3 = (sum(b1,2))/size(b1,2);
        b4 = (sum(b2,2))/size(b2,2);
        NNdist = pdist2(b3',b4');
    else
        error( 'Please check')
    end
    protdist(g,1) = pdist2(a',b');
    CCDist_c(g,1) = CCdist;
    NNDist_n(g,1) = NNdist;
    clear Image_C Image_N Bin_C Bin_N IDnumber
    
end
save('./NotPROTdist.mat','protdist','CCDist_c','NNDist_n')
figure(1)
histogram(protdist);
axis([0 0.5 0 13]); legend('normal VS cancer');

figure(2)
hist(CCDist_c)
axis([0 0.5 0 13]); legend('cancer VS cancer');

figure(3)
hist(NNDist_n)
axis([0 0.5 0 13]); legend('normal VS normal');