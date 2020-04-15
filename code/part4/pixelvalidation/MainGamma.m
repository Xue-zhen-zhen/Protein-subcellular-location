clear all;clc;
% load('NotPROTdistBio2.mat')
load('PROTdistBio2.mat')
binWidth = 0.01;
lastVal = 0.6;
binEdges = 0:binWidth:lastVal;
[counts1,centers] = hist(protdist,binEdges);
figure(1)
bar(centers, counts1 / sum(counts1))
pd = fitdist(protdist,'Gamma');
% h = histogram(protdist,binEdges,'Normalization','pdf','FaceColor',[.9 .9 .9]);
xlabel('The Euclidean Distance');
ylabel('Probability Density');title('Detected biomarkers (522 proteins)')
ylim([0 0.1]);
xgrid = linspace(0,0.6,50)';
pdfEst = pdf(pd,xgrid);
pdfEst = pdfEst/sum(pdfEst);
line(xgrid,pdfEst)

clear all;clc;
load('NotPROTdistBio2.mat')
binWidth = 0.01;
lastVal = 0.6;
binEdges = 0:binWidth:lastVal;
[counts1,centers] = hist(protdist,binEdges);
figure(2)
bar(centers, counts1 / sum(counts1))
pd = fitdist(protdist,'Gamma');
% h = histogram(protdist,binEdges,'Normalization','pdf','FaceColor',[.9 .9 .9]);
xlabel('The Euclidean Distance');
ylabel('Probability Density');title('Undetected biomarkers (273 proteins)')
ylim([0 0.1]);
xgrid = linspace(0,0.6,50)';
pdfEst = pdf(pd,xgrid);
pdfEst = pdfEst/sum(pdfEst);
line(xgrid,pdfEst)