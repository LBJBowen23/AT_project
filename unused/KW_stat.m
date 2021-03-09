gp1 = 'pref';
gp2 = 'nLE';
gp3 = 'post';
gp4 = 'mTLE';
gpNum = [21,14,16,23];
cumul = [];
for i = 1:4
    each_gp = repmat(strcat('gp',num2str(i)),gpNum(i),1);
    cumul = [cumul; each_gp];
end
idx_nominal = cellstr(cumul);

syp = size(subsetA,2);
p_kw = zeros(syp,1);
tbl_kw = cell(syp,1);
stat_kw = cell(syp,1);
sig_kw = cell(syp,1);
p_multcpr = cell(syp,1);
for i = 1:syp
    [p_kw(i,1),tbl_kw{i,1},stat_kw{i,1}] = kruskalwallis(subsetA(:,i),idx_nominal);
    sig_kw{i,1} = multcompare(stat_kw{i,1},'Alpha',0.05,'CType','bonferroni');
    [sig_fdr,q] = mafdr(p_kw);
end
