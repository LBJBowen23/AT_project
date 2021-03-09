% PLOT signs * lobes
% load data and construct matrix of patient * signs
filename = 'patients by semi_v1.2.xlsx' ;
sheet1 = 1;
range1 = 'C2:M75';
subsetA = xlsread(filename,sheet1,range1);
X = subsetA;
% Construct matrix of patients * areas
sheet2 = 2;
range2 = 'E1:H74';
subsetB = xlsread(filename,sheet2,range2);

% n_gp represent localization groups
n_gp1 = [1:21];
n_gp2 = [22:35];
n_gp3 = [36:51];
n_gp4 = [52:74];

% PLOT the correlation matrix
[corr_matrixT,pval] = corr(X, subsetB, 'Type', 'Kendall');
[fdrm,fdrn] = size(pval);
fdr = reshape(mafdr(pval(:)), fdrm, fdrn);
pvalP2 = fdr  < 0.05;
% corr_matrix = subsetA2 * subsetB;
figure;
imagesc(corr_matrixT);
yticklabels({'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'});
xticklabels({[],'Ant',[], 'neoT',[], 'Post',[], 'mTLE'});
colorbar;
[posC, posR] = find (pvalP2 == 1);
hold on 
plot(posR, posC, 'm*', 'MarkerSize', 10);


% PERFORM PCA
[~,score,~,~,explained] = pca(X);


% K-means
% Perfrom kmeans based on the first three dim of new coordinates
iter = 300;
k = 5;
idx = cell(iter,1);
Cent = cell(iter,1);
withinD = cell(iter,1);
allD = cell(iter,1);
for i = 1:iter
    [idx{i,1},Cent{i,1},withinD{i,1}, allD{i,1}] = kmeans(score,k);
    % calculate the minimum of within-cluster sums of point-to-centroid distances
    
end

matD = reshape(cell2mat(withinD),iter,k);
[minD,min_idx] = min(sum(matD,2));

idx_plot = idx{min_idx,1};
Cent = Cent{min_idx,1};
Dis = allD{min_idx,1};

% semi represent the idex of each semiologic cluster from kmeans
semi1 = find(idx_plot == 1);
semi2 = find(idx_plot == 2);
semi3 = find(idx_plot == 3);
semi4 = find(idx_plot == 4);
semi5 = find(idx_plot == 5);



% svd instead of pca
x = score(:,1);
y = score(:,2);
z = score(:,3);

% set the size and color
sheet3 = 2;
Size = xlsread(filename,sheet3,'I1:I74');
C = xlsread(filename,sheet3,'A1:C74');


% enlarge the size of overlapped points
m_overlap = size(score,1);
S_num = zeros(size(score,1),1);
for i = 1:m_overlap
    same_m = mean(score(:,1:3) == score(i,1:3),2);
    S_num(i) = sum(same_m == 1);
end
S = Size.* (2*S_num);

% PLOT 3D on PCA coordinates
figure;
scatter3(x,y,z,S,C,'filled');
xlabel('1st pc'); 
ylabel('2nd pc');
zlabel('3rd pc');

% shpere 5 clusters
figure;
scatter3(x,y,z,S,C,'filled');
xlabel('1st pc'); 
ylabel('2nd pc');
zlabel('3rd pc');

% PLOT the sphere to represent each cluster
for i = 1:k
% Circle the cluster
    [Max, id] = max(Dis(semi1,1));
    id = semi1(id);
    dis = sqrt((score(id,1)-Cent(i,1))^2 + (score(id,2)-Cent(i,2))^ 2 ...
        + (score(id,3)-Cent(i,3))^2);

    r = dis/2;
    [s1,s2,s3] = sphere(30);
    x0 = Cent(i,1); y0 = Cent(i,2); z0 = Cent(i,3);
    s1 = s1*r + x0;
    s2 = s2*r + y0;
    s3 = s3*r + z0;
    % Then you can use a surface command as Patrick suggests:
    hold on ;
    lightGrey = 0.9*[1 1 1]; % It looks better if the lines are lighter
    surf(s1,s2,s3,'FaceColor', 'none','EdgeColor',lightGrey)
end

% PROject 3D onto 2D with trd dim converted to color scale while mkr
% representing the localization groups
n_gp = {n_gp1, n_gp2, n_gp3, n_gp4};
color_3rd(score(:,1:3),n_gp);

% PLOT Localization * semi Matrix
% Make the matrix of patients of cluster by scales 
% firstly, clus_by_semi is rearrangement of the patient * signs matrix
clus_by_semi = [X(semi1,:); X(semi2,:); X(semi3,:); X(semi4,:); X(semi5,:)];

% subsetC is the localization(mean) * semiology matrix
subsetC = [mean(X(n_gp1,:)); mean(X(n_gp2,:)); mean(X(n_gp3,:)); mean(X(n_gp4,:))];
subsetC_median = [median(X(n_gp1,:)); median(X(n_gp2,:));...
    median(X(n_gp3,:)); median(X(n_gp4,:))];
% subsetD is the cluster(mean) * semiology matrix
subsetD = [ mean(X(semi1,:)); mean(X(semi2,:)); mean(X(semi3,:)); mean(X(semi4,:));...
    mean(X(semi5,:))];

% calc the lobe * cluster corr matrix
[LocClus,pLC] = corr(subsetC', subsetD', 'Type', 'Kendall');
% Log_LC represent whether p<0.01 in kendall correlation of Loc * Cluster matrix
pLCP = pLC  < 0.05;

% Calculate the loc*semi matrix
figure;
imagesc(LocClus);
colorbar;
[posLoc, posClus] = find(pLCP);
hold on 
plot(posClus,posLoc, 'm*', 'MarkerSize', 10);
% label the Loc
xlabel('Cluster');
ylabel('Localization');
set(gca,'YTickLabel',{[],'Ant',[],'neoT',[],'Post',[],'mTLE'});
set(gca,'XTick',[0.5:0.5:5]);
set(gca,'XTickLabel',{[],'cluster1',[],'cluster2',[],'cluster3',[],'cluster4',...
    [],'cluster5'});


% PLOT mean scores of each loc groups
bar_mean = subsetC;
bar_median = subsetC_median;

clr = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];...
    [0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];	[0.3010, 0.7450, 0.9330];
    [0.6350, 0.0780, 0.1840];[0.75, 0.75, 0];[0.25, 0.25, 0.25];...
    [1, 0, 0];[0, 0.75, 0.75]];

nclr=size(clr,1);   % make variable so can change easily
clr_lb={'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'};

barTitle = {'mean scores'};
figure;
b_handle = bar(bar_median,'stacked');      % the bar object array for legend
for j=1:nclr
    b_handle(j).FaceColor=clr(j,:);
end
legend(b_handle,clr_lb,'location','northeast');
title(barTitle);
xlabel('Localization');
xlabel('Cumulated medians');
xticklabels({'Ant', 'neoT', 'Post', 'mTLE'});

% PLOT spider
cluster1 = mean(X(semi1,:));
cluster2 = mean(X(semi2,:));
cluster3 = mean(X(semi3,:));
cluster4 = mean(X(semi4,:));
cluster5 = mean(X(semi5,:));


plot_id = [cluster1; cluster2; cluster3; cluster4; cluster5];
% load the color of 3 groups for spider 3 plot
sheet4 = 2;
C_spi5 = xlsread(filename,sheet4,'K1:M5');

spi_name = {'1st cluster','2st cluster','3st cluster','4st cluster',...
    '5th cluster'};
figure;
for i = 1:k
    subplot(1,5,i);
    spider_plot(plot_id(i,:),'AxesLabels',{'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'},'Color',C_spi5(i,:),'AxesLimits',...
        [zeros(1,11); 2*ones(1,11)],'AxesFontSize',1);
    leg_name = spi_name(1,i);
    title(leg_name);
end

% count the Semi * loc for spider plot
% initial the 5 groups of loc
s_gp1 = [1:20];
s_gp2 = [22:35]';
s_gp3 = [36:51]';
s_gp4 = [52:74]';


spi_mat = zeros(k,4);
name_m = {semi1, semi2, semi3, semi4, semi5};
name_n = {s_gp1, s_gp2, s_gp3, s_gp4};
for i = 1:k
    for j = 1:4
        spi_mat(i,j) = numel( intersect(cell2mat(name_m(i)), cell2mat(name_n(j))));
    end
end
figure
spider_plot(spi_mat,'AxesLabels',{'Ant','neoT','Post','mTLE'...
    },'AxesLimits',[0,0,0,0;12,12,12,12]);
% 'AxesLimits',[0,0,0,0,0;15,15,15,15,15],...,
% 'AxesPrecision',[1,1,1,1,1]);
% the spider_plot object array for legend.
legend('cluster1','cluster2','cluster3','cluster4','cluster5', 'Location', 'southoutside');