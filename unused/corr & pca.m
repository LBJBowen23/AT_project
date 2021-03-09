% PLOT signs * lobes
% load data and construct matrix of patient * signs
filename = 'patients by semi_v1.2.xlsx' ;
sheet1 = 1;
range1 = 'C2:L75';
subsetA = xlsread(filename,sheet1,range1);
X = subsetA;
% Construct matrix of patients * areas
sheet2 = 2;
range2 = 'E1:H74';
subsetB = xlsread(filename,sheet2,range2);


% plot the correlation matrix
[corr_matrixT,pval] = corr(X, subsetB, 'Type', 'Kendall');
pvalP = pval  < 0.05;
% corr_matrix = subsetA2 * subsetB;
figure;
imagesc(corr_matrixT);
colorbar;
[posC, posR] = find (pvalP == 1);
hold on 
plot(posR, posC, 'm*', 'MarkerSize', 10);



%normalize input argument, then using svd to perform pca;
%mu = mean(X);
%X_norm = bsxfun(@minus, X, mu);
%sigma0 = std(X_norm);
%X_norm = bsxfun(@rdivide, X_norm, sigma0);
%[coeff,score,latent,~,explained] = pca(X_norm);  score = X_norm * coeff

% PERFORM PCA
[coeff2,score2,latent2,~,explained2] = pca(X);
% svd instead of pca

x = score2(:,1);
y = score2(:,2);
z = score2(:,3);

% set the size and color of three groups 
sheet3 = 2;
Size = xlsread(filename,sheet3,'I1:I74');
C = xlsread(filename,sheet3,'A1:C74');
S_num = zeros(size(score2,1),1);

% enlarge the size of overlapped points
for i = 1:size(score2,1)
    S_num(i,:) = sum(mean(score2(:,1:3) == score2(i,1:3),2),1);
end
S = Size.* (2*S_num);

% plot the scatterplot of signs based on PCA coordinates
figure;
scatter3(x,y,z,S,C,'filled');
xlabel('1st pc'); 
ylabel('2nd pc');
zlabel('3rd pc');

% figure;
% scatter(x,y,S,C,'filled');
% xlabel('1st pc'); 
% ylabel('2nd pc');

% hold on; biplot(coeff2(:,1:3),'varlabels',{'v_1','v_2','v_3','v_4','v_5','v_6','v_7','v_8'});
