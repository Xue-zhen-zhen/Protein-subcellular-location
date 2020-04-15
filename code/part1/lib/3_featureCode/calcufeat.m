function calcufeat(imgPath_i, writepath, sepaPath_i, dbtype, NLEVELS,feattype) %,patchsize,patchnumber
if strcmp(feattype,'SLFs')
    if exist( writepath,'file')
        load(writepath);
        if length(features)==592
            return
        else
            prp = writepath;
            prp((prp == '/') | (prp == '.')|(prp==':') | (prp =='\')) = '_';
            pr = ['tmp/calculating_' prp '.txt'];
            if ~exist( pr,'file')
                fr = fopen( pr, 'w');
            else
                return
            end
            I = imread(imgPath_i);
            load(sepaPath_i,'W');
            I = CleanBorders(I);
            I_unmixed = linunmix(I,W);
            prot= I_unmixed(:,:,2);
            nuc = I_unmixed(:,:,1);
            [feats1_field, ~] = Calculate_image(nuc, prot, dbtype, NLEVELS);
            features = feats1_field;
            save( writepath, 'features');
            fclose(fr);
            delete(pr);
        end
    else
        error( 'Please check');
    end
end

if strcmp(feattype,'SLFs_LBPs')
    if exist( writepath,'file')
        load(writepath);
        if length(features)==848
            return
        else
            prp = writepath;
            prp((prp == '/') | (prp == '.')|(prp==':') | (prp =='\')) = '_';
            pr = ['tmp/calculating_' prp '.txt'];
            if ~exist( pr,'file')
                fr = fopen( pr, 'w');
            else
                return
            end
            I = imread(imgPath_i);
            load(sepaPath_i,'W');
            I = CleanBorders(I);
            I_unmixed = linunmix(I,W);
            prot= I_unmixed(:,:,2);
            nuc = I_unmixed(:,:,1);
            spoints = [1, 0; 1, -1; 0, -1; -1, -1; -1, 0; -1, 1; 0, 1; 1, 1];
            lbpfeat = lbp(prot,spoints,0,'h');
            features(1,593:848) = lbpfeat;
            save( writepath, 'features');
            fclose(fr);
            delete(pr);
        end
    else
        error( 'Please input SLFs features');
    end
end

            

    

