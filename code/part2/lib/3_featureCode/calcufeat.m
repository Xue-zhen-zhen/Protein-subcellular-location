function calcufeat(imgPath_i, writepath, sepaPath_i, dbtype, NLEVELS,feattype,patchsize,patchnumber)
if strcmp(feattype,'SLFs')
    if exist( writepath,'file')
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
        features = calcPNASfeat(imgPath_i, sepaPath_i, numPoints, sizePatch); %,Region_coord,knownFeat
        save( writepath, 'features');
        fclose(fr);
        delete(pr);
    end
end

if strcmp(feattype,'SLFs_LBPs')
    if exist( writepath,'file')
        load(writepath);
        return
    else
        ind = strfind(writepath,'\');
        SLFswritepath = [writepath(1:ind(5)) 'SLFs' writepath(ind(6):end)];
        load(SLFswritepath);
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
        featuresLBP = calcPNASfeatLBP(imgPath_i, sepaPath_i, numPoints, sizePatch,features.centers_PNAS,features.feats592_PNAS);
        save( writepath, 'featuresLBP');
        fclose(fr);
        delete(pr);
    end
end

            

    

