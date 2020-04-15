life = [ 6.2 16.1 16.3 19.0 12.2  8.1  8.8  5.9  7.3  8.2 ...
        16.1 12.8  9.8 11.3  5.1 10.8  6.7  1.2  8.3  2.3 ...
         4.3  2.9 14.8  4.6  3.1 13.6 14.5  5.2  5.7  6.5 ...
         5.3  6.4  3.5 11.4  9.3 12.4 18.3 15.9  4.0 10.4 ...
         8.7  3.0 12.1  3.9  6.5  3.4  8.5  0.9  9.9  7.9]';
binWidth = 2;
lastVal = ceil(max(life));
binEdges = 0:binWidth:lastVal+1;
h = histogram(life,binEdges);
xlabel('Time to Failure');
ylabel('Frequency');
ylim([0 10]);
counts = histcounts(life,binEdges);
binCtrs = binEdges(1:end-1) + binWidth/2;
h.FaceColor = [.9 .9 .9];
hold on
plot(binCtrs,counts,'o');
hold off
pd = fitdist(life,'Weibull');
h = histogram(life,binEdges,'Normalization','pdf','FaceColor',[.9 .9 .9]);
xlabel('Time to Failure');
ylabel('Probability Density');
ylim([0 1]);
xgrid = linspace(0,20,100)';
pdfEst = pdf(pd,xgrid);
line(xgrid,pdfEst)
