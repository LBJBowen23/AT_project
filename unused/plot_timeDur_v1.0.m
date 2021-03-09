% This code was used to plot the time stamp associated with 
% automatism,and then analysis if there was significant difference
% between these three groups.
% by Bowen Yang 2020/12/21
filename1 = 'time_output_v1.3.xlsx';
ndata = cell(2,4);
txt = cell(2,4);
alldata = cell(2,4);
sheet_temp = 0 ;
% load data from time_output file
for i = 1:2
    for j = 1:4
        sheet_temp = sheet_temp + 1;
        [ndata{i,j}, txt{i,j}, alldata{i,j}] = xlsread(filename1, sheet_temp);
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
sortC = 3;
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
xlb = {'Ant','neoT','Post','mTLE','Ant','neoT','Post','mTLE'};
figure;
for i = 1:8
    if i < 5
        curve_dim8{1,i} = curve_plot{1,i};
        id_plot{1,i} = num2cell(id{1,i});
    else
        curve_dim8{1,i} = curve_plot{2,(i-4)};
        % x_name{1,i} = num2cell(id{2,i-4});
        id_plot{1,i} = num2cell(id{2,i-4});
    end
    subplot(2,4,i);
    hold on ;
    barh(curve_dim8{1,i}  ,'stacked');
    yticks(1:size(id_plot{1,i},2));
    yticklabels(id_plot{1,i});
    ylabel('No.of patients');
    xticks(0:0.2:1);
    xlabel('normalized time');
    title(xlb{1,i});
    bh = barh(curve_dim8{1,i} ,'stacked');  %save the handle! 
    colors = [1,1,1; 0,0,0; 1,1,1];
    % colors = lines(length(bh));        %define colors
    for j = 1:3
        set(bh(j), 'FaceColor', colors(j,:)) ;
    end
end

% calc the normalized auto time delay between three groups and mTLE
p = cell(2,4,4);
h = cell(2,4,4);
curveT(:,:,1) = curve_dl;
curveT(:,:,2) = curve_dur;
curveT(:,:,3) = curve_dlN;
curveT(:,:,4) = curve_durN;
filename2 = 'ranksum_time1.3e.xlsx';
for k = 1:4
    for i = 1:2
        for j = 1:3
            % each p & h represent the stat preformed on the each of first 3 groups and mTLE
            [p{i,j,k}, h{i,j,k}] = ranksum(curveT{i,j,k}, curveT{i,4,k}); 
            
        end
    end
    xlswrite(filename2, cell2mat(p(:,:,k)),k,'A1:C2');
    xlswrite(filename2, cell2mat(h(:,:,k)),k,'A6:C7');
end