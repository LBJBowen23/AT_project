% PLOT 2d projection of each cluster
for i = 1:k
    plane = null(cent(i,:));
    prj = score(:,1:3) * plane;
    subplot(2,2,i);
    scatter(prj(:,1), prj(:,2),S,C,'filled');
    xlabel('1st orth'); 
    ylabel('2nd orth');
end
