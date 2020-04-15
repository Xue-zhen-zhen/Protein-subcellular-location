function  [a] = proteintestdata(Wtestpath,TestID,PathRoot,In,I_name,imagepath,condation)

for i=1:size(TestID,1)
    labelID = TestID(i,2);
    writepath = [Wtestpath num2str(labelID) '/'];
    if ~exist(writepath,'dir')
        mkdir(writepath)
    end
    ProtID = TestID(i,1);
    if strcmp(condation,'normal')
        protpath = [PathRoot num2str(ProtID) '\normal\colon\'];
    elseif strcmp(condation,'cancer')
        protpath = [PathRoot num2str(ProtID) '\cancer\colorectal cancer\'];
    end
    Img  = dir([protpath '*.jpg']);
    H = struct2cell(Img)';
    H = H(:,1);
    for k=1:length(H)
        idex = find(strcmp(In,H(k)));
        Image = I_name(idex);
        for g=1:length(Image)
            IMpath = [imagepath Image{g}];
            I = imread(IMpath);
            if ~exist([writepath Image{g}],'dir')
                imwrite(I,[writepath Image{g}]);
            end
        end
    end              
end
a=1;