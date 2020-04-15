
function [feats1, names1] = Calculate_image(nuc,prot) 

% CALCULATES IMAGE LEVEL FEATURES

protproc=[]; nucproc=[]; objnames=[]; objfeat=[]; fnames=[]; ffeat=[]; onames=[]; ofeat=[]; mnames=[]; mfeat=[];

try
    [protproc, nucproc, objnames, objfeat, fnames, ffeat, onames, ofeat, mnames, mfeat] = MoreFeatures(nuc,prot);
catch err
    rethrow(err)
end

ifeat=[]; inames=[]; tfeat=[]; tnames1=[]; wfeat=[]; wnames=[];

try
    [ifeat,inames,tfeat,tnames1,wfeat,wnames] = texture_feat_function(protproc,nucproc,prot);
catch err
    rethrow(err)
end

if isempty(ofeat)
    ofeat = zeros(1,4);
    onames = {'Fraction of protein object area that overlaps the reference area', ...
         'Fraction of referece area that overlaps the protein area', ...
         'Fraction of protein intensity that overlaps the reference area', ...
         'Avg distace of protein containing pixel to nearest pixel of reference'};
end
feats1 = [ffeat ofeat mfeat objfeat ifeat tfeat wfeat];
names1 = [fnames onames mnames objnames inames tnames1 wnames];






