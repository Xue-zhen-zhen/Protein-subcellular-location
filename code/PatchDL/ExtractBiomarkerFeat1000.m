function didwegt = ExtractBiomarkerFeat1000(path1,path2,path3,LoadNetwork,datatype)


addpath ./lib
addpath ./othercode

normalPath = [path1 '\' path2 '\'];
cancerPath = [path1 '\' path3 '\'];

imds = imageDatastore(normalPath,...
                      'IncludeSubfolders',true ,...
                      'LabelSource','foldernames'); 
imdsC = imageDatastore(cancerPath,...
            'IncludeSubfolders',true ,...
            'LabelSource','foldernames'); 
        
 switch LoadNetwork
    case 'resent18'
        net = resnet18;
        layer = 'fc1000';
    case 'resent50'
        net = resnet50;
        layer = 'fc1000';
    case 'densenet201'
        net = densenet201;
        layer = 'fc1000';
    case 'googlenet'
        net = googlenet;
        layer = 'loss3-classifier';
    case 'inceptionv3'
        net = inceptionv3;
        layer = 'predictions';
    case 'resnet101'
        net = resnet101;
        layer = 'fc1000';
    otherwise
end
        
inputSize = net.Layers(1).InputSize;
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimds = augmentedImageDatastore(inputSize(1:2),imds, ...
    'DataAugmentation',imageAugmenter);
augimdsC= augmentedImageDatastore(inputSize(1:2),imdsC,...
          'DataAugmentation',imageAugmenter);
featuresN = activations(net,augimds,layer,'OutputAs','rows');
featuresC = activations(net,augimdsC,layer,'OutputAs','rows');

sanePath_N = ['.\part4\biomarkerfeatures\' datatype '\' path2 '\'];
if ~exist(sanePath_N,'dir')
    mkdir(sanePath_N )
end
sanePath_C = ['.\part4\biomarkerfeatures\' datatype '\' path3 '\'];
if ~exist(sanePath_C,'dir')
    mkdir(sanePath_C )
end

save([sanePath_N LoadNetwork '.mat'],'featuresN','imds');
save([sanePath_C LoadNetwork '.mat'],'featuresC','imdsC');

didwegt = 1;