
% PLOT 3D 
% load data and construct matrix of patient * signs
filename = 'patients by semi_v1.2.xlsx' ;
sheet1 = 1;
range1 = 'C2:L75';
subsetA = xlsread(filename,sheet1,range1);
X = subsetA;
% Construct matrix of patients * areas
sheet2 = 2;
range2 = 'A1:C74';
subsetB = xlsread(filename,sheet2,range2);
% perform pca, only output the new coordinates and proportion of variance
[~,score2,~,~,explained2] = pca(X);

% Perfrom kmeans based on the first three dim of new coordinates
k = 4;
idx = kmeans(score2(:,1:3),k);
% idx = kmeans(score2,k);

% semi represent the idex of each semiologic cluster from kmeans
semi1 = find(idx == 1);
semi2 = find(idx == 2);
semi3 = find(idx == 3);
semi4 = find(idx == 4);


% Make the matrix of patients of cluster by scales 
% firstly, clus_by_semi is rearrangement of the patient * signs matrix
clus_by_semi = [subsetA(semi1,:); subsetA(semi2,:); subsetA(semi3,:); subsetA(semi4,:)];
% n_gp represent localization groups
n_gp1 = [1:21];
n_gp2 = [22:35];
n_gp3 = [36:51];
n_gp4 = [52:74];
% subsetC is the localization(mean) * semiology matrix
subsetC = [mean(subsetA(n_gp1,:)); mean(subsetA(n_gp2,:)); mean(subsetA(n_gp3,:)); mean(subsetA(n_gp4,:))];
% subsetD is the cluster(mean) * semiology matrix
subsetD = [ mean(subsetA(semi1,:)); mean(subsetA(semi2,:)); mean(subsetA(semi3,:)); mean(subsetA(semi4,:))];

% calc the lobe * cluster corr matrix
[LocClus,pLC] = corr(subsetC', subsetD', 'Type', 'Kendall');
% Log_LC represent whether p<0.05 in kendall correlation of Loc * Cluster matrix
Log_LC = pLC  < 0.05;

% Calculate the loc*semi matrix
figure;
imagesc(LocClus);
colorbar;
[posLoc, posClus] = find(pLC<0.05);
hold on 
plot(posLoc, posClus, 'm*', 'MarkerSize', 10);
% label the Loc
xlabel('Clus');
ylabel('Loc');

clus1 = X(semi1,:);
clus2 = X(semi2,:);
clus3 = X(semi3,:);
clus4 = X(semi4,:);

cluster1 = mean(clus1);
cluster2 = mean(clus2);
cluster3 = mean(clus3);
cluster4 = mean(clus4);
plot_id = [cluster1; cluster2; cluster3; cluster4] ;



figure;
for i = 1:k
    subplot(1,4,i);
    spider_plot(plot_id(i,:),'AxesLabels',{'过度运动','情绪','发声','局部肢体阵挛','自主神经症状','先兆','肌张力障碍','头眼偏转','post_conf','longD'});
end


% spider_plot(plot_id(i,:),axes_labels,{'S1','S2','S3','S4','S5','S6','S7','S8','S9'});
figure
spider_plot(plot_id(i,:), 'AxesScaling', 'log');

% a_limit represents the limitaion of each axes
num_gp = size(subsetA,2);
a_limit_low = repmat(0,1,num_gp);
max_limit = 2.2 ;
a_limit_high = repmat(max_limit,1,num_gp);
a_limit = [a_limit_low; a_limit_high];
spider_plot(plot_id(1,:),'AxesLimits',a_limit);

% Calc the spider plot of Cluster * Localization

n_semi=length(semi1);
n_gp=length(N_gp1);
sum_ovl=0;

ovl_ind = 
for i=1:n_semi
    for j = 1:n_clus
        
   sum_ovl= sum_ovl + length(find(n_gp1 == semi1(i)));
   ovl = length(find(n_gp1 == semi1(i)));
    end

    
for i = 1:size(clus1,1);
    


% name the labels


% heirarchical analysis
D = pdist(X');
% D = pdist(score2');
Z = squareform(D);
L = linkage(D,'ward');
dendrogram(L);
T = cluster(L,'maxclust',4);
cutoff = median([L(end-2,3) L(end-1,3)]);
dendrogram(L,'ColorThreshold',cutoff);