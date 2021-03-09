% PLOT signs * lobes
% load data and construct matrix of patient * signs
filename = 'patients by semi_v1.2.xlsx';
sheet1 = 1;
range1 = 'C2:M75';
subsetA = xlsread(filename,sheet1,range1);
X = subsetA;
% Construct matrix of patients * areas
sheet2 = 2;
range2 = 'E1:H74';
subsetB = xlsread(filename,sheet2,range2);


% PLOT the correlation matrix
[corr_matrixT,pval] = corr(X, subsetB, 'Type', 'Kendall');
[fdrm,fdrn] = size(pval);
fdr = reshape(mafdr(pval(:)), fdrm, fdrn);
pvalP1 = fdr  < 0.05;
% corr_matrix = subsetA2 * subsetB;
figure;
imagesc(corr_matrixT);
yticklabels({'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'});
xticklabels({[],'Ant',[], 'neoT',[], 'Post',[], 'mTLE'});
colorbar;
[posC, posR] = find (pvalP1 == 1);
hold on 
plot(posR, posC, 'm*', 'MarkerSize', 10);

% PERFORM PCA
[~,score,~,~,explained] = pca(X);
% svd instead of pca

% n_gp represent localization groups
n_gp1 = [1:21];
n_gp2 = [22:35];
n_gp3 = [36:51];
n_gp4 = [52:74];

% K-means
% Perfrom kmeans based on the first three dim of new coordinates
iter = 1000;
k = 4;
for i = 1:iter
    [idx_plot,Cent,withinD, Dis] = kmeans(score,k);
    % calculate the minimum of within-cluster sums of point-to-centroid distances
    % semi represent the idex of each semiologic cluster from kmeans
    semi1 = find(idx_plot == 1);
    semi2 = find(idx_plot == 2);
    semi3 = find(idx_plot == 3);
    semi4 = find(idx_plot == 4);
    s1 = size(semi1,1); s2 = size(semi2,1); s3 = size(semi3,1); s4 = size(semi4,1);
    if min([s1,s2,s3,s4]) > 12 && max([s1,s2,s3,s4]) < 26
        break
    end
end

% set four colors
color_fig2 = zeros(4,3);
hex = {'#ff7675','#0984e3','#00b894','#fdcb6e'};
for i = 1:4
    color_fig2(i,:) = sscanf(hex{1,i}(2:end),'%2x%2x%2x',[1 3])/255;
end


%PLOT seizure patterns correlates to localization groups
gp_loc = {n_gp1,n_gp2,n_gp3,n_gp4};
gp_semi = {semi1,semi2,semi3,semi4};
overlap = zeros(4,4);
overlapN = zeros(4,4);
for i = 1:4
    for j = 1:4
        % row = gp_loc; colomn = gp_semi
        [val_lc,~]=intersect(gp_loc{1,i},gp_semi{1,j});
        overlap(i,j) = numel(val_lc);
    end
    overlapN(i,:) = overlap(i,:)./sum(overlap(i,:));
end

figure;
H = bar(overlapN.*100, 'stacked');
for i = 1:4
    H(i).FaceColor = 'flat';
    H(i).CData = color_fig2(i,:);
end
hold on ;
set(gca, 'YTick', 0:20:100, 'YTickLabel', 0:20:100,'xtick',1:4,...
'xticklabel',{'Ant', 'NT', 'Post', 'MT'});
xlabel('AT Subgroups','fontsize',16);
ylabel('%','fontsize',16);
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4', 'Location', 'northeast',...
    'fontsize',20);


% PLOT spider
clus1 = X(semi1,:);
clus2 = X(semi2,:);
clus3 = X(semi3,:);
clus4 = X(semi4,:);

cluster1 = mean(clus1);
cluster2 = mean(clus2);
cluster3 = mean(clus3);
cluster4 = mean(clus4);

plot_id = [cluster1; cluster2; cluster3; cluster4];
% load the color of 3 groups for spider 3 plot
sheet4 = 2;
C_spi4 = xlsread(filename,sheet4,'K1:M4');
spi_name = {'Cluster 1','Cluster 2','Cluster 3','Cluster 4'};

figure;
for i = 1:k
    subplot(2,2,i);
    spider_plot(plot_id(i,:),'AxesLabels',{'Hypermotor','Emotion', 'Vocalization',...
    'Simple Motor','Version','Autonomic Sign','Aura','Dystonia',...
    'Confusion','Duration','AT Delay'},'Color',color_fig2(i,:),'AxesLimits',...
    [zeros(1,11); 2*ones(1,11)],'LineWidth',3,'MarkerSize',4,'LabelFont','Calibri',...
    'AxesFont','Calibri','AxesFontSize',10,'LabelFontSize',18,...
    'AxesColor',[223 230 233]/255,'AxesDisplay','one','AxesLabelsEdge','none');
    leg_name = spi_name(1,i);
    % title(leg_name,'FontSize',18);
    %过度运动 情绪 发声	局部肢体阵挛	头眼偏转 自主神经症状	...
    %先兆	肌张力障碍	Post ictal confusion Long duration(>0.67) Delay(<0.33)
end

% count the Semi * loc for spider plot
spi_mat = overlap';
figure;
spider_plot(spi_mat,'AxesLabels',{'Ant','NT','Post','MT'},...
    'AxesLimits',[zeros(1,4);14*ones(1,4)],'Color',color_fig2,'LineWidth',3,...
    'MarkerSize',4,'LabelFont','Calibri','AxesFont','Calibri',...
    'AxesFontSize',10,'LabelFontSize',22,'AxesColor',[223 230 233]/255,...
    'AxesDisplay','one','AxesLabelsEdge','none');
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4', 'Location', 'northeast','fontsize',16);
% 'AxesLimits',[0,0,0,0,0;15,15,15,15,15],...,
% 'AxesPrecision',[1,1,1,1,1]);
% the spider_plot object array for legend.
