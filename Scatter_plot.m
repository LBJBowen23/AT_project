filename = 'patients by semi_v1.2.xlsx';
% Plot the 3D and 2D scatter plot
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
S = 4.* Size.* (2*S_num);
% no compelete same array of 1-3 col of score

% PLOT 3D on PCA coordinates according to anatomical origins
color_S1 = color_fig2;
C_S1a = [repmat(color_S1(1,:),size(n_gp1,2),1); repmat(color_S1(2,:),size(n_gp2,2),1);...
    repmat(color_S1(3,:),size(n_gp3,2),1); repmat(color_S1(4,:),size(n_gp4,2),1)];
figure;
scatter3(x(n_gp1),y(n_gp1),z(n_gp1),S(n_gp1),C_S1a(n_gp1,:),'o','filled'); hold on;
scatter3(x(n_gp2),y(n_gp2),z(n_gp2),S(n_gp2),C_S1a(n_gp2,:),'*'); hold on;
scatter3(x(n_gp3),y(n_gp3),z(n_gp3),S(n_gp3),C_S1a(n_gp3,:),'s','filled'); hold on;
scatter3(x(n_gp4),y(n_gp4),z(n_gp4),S(n_gp4),C_S1a(n_gp4,:),'d','filled'); 
xlabel('Dim 1'); 
ylabel('Dim 2');
zlabel('Dim 3');
legend('Ant','NTLE','Post','mTLE', 'Location', 'southeast');
title('color as function of anatomic group');


% PLOT 3D on PCA coordinates according to resulting clusters
color_S1b = color_fig2;
num_c1 = size(c_gp1,1);
num_c2 = size(c_gp2,1);
num_c3 = size(c_gp3,1);
num_c4 = size(c_gp4,1);
% C_c% means color of each group
C_c1 = repmat(color_S1b(1,:),num_c1,1);
C_c2 = repmat(color_S1b(2,:),num_c2,1);
C_c3 = repmat(color_S1b(3,:),num_c3,1);
C_c4 = repmat(color_S1b(4,:),num_c4,1);
c_gp1 = find(idx_plot == 1);
c_gp2 = find(idx_plot == 2);
c_gp3 = find(idx_plot == 3);
c_gp4 = find(idx_plot == 4);
figure;
scatter3(x(c_gp1),y(c_gp1),z(c_gp1),S(c_gp1),C_c1,'o','filled'); hold on;
scatter3(x(c_gp2),y(c_gp2),z(c_gp2),S(c_gp2),C_c2,'*'); hold on;
scatter3(x(c_gp3),y(c_gp3),z(c_gp3),S(c_gp3),C_c3,'s','filled'); hold on;
scatter3(x(c_gp4),y(c_gp4),z(c_gp4),S(c_gp4),C_c4,'d','filled'); 
xlabel('Dim 1(21.94%)'); 
ylabel('Dim 2(15.29%)');
zlabel('Dim 3(11.91%)');
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4', 'Location', 'northeast','fontsize',16);
set(gca,'fontname','calibri','fontSize',16);


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

% directly plot 1st & 2nd principal components
figure;
scatter(x(c_gp1),y(c_gp1),60,C_c1,'o','filled'); hold on;
scatter(x(c_gp2),y(c_gp2),60,C_c2,'*'); hold on;
scatter(x(c_gp3),y(c_gp3),60,C_c3,'s','filled'); hold on;
scatter(x(c_gp4),y(c_gp4),60,C_c4,'d','filled'); 
legend('Cluster 1','Cluster 2','Cluster 3','Cluster 4', 'Location', 'northeast','fontsize',16);
xlabel('Dim 1(21.94%)'); 
ylabel('Dim 2(15.29%)');
set(gca,'fontname','calibri','fontsize',16);