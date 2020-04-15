function setup( dataroot)
%  SETUP( DATAROOT)  initializes folder paths 
%    Input DATAROOT is by default './data'



if ~exist( 'dataroot','var')
    dataroot = 'data';
end

addpath ./lib/0_generalCode;
addpath ./lib/1_imageParseCode;
addpath ./lib/2_unmixingCode;
addpath ./lib/3_featureCode;
addpath ./lib/4_classificationCode;
addpath ./lib/4_classificationCode/libsvm-3.23/matlab;



directoryFun( '.', dataroot);
directoryFun( dataroot, '1_images');
directoryFun( dataroot, '2_unmixedImages');
directoryFun( dataroot, '3_features');
directoryFun( dataroot, '4_classification');


return

function directoryFun( prnt, chld)

d = [prnt '/' chld];
if ~exist( d, 'dir')
    mkdir( prnt, chld);
end
    
return
