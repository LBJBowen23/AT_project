% This code was used to plot the time stamp associated with 
% automatism,and then analysis if there was significant difference
% between these four groups.
% by Bowen Yang 2021/01/12
filename1 = 'time_output_v1.4e.xlsx';
ndata = cell(2,4);
txt = cell(2,4);
alldata = cell(2,4);
sheet_tmp = 0;
% load data from time_output file
for i = 1:2
    for j = 1:4
        sheet_tmp = sheet_tmp + 1;
        [ndata{i,j}, txt{i,j}, alldata{i,j}] = xlsread(filename1, sheet_tmp);
    end
end
% extract the time data which would be used for further stat analysis 
groups.data = ndata;
% initial the matrix of sample * observation 
id = cell(2,4);
curve_dl = cell(2,4);
curve_dur = cell(2,4);
curve_dlN = cell(2,4);
curve_durN = cell(2,4);
curve_sort = cell(2,4);
curve_trd = cell(2,4);
curve_plot = cell(2,4);
% sortC represent the colomn we used to sort ndata 
sortC = 4;
for i = 1:2
    for j = 1:4
        curve_sort{i,j} = sortrows(groups.data{i,j},sortC);
        id{i,j} = (curve_sort{i,j}(:,1))';
        curve_dl{i,j} = curve_sort{i,j}(:,2);
        curve_dur{i,j} = curve_sort{i,j}(:,3);
        curve_dlN{i,j} = curve_sort{i,j}(:,4);
        curve_durN{i,j} = curve_sort{i,j}(:,5);
        curve_trd{i,j} = ones(size(groups.data{i,j},1),1);
        curve_trd{i,j} = curve_trd{i,j} - (curve_dlN{i,j} + curve_durN{i,j});
        curve_plot{i,j} = [curve_dlN{i,j}, curve_durN{i,j}, curve_trd{i,j}];
    end
end

% PLOT the 2 * 4 figures of semiologic process
id_plot = cell(1,8);
curve_dim8 = cell(1,8);
xlb = {'Ant','NT','Post','MT','Ant','NT','Post','MT'};
colors = [1,0.98,0.98; [9, 132, 227]/255; 1,0.98,0.98];
figure;
for i = 1:8
    if i < 5
        curve_dim8{1,i} = curve_plot{1,i};
        id_plot{1,i} = num2cell(id{1,i});
    else
        curve_dim8{1,i} = curve_plot{2,(i-4)};
        id_plot{1,i} = id{2,i-4};
    end
    subplot(2,4,i);
    hold on;
    bh = barh(curve_dim8{1,i},'stacked');
    set(gca,'xtick',(0:0.2:1),'ytick',(1:size(id_plot{1,i},2)),...
        'yticklabel',(id_plot{1,i}),'fontsize',10);
    if i ==1 || i ==5
        ylabel('ID of Patients');
    end
    if i < 5
        title(xlb{1,i},'fontsize',18);
    end
    % barh(curve_dim8{1,i} ,'stacked');  %save the handle! 
    % colors = [1,1,1; 0,0,0; 1,1,1];
    % colors = lines(length(bh));        %define colors
    for j = 1:3
        set(bh(j), 'FaceColor', colors(j,:));
    end
end


% Kruskal-Wallis test, results are 2*2 * 6
curveT(:,:,1) = curve_dl;
curveT(:,:,2) = curve_dur;
curveT(:,:,3) = curve_dlN;
curveT(:,:,4) = curve_durN;
p_kw = zeros(2,2);
tbl_kw = cell(2,2);
c_kw = cell(2,2);
c_kw2 = cell(2,2);
Name = cell(2,4,2);
Name_4 = cell(2,2);
cpr = [1,4; 2,4; 3,4; 1,2; 2,3; 1,3];
% stamp = 1 means dlN, stamp  = 2 means durN
% i = 1 means oral AT, i = 2 means gestural AT
% gp_tmp: pref nTLE post mTLE
for ftr = 1:2 % ftr==1 : dlN, ftr==2 : durN
    stamp = ftr + 2;
    for i = 1:2 
        for gp_tmp = 1:4
            ptnum_tmp = size(curveT{i,gp_tmp,stamp});
            name_tmp = gp_tmp * ones(ptnum_tmp);
            trs_tmp = ones(ptnum_tmp);
            Name{i, gp_tmp, stamp} = mat2cell(num2str(name_tmp),trs_tmp);
        end
    kw = cell(2,2);
    kw{i,ftr} = [curveT{i,1,stamp};curveT{i,2,stamp};...
        curveT{i,3,stamp};curveT{i,4,stamp}]';
    Name_4{i,ftr} = [Name{i,1,stamp};Name{i,2,stamp};Name{i,3,stamp};...
        Name{i,4,stamp}]';
    % ptest = vartestn(kw{2,1},Name_4,'TestType','LeveneAbsolute');
    [p_kw(i,ftr), tbl_kw{i,ftr}, stat_kw(i,ftr)] = ...
        kruskalwallis(kw{i,ftr},Name_4{i,ftr},'off');
    c_kw{i,ftr} = multcompare(stat_kw(i,ftr));
    c_kw2{i,ftr} = multcompare(stat_kw(i,ftr),'ctype','bonferroni');
    end
end

% Figure 4b !!!

% calculate the median of 4 anatomic group, 2*2 in figure 4b (oral/manual * dl/dur)
% x axis represents the 4 groups, y axis represents the median of each group
% Firstly, extract the data from variable "curveT"
med = zeros(2,4,2);
% extract data from curveT
for ftr = 1:2   % ftr = delay/duration
    stamp = ftr + 2;
    for i = 1:2     % i = oral/manual
        for j = 1:4   % j = four groups
        med(i,j,ftr) = median(curveT{i,j,stamp});
        end
    end
end
% figure 4b
gp_ftr = cell(2,1);
color_4b = [[9, 132, 227]./255 ; [214 48 49]./255];
y_name = {'Scaled Timestamp of Oral AT','Scaled Timestamp of Manual AT'};
figure;
for i = 1:2
    gp_ftr{i,1} = squeeze(med(i,:,:));
    subplot(2,1,i);
    H4b = bar(gp_ftr{i,1});
    for j = 1:2
    H4b(j).FaceColor = color_4b(j,:);
    end
    set(gca,'xtick',1:4,'xticklabel',{'Ant', 'NT', 'Post', 'MT'},'fontsize',16);
    ylabel(y_name{1,i},'fontsize',16);
    legend('AT Delay','AT Duration', 'Location', 'northeast','fontsize',10);
end


% Analysing through ranksum between 6 pairs   
p_rank = cell(2,3,2);
h_rank = cell(2,3,2);
filename2 = 'ranksum_time1.4e.xlsx';
cpr = [1,4; 2,4; 3,4; 1,2; 2,3; 1,3];
% ftr 1 means dlN (stamp3), ftr 2 means durN (stamp4)
for ftr = 1:2
    % i means oral or manual
    for i = 1:2
        % j means combination of comparison
        for j = 1:6
            ord1 = cpr(j,1); ord2 = cpr(j,2);
            % each p & h represent the stat preformed on each combination
            % defined by cpr
            % stamp3 in curveT: dlN, stamp4 in curveT: durN;
            stamp = ftr + 2;
            [p_rank{i,j,ftr}, h_rank{i,j,ftr}] = ranksum(curveT{i,ord1,stamp},...
                curveT{i,ord2,stamp});
        end
    end
    % write ranksum results into 2 tablesL dlN & durN
    % xlswrite(filename2, cell2mat(p_rank(:,:,ftr)),ftr,'A3:F4');
    % xlswrite(filename2, cpr',ftr,'A1:F2');
end
