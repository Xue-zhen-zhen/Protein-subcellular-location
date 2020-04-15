function [S,T]=divide(data,rate)
    S = [];
    T = [];
    [m, n] = size(data);
    labels = data(:,n);
    labelsClass = unique(labels);
    weight = [];
    for i=1:length(labelsClass)
        weight(i) = round(sum(ismember(labels,labelsClass(i)))*rate);
    end
    for i=1:length(labelsClass)
        index = find(labels==labelsClass(i));
        randomIndex = index(randperm(length(index)));
        S = [S;data(randomIndex(1:weight(i)),:)];
        T = [T;data(randomIndex(weight(i)+1:sum(ismember(labels,labelsClass(i)))),:)];
    end
end