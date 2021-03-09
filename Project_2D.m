function project_2D(coor3,n_gp)
% PROject 3D onto 2D with trd dim converted to color scale while mkr
% representing the localization groups
pca3 = coor3(:,3);
ind_rgb = 0:255;
xref = linspace(min(pca3),max(pca3),length(ind_rgb));
% find the correspongding relation between pca3 and rgb number
indexed_x = interp1(xref,ind_rgb,pca3,'nearest');
indexed_x = indexed_x + 1; % avoid 0 to be NaN
% then you can map to whatever colormap you want, e.g.
gradmap = parula(length(ind_rgb));
xcolors = gradmap(indexed_x,:);
s = 50*ones(74,1);
n_gp1 = n_gp{1,1}; 
n_gp2 = n_gp{1,2}; 
n_gp3 = n_gp{1,3}; 
n_gp4 = n_gp{1,4}; 
s1 = s(n_gp1,1); xcolor1 = xcolors(n_gp1,:);
s2 = s(n_gp2,1); xcolor2 = xcolors(n_gp2,:);
s3 = s(n_gp3,1); xcolor3 = xcolors(n_gp3,:);
s4 = s(n_gp4,1); xcolor4 = xcolors(n_gp4,:);
figure;
p1 = scatter(coor3(n_gp1,1),coor3(n_gp1,2),s1,xcolor1,'o','LineWidth',1); hold on;
p2 = scatter(coor3(n_gp2,1),coor3(n_gp2,2),s2,xcolor2,'+','LineWidth',1); hold on;
p3 = scatter(coor3(n_gp3,1),coor3(n_gp3,2),s3,xcolor3,'s','LineWidth',1); hold on;
p4 = scatter(coor3(n_gp4,1),coor3(n_gp4,2),s4,xcolor4,'filled','d','LineWidth',1);
xlabel('1st pc');
ylabel('2nd pc');
legend([p1 p2 p3 p4],{'1st cluster','2nd cluster','3rd cluster','4th cluster'});