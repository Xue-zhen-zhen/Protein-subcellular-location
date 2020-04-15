PATH = 'E:\works2\work_predict\data\1_images\';
LIST = dir(fullfile(PATH));
for i=3:size(LIST,1)
    LIST_normal = [PATH LIST(i).name '\normal\colon\'];
    LIST_cancer = [PATH LIST(i).name '\cancer\colorectal cancer\'];
    normalImages = dir([LIST_normal '*.jpg']);
    cancerImages = dir([LIST_cancer '*.jpg']);
    for j=1:size(normalImages)
        ImageN = strfind(normalImages(j).name,'_');
        LabelN = normalImages(j).name(1:ImageN(1)-1);
        ImagePath = [normalImages(j).folder '\' normalImages(j).name];
        I = imread(ImagePath);
        if strcmp(LabelN,'��Ĥ')
            writePath = 'E:\Deeplearning\ImagesDataBiomarker\literaturedata\normal\Cytoplasmic&membranous';
            writePath = [writePath '\' normalImages(j).name];
            imwrite(I,writePath);
        elseif strcmp(LabelN,'��Ĥ&��')
            writePath = '.\ImagesDataBiomarker\literaturedata\normal\Cytoplasmic&membranous&nuclear';
            writePath = [writePath '\' normalImages(j).name];
            imwrite(I,writePath);
        elseif strcmp(LabelN,'��')
            writePath = '.\ImagesDataBiomarker\literaturedata\normal\Nuclear';
            writePath = [writePath '\' normalImages(j).name];
            imwrite(I,writePath);
        end
    end
    for k=1:size(cancerImages)
        ImageC = strfind(cancerImages(k).name,'_');
        LabelC = cancerImages(k).name(1:ImageC(1)-1);
        ImagePathC = [cancerImages(k).folder '\' cancerImages(k).name];
        IC = imread(ImagePathC);
        if strcmp(LabelC,'��Ĥ')
            writePathC = '.\ImagesDataBiomarker\literaturedata\cancer\Cytoplasmic&membranous';
            writePathC = [writePathC '\' cancerImages(k).name];
            imwrite(IC,writePathC);
        elseif strcmp(LabelC,'��Ĥ&��')
            writePathC = '.\ImagesDataBiomarker\literaturedata\cancer\Cytoplasmic&membranous&nuclear';
            writePathC = [writePathC '\' cancerImages(k).name];
            imwrite(IC,writePathC);
        elseif strcmp(LabelC,'��')
            writePathC = '.\ImagesDataBiomarker\literaturedata\cancer\Nuclear';
            writePathC = [writePathC '\' cancerImages(k).name];
            imwrite(IC,writePathC);
        end
    end
end
    
            