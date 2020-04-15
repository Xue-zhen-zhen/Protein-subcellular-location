primitive_path = './Patch/224/';
primitive_List = dir(fullfile(primitive_path));
NUM = 35;
for i=3:size(primitive_List,1)
    List = dir([primitive_path '/' primitive_List(i).name '/']);
    writepath = ['./Patch_number/number=' num2str(NUM) '/' primitive_List(i).name '/'];
    if ~exist(writepath,'dir')
        mkdir(writepath);
    end
    for j=3:size(List,1)
        Im_n = List(j).name;
        ID0 = strfind(Im_n,'(');
        ID1 = strfind(Im_n,')');
        patch_id = str2num(Im_n(ID0:ID1));
        if patch_id <= NUM
            image_path = [List(j).folder '\' Im_n];
            I = imread(image_path);
            if ~exist([writepath Im_n],'dir')
                imwrite(I,[writepath Im_n]);
            end
        end
    end
end

