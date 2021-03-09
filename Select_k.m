% This function was used for selecting number of clusters
% elbow method
[idx_elbow]= kmeans_opt (subsetA(:,1:3),15);

% Silhouette method
figure
for i = 1:8
    subplot(2,4,i)
    % (perform pca would disturb the distribution of silhouette result)
    %[~,score_tmp] = pca(subsetA);
    cluster_tmp = kmeans(subsetA,i);
    silhouette(score_tmp,cluster_tmp);
end
title('Silhoutte method');

% gap stat
eva = evalclusters(score(:,1:4),'kmeans','gap','KList',[1:9]);
plot(eva)
title('gap statistics');
