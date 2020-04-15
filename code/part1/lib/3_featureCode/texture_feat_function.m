
function [ifeat,inames,tfeat,tnames1,wfeat,wnames] = texture_feat_function(protproc,nucproc,prot, dbtype, NLEVELS)


%%%% texture features %%%%%%

prot_128 = protproc*(127/255);
feat_128 = ml_texture( prot_128);

tfeat = double([mean(feat_128(1:13,[1 3]),2); mean(feat_128(1:13,[2 4]),2)])';

tnames1 = {'Angular second moment','Contrast','Correlation', ...
'Sum of squares','Inverse difference moment','Sum average', ...
    'Sum variance','Sum entropy','Entropy','Difference variance', ...
'Difference entropy','Information measure of correlation 1', ...
    'Information measure of correlation 2', ...
    'Angular second moment (diagonal)','Contrast (diagonal)', ...
    'Correlation (diagonal)', 'Sum of squares (diagonal)', ...
'Inverse difference moment (diagonal)','Sum average (diagonal)', ...
'Sum variance (diagonal)','Sum entropy (diagonal)', ...
'Entropy (diagonal)','Difference variance (diagonal)', ...
'Difference entropy (diagonal)', ...
    'Information measure of correlation 1 (diagonal)', ...
'Information measure of correlation 2 (diagonal)' ...
 };


% NLEVELS = 10;
% dbtype = 'db4';
try
[C,S] = wavedec2(double(protproc),NLEVELS,dbtype);
catch
fprintf('Error: wavedec2() failed at index: %d', ind)
%continue;
end

FPL = 2*(length(tnames1)+1);
wfeat = zeros( 1, FPL*NLEVELS);
wnames = [];

for k = 0:NLEVELS-1
[chd,cvd,cdd] = detcoef2('all',C,S,(NLEVELS-k));
A = [chd cvd];
A = A - min(A(:));
A = uint8(round(127*A/max(A(:))));
B = [cdd];
B = B - min(B(:));
B = uint8(round(127*B/max(B(:))));
feat = ml_texture( A);
feata = double([mean(feat(1:13,[1 3]),2); mean(feat(1:13,[2 4]),2)])';

feat = ml_texture( B);
featb = double([mean(feat(1:13,[1 3]),2); mean(feat(1:13,[2 4]),2)])';


wfeat(1,(FPL*k)+1:(k+1)*FPL) = [feata sqrt(sum(sum(A.^2))) featb sqrt(sum(sum(B.^2))) ];

wnamesA = [];
wnamesB = [];
for zed=1:length(tnames1)
wnamesA{zed} = ['HL_LH:' tnames1{zed} '_' num2str(NLEVELS-k)];
wnamesB{zed} = ['HH:' tnames1{zed} '_' num2str(NLEVELS-k)];
end
wnames = [wnames ...
wnamesA ['HL_LH:Energy at subband_' num2str(NLEVELS-k)] ...
wnamesB ['HH:Energy at subband_' num2str(NLEVELS-k)]...
];
end


sprot = size(prot);
prot_re = reshape(protproc,[sprot(1)*sprot(2) 1]);
nuc_re = reshape(nucproc,[sprot(1)*sprot(2) 1]);
mi = double(min(prot_re));    ma = double(max(prot_re));
tmp_idx = find((~prot_re)&(~nuc_re));
prot_re(tmp_idx) = [];
nuc_re(tmp_idx) = [];

prot_re8 = round( (double(prot_re)-mi) * 7/(ma-mi));
prot_re16 = round( (double(prot_re)-mi) * 15/(ma-mi));
prot_re32 = round( (double(prot_re)-mi) * 31/(ma-mi));
prot_re64 = round( (double(prot_re)-mi) * 63/(ma-mi));
prot_re128 = round( (double(prot_re)-mi) * 127/(ma-mi));


mi = double(min(nuc_re));    ma = double(max(nuc_re))+1;
ojoint = zeros(ma);
nuc_re8 = round( (double(nuc_re)-mi) * 7/(ma-mi));
nuc_re16 = round( (double(nuc_re)-mi) * 15/(ma-mi));
nuc_re32 = round( (double(nuc_re)-mi) * 31/(ma-mi));
nuc_re64 = round( (double(nuc_re)-mi) * 63/(ma-mi));
nuc_re128 = round( (double(nuc_re)-mi) * 127/(ma-mi));

ifeat1 = [mutualinformation( [prot_re8 nuc_re8]) ...
mutualinformation( [prot_re16 nuc_re16]) ...
mutualinformation( [prot_re32 nuc_re32]) ...
mutualinformation( [prot_re64 nuc_re64]) ...
mutualinformation( [prot_re128 nuc_re128])];

ifeat2 = [corr2( prot_re8, nuc_re8), ...
corr2( prot_re16, nuc_re16), ...
corr2( prot_re32, nuc_re32), ...
corr2( prot_re64, nuc_re64), ...
corr2( prot_re128, nuc_re128)];

ifeat = [ifeat1 ifeat2];
inames = {'nuc:mutual_information_8','nuc:correlation_8', ...
'nuc:mutual_information_16','nuc:correlation_16', ...
'nuc:mutual_information_32','nuc:correlation_32', ...
'nuc:mutual_information_64','nuc:correlation_64', ...
'nuc:mutual_information_128','nuc:correlation_128' ...
};

