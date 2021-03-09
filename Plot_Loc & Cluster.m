% PLOT Localization * semi Matrix
% Make the matrix of patients of cluster by scales 
% firstly, clus_by_semi is rearrangement of the patient * signs matrix
clus_by_semi = [X(semi1,:); X(semi2,:); X(semi3,:); X(semi4,:)];

% subsetC is the localization(mean) * semiology matrix
subsetC = [mean(X(n_gp1,:)); mean(X(n_gp2,:)); mean(X(n_gp3,:)); mean(X(n_gp4,:))];
% subsetD is the cluster(mean) * semiology matrix
subsetD = [mean(X(semi1,:)); mean(X(semi2,:)); mean(X(semi3,:)); mean(X(semi4,:))];

% subsetC is the localization(median) * semiology matrix
subsetC2 = [median(X(n_gp1,:)); median(X(n_gp2,:)); median(X(n_gp3,:)); median(X(n_gp4,:))];
% subsetD is the cluster(median) * semiology matrix
subsetD2 = [median(X(semi1,:)); median(X(semi2,:)); median(X(semi3,:)); median(X(semi4,:))];

% calc the lobe * cluster corr matrix
[LocClus,pLC] = corr(subsetC2', subsetD2', 'Type', 'Kendall');
% Log_LC represent whether p<0.05 in kendall correlation of Loc * Cluster matrix
pLCP = pLC  < 0.05;

% Calculate the loc*semi matrix
figure;
imagesc(LocClus);
colorbar;
[posLoc, posClus] = find(pLCP);
hold on 
plot(posClus,posLoc, 'm*', 'MarkerSize', 12);
% label the Loc
xlabel('Clustered Groups','fontsize',20);
ylabel('Localizations','fontsize',20);
set(gca,'XTick',[0.5:0.5:4])
set(gca,'XTickLabel',{[],'Cluster 1',[],'Cluster 2',[],'Cluster 3',[],'Cluster 4'},'fontsize',20);
set(gca,'YTick',[0.5:0.5:4])
set(gca,'YTickLabel',{[],'Ant',[],'NT',[],'Post',[],'MT'},'fontsize',20);


% PLOT signs * semiologic groups
figure;
imagesc(subsetD');
colorbar;
yticklabels({'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'});
xticklabels({[],'Clus1',[], 'Clus2',[], 'Clus3',[], 'Clus4'});
