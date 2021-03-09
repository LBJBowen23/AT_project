D = pdist(X');
% D = pdist(score2');
Z = squareform(D);
L = linkage(D,'ward');
dendrogram(L);
T = cluster(L,'maxclust',4);
cutoff = median([L(end-2,3) L(end-1,3)]);
dendrogram(L,'ColorThreshold',cutoff);