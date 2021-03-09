% This script was used to calculate the percentage of automatic seizrues in
% all seizrues of each participant
range = {'A2:C22' , 'A2:C15' , 'A2:C17' , 'A2:C24'};
title_sub = {'Ant' , 'NT' , 'Post' , 'MT'};
prct_stat = cell(1,4);
curve_sort = cell(1,4);
sortC = 1;
prct = cell(1,4);
% plot four subchart, representing percentage of automatic seizures in the
% four semiological patterns respectively
figure;
for st = 1:4
%st represent sheet
    subplot(2,2,st);
    filename = 'percent_auto1.0.xlsx';
    xlRange1 = range{1,st};
    [freq_tmp,~,~] = xlsread(filename,st,xlRange1);
    id_tmp = freq_tmp(:,1);
    m = size(freq_tmp,1);
    % calculate the percentage of automatic seizures in all seizures 
    % 1st colomn: ratio of auto/all, 2nd col: ratio of non-auto/all
    % 3rd col: id of each patient
    prct_stat{1,st} = freq_tmp(:,2) ./ freq_tmp(:,3);
    prct_stat{1,st}(:,2) = ones(m,1) - prct_stat{1,st}(:,1);
    prct_stat{1,st}(:,3) = id_tmp;
    curve_sort{1,st} = sortrows(prct_stat{1,st},sortC);
    % prct means percent£» prct=original order from 1-74, prct_reord=
    % reordered by normalized frequency
    prct{1,st} = zeros(m,2);
    % number of automatic seizures
    prct{1,st}(:,1) = freq_tmp(:,2);
    % number of non-automatic seizures
    prct{1,st}(:,2) = freq_tmp(:,3) - freq_tmp(:,2);
    % ratio of automatic seizures divided by all seizures
    prct{1,st}(:,3) = freq_tmp(:,2)./freq_tmp(:,3);
    prct{1,st}(:,4) = id_tmp;
    % create a colomn used to sort prct_reord
    % reord : reorder of prct data without normalization
%     prct_reord{1,st} = sortrows(prct{1,st},3);
%     colors = [1, 0.3882, 0.2784 ; 0.7451, 0.7451, 0.7451];
%     bh = bar(prct_reord{1,st}(:,1:2),0.2,'stacked'); %,'FaceColor',colors
%     xticks(1:m);
%     xticklabels(prct_reord{1,st}(:,4));
%     xlabel('Patients ID');
%     title(title_sub{1,st});
%     for c_bar = 1:2
%                 set(bh(c_bar), 'FaceColor', colors(c_bar,:),...
%                     'EdgeColor',[1,1,1]);
%     end
%     hold on;
%     x_slope = 1:size(prct_reord{1,st},1);
%     y_slope = prct_reord{1,st}(:,1);
%     plot(x_slope, y_slope,'b','LineWidth',1,'Marker','s',...
%         'MarkerFaceColor','b');
end

color_fig4 =  [[9,132,227]/255 ; 1,0.98,0.98] ;
% this figure below was the re-sorted versiono of last figure
figure;
for i = 1:4
    subplot(2,2,i)
    filename = 'percent_auto1.0.xlsx';
    xlRange1 = range{1,st};
    [freq_tmp,~,~] = xlsread(filename,st,xlRange1);
    m = size(freq_tmp,1);
    bh = bar((curve_sort{1,i}(:,1:2)).*100,0.5,'stacked'); %,'FaceColor',colors
    set(gca,'xtick',(1:m),'xticklabel',(curve_sort{1,i}(:,3)),...
        'ytick',0:20:100,'yticklabel',0:20:100)
    %xticks(1:m));
    %xticklabels(curve_sort{1,i}(:,3));
    title(title_sub{1,i},'fontsize',20);
    if i == 1 || i == 3
        ylabel('%');
    end
    for c_bar = 1:2
                set(bh(c_bar), 'FaceColor', color_fig4(c_bar,:),...
                    'EdgeColor',[1,1,1]);
    end
    hold on;
    x_slope = 1:size(curve_sort{1,i},1);
    y_slope = curve_sort{1,i}(:,1);
    plot(x_slope, y_slope.*100,'b','LineWidth',1.5,'Marker','s',...
        'MarkerFaceColor','b','Markersize',4);
end

%PLOT Histogram
figure
color_line = lines(4);
for i = 1:4
    x_slope = 1:size(curve_sort{1,i},1);
    y_slope = curve_sort{1,i}(:,1);
    plot(x_slope, y_slope,'LineWidth',1,'Marker','s','MarkerFaceColor',color_line(i,:),...
        'MarkerEdgeColor',color_line(i,:));
    hold on;
end
% Calculate the number of auto and non-auto seizures for each group
gp_at_mat = zeros(4,2);
for i = 1:4
    for j = 1:2
        gp_at_mat(i,j) = sum(prct{1,i}(:,j));
    end
end

% using crosstab to analyze the difference of freq between groups
tbl_chi = cell(1,6);
p_chi = zeros(1,6);
% initial the comparison combination
cpr = [1,4; 2,4; 3,4; 1,2; 2,3; 1,3];
for i = 1:6
    ord1 = cpr(i,1); ord2 = cpr(i,2);
    % at1 & at2 : the number of total AT seizures in 2 compared groups
    at1 = gp_at_mat(ord1,1);
    at2 = gp_at_mat(ord2,1);
    % n1&n2 : total number of seizures in groups 1 and group 2
    n1 = gp_at_mat(ord1,1) + gp_at_mat(ord1,2); 
    n2 = gp_at_mat(ord2,1) + gp_at_mat(ord2,2); 
    % marked char of each group
    mark_tmp = [repmat(['gp',num2str(ord1)],n1,1);...
        repmat(['gp',num2str(ord2)],n2,1)];
    % marked ID of number format for each group
    % mark_tmp & syp_tmp were inputs for crosstab
    syp_tmp = [ones(at1,1); 2*ones(n1-at1,1); ones(at2,1); 2*ones(n2-at2,1)];
    [tbl_chi{1,i},~,p_chi(1,i)] = crosstab(mark_tmp,syp_tmp);
end
% write p of chi and its corresponidng compared groups 
output_chi = 6;
p_chiC = p_chi < [0.05/6];
% xlswrite(filename, cpr, output_chi,'A1:B6');
% xlswrite(filename, p_chi',output_chi,'C1:C6');

% Figure 5b !!!
color_5b = [[9, 132, 227]./255 ; [178 190 195]./255];
filename2 = 'percent_auto1.0.xlsx';
range2 = {'A2:C22' , 'A2:C15' , 'A2:C17' , 'A2:C24'};
freq_data = cell(1,4);
freq_plot = zeros(2,4);
for i = 1:4
    xlRange2 = range2{1,i};
    [freq_data{1,i},~,~] = xlsread(filename2,i,xlRange2);
    freq_at = freq_data{1,i}(:,2);
    freq_T = freq_data{1,i}(:,3);
    freq_n = freq_T - freq_at;
    freq_plot(1,i) = sum(freq_at);
    freq_plot(2,i) = sum(freq_n);
end
figure;
H5b = bar(freq_plot','stacked');
for i = 1:2
    H5b(i).FaceColor = color_5b(i,:);
end
set(gca,'xtick',1:4,'xticklabel',{'Ant', 'NT', 'Post', 'MT'},'fontsize',16);
ylabel('Number of Seizures','fontsize',16);
legend('Seizures with AT','Seizures without AT','Location','northeast');

% not used ranksum analysis
p_rank = zeros(1,6); 
h_rank = zeros(1,6);
for i = 1:6
    rank1 = cpr(i,1);
    rank2 = cpr(i,2);
    [p_rank(1,i), h_rank(1,i)] = ranksum(prct_stat{1,rank1}(:,1), ...
    prct_stat{1,rank2}(:,1));
end