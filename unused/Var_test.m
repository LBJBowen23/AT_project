% This code was used to test whether the variance of groups were equal
% results reject the null hypothesis, so we can't use K-W test
% by Bowen Yang 2021-01-13
filename1 = 'time_output_v1.4.xlsx';
ndata = cell(2,4);
txt = cell(2,4);
alldata = cell(2,4);
sheet_tmp = 0;
% load data from time_output file
for i = 1:2
    for tmp1 = 1:4
        sheet_tmp = sheet_tmp + 1;
        [ndata{i,tmp1}, txt{i,tmp1}, alldata{i,tmp1}] = xlsread(filename1, sheet_tmp);
    end
end
% extract the time data which would be used for further stat analysis 

groups.data = ndata;
% initial the matrix of sample * observation 
id = cell(2,4);
curve_dlN = cell(2,4);
curve_durN = cell(2,4);
curve_sort = cell(2,4);
curve_trd = cell(2,4);
curve_plot = cell(2,4);
% sortC represent the colomn we used to sort ndata 
sortC = 4;
for i = 1:2
    for tmp1 = 1:4
        curve_sort{i,tmp1} = sortrows(groups.data{i,tmp1},sortC);
        id{i,tmp1} = (curve_sort{i,tmp1}(:,1))';
        curve_dlN{i,tmp1} = curve_sort{i,tmp1}(:,4);
        curve_durN{i,tmp1} = curve_sort{i,tmp1}(:,5);
        curve_trd{i,tmp1} = ones(size(groups.data{i,tmp1},1),1);
        curve_trd{i,tmp1} = curve_trd{i,tmp1} - (curve_dlN{i,tmp1} + curve_durN{i,tmp1});
        curve_plot{i,tmp1} = [curve_dlN{i,tmp1}, curve_durN{i,tmp1}, curve_trd{i,tmp1}];
    end
end
p = cell(2,4,2);
h = cell(2,4,2);
curveT(:,:,1) = curve_dlN;
curveT(:,:,2) = curve_durN;
filename2 = 'ranksum_time1.3e.xlsx';
Name = cell(4,1);
for gp_tmp = 1:4
    ptnum_tmp = size(curveT{2,gp_tmp,1});
    name_tmp = gp_tmp * ones(ptnum_tmp);
    trs_tmp = ones(ptnum_tmp);
    Name{gp_tmp,1} = mat2cell(num2str(name_tmp),trs_tmp);
end
kw = cell(2,1);
kw{2,1} = [curve_durN{2,1};curve_durN{2,2};curve_durN{2,3};curve_durN{2,4}];
Name_4 = [Name{1,1};Name{2,1};Name{3,1};Name{4,1}];
ptest = vartestn(kw{2,1},Name_4,'TestType','LeveneAbsolute');

kw{1,1} = [curve_dlN{1,1};curve_dlN{1,2};curve_dlN{1,3};curve_dlN{1,4}];
Name_4 = [Name{1,1};Name{2,1};Name{3,1};Name{4,1}];

[p, tbl, stats] = kruskalwallis(kw{2,1},Name_4,'off');
c = multcompare(stats);

   

