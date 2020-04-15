function [protproc, nucproc, objnames, objfeat, fnames, ffeat, onames, ofeat, mnames, mfeat] = MoreFeatures(nuc,prot)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional Features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% take away this if statement.  we are always going to calculate all from now on.
%if(addfeat)

sfeats1 = [];
names1 = [];

% filter features
sprot = size(prot);
ffeat = [sum(prot(:)) sum(nuc(:)) sprot(1) sprot(2)];
fnames = {'total protein staining','total hematoxylin staining','number of rows in image','number of columns in image'}; 

% overlap features
protproc = prot;
thr = graythresh(prot(prot>0))*255;
protproc(protproc<thr) = 0;

% protproch = prot;
% [cc bb] = imhist(prot);
% csum = cumsum(cc) / sum(cc);
% hthr = bb(csum>0.95);  hthr = hthr(1);
% protproch(protproch<hthr) = 0;

protprocm = prot;
mthr = graythresh(prot(prot>thr))*255;
protprocm(protprocm<mthr) = 0;

protproc2 = protprocm;
bwl=bwlabel(protproc2>0,4);
props = regionprops( bwl,'Area');
stats = zeros(size(props));
for j=1:length(props)
  stats(j) = props(j).Area;
end
idx = find(stats>50);%50
bw = ismember(bwl,idx);
protproc2(~bw) = 0;

bwl=bwlabel(protproc2>0,4);
props = regionprops( bwl,'Area','EulerNumber');
stats = zeros(length(props),2);
for j=1:length(props)
  stats(j,1) = props(j).Area;
stats(j,2) = props(j).EulerNumber;
end
objfeat = [mean(stats(:,1)) std(stats(:,1)) mean(stats(:,2)) std(stats(:,2))];
objnames = [];
objnames{1} = 'Avg. prot. obj. size';
objnames{2} = 'Std. prot. obj. size';
objnames{3} = 'Avj. prot. obj. Euler #';
objnames{4} = 'Std. prot. obj. Euler #';

nucproc = nuc;
thr = graythresh(nuc(nuc>0))*255;
thr2 = graythresh(nuc(nuc>thr))*255;
nucproc(nucproc<thr2) = 0;

%figure
%imshow(nucproc)

if max(max(nucproc))< 10
nucproc = nuc;    
nucproc(nucproc<thr) = 0;    
end

%figure
%imshow(nucproc)

bwl=bwlabel(nucproc>0,4);
props = regionprops( bwl,'Area');
stats = zeros(size(props));
for j=1:length(props)
  stats(j) = props(j).Area;
end
idx = find(stats>50);
bw = ismember(bwl,idx);
nucproc(~bw) = 0;


%if max(max(nucproc)) > 0

[ofeat,onames] = features_overlap( prot, protproc, nucproc, 'nuc');
[mfeat,mnames] = features_overlap( prot, protprocm, nucproc, 'nuc');
%else
% ofeat = [];
% mfeat = [];
% 
% onames = [];
% mnames = [];
% end









