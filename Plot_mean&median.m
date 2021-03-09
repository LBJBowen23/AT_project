%% PLOT mean scores of each loc groups
bar_mean = subsetC2;

clr = [[0, 0.4470, 0.7410];[0.8500, 0.3250, 0.0980];[0.9290, 0.6940, 0.1250];...
    [0.4940, 0.1840, 0.5560];[0.4660, 0.6740, 0.1880];	[0.3010, 0.7450, 0.9330];
    [0.6350, 0.0780, 0.1840];[0.75, 0.75, 0];[0.25, 0.25, 0.25];...
    [1, 0, 0];[0, 0.75, 0.75]];

nclr=size(clr,1);   % make variable so can change easily
clr_lb={'hypermotor','emotion','vocalization',...
        'motor','version','aura','dystonia','autonomic',...
        'confusion','duration','delay'};

barTitle = {'median scores'};
figure;
b_handle = bar(bar_mean,'stacked');      % the bar object array for legend
for j=1:nclr
    b_handle(j).FaceColor=clr(j,:);
end
legend(b_handle,clr_lb,'location','northeast');
title(barTitle);
xlabel('Localization');
xlabel('Cumulated medians');
xticklabels({'Ant', 'neoT', 'Post', 'mTLE'});