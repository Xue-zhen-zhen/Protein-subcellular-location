function calcufeat(imgPath_i, writepath, sepaPath_i, dbtype, NLEVELS,feattype,patchsize,patchnumber)
if strcmp(feattype,'SLFs')
    if exist(writepath,'file')
        load(writepath);
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
        numPoints=str2num(patchnumber);
        sizePatch=str2num(patchsize);
        features = calcPNASfeat(imgPath_i, sepaPath_i, numPoints, sizePatch, dbtype, NLEVELS); %,Region_coord,knownFeat
        save( writepath, 'features');
        fclose(fr);
        delete(pr);
        
    end
end
if strcmp(feattype,'SLFs_LBPs')
    if exist(writepath,'file')
        return
    else
        load(writepath);
        Region_coord = features.centers_PNAS;
        feats592_PNAS = features.feats592_PNAS;
        [m,n] = size(features.feats592_PNAS);
        if n==592
            prp = writepath;
            prp((prp == '/') | (prp == '.')|(prp==':') | (prp =='\')) = '_';
            pr = ['tmp/calculating_' prp '.txt'];
            if ~exist( pr,'file')
                fr = fopen( pr, 'w');
            else
                return
            end
            numPoints= m;
            sizePatch=str2num(patchsize);
            features = addlbpfeat(imgPath_i, sepaPath_i, numPoints, sizePatch ,Region_coord,feats592_PNAS);
            save( writepath, 'features');
            fclose(fr);
            delete(pr);
        else
            error( 'Please input 592 features');
        end
    end
else
    error( 'Please input SLFs features');
end
end
