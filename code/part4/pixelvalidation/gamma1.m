clear all;clc;
load('NotPROTdistBio2.mat')
binWidth = 0.01;
lastVal = 0.6;
binEdges = 0:binWidth:lastVal;
% clear protdist
% protdist = CCDist_c;
h = histogram(protdist,binEdges);
xlabel('The Euclidean distance');
ylabel('µ°°×ÖÊ¸öÊý'); 
ylim([0 20]);
counts = histcounts(protdist,binEdges);
binCtrs = binEdges(1:end-1) + binWidth/2;
h.FaceColor = [.9 .9 .9];
hold on
plot(binCtrs,counts,'o');
hold off

pd = fitdist(protdist,'Gamma');
h = histogram(protdist,binEdges,'Normalization','pdf','FaceColor',[.9 .9 .9]);
xlabel('The Euclidean Distance');
ylabel('Probability Density');legend('normal VS cancer(not biomarker)');
ylim([0 10]);
xgrid = linspace(0,0.6,50)';
pdfEst = pdf(pd,xgrid);
line(xgrid,pdfEst)
