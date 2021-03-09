% this script was used to calculate the automatic duration scaled by whole
% seizure process, 
range = {'D2:G33' , 'D2:G13' , 'D2:G22' , 'D2:G67' ,...
    'D2:G53' , 'D2:G32' , 'D2:G22' , 'D2:G47' };
for st = 1:8
    %st represent sheet
    filename = 'semiology_time_v1.4e.xlsx';
    xlRange1 = range{1,st};
    [~,tp_input,~] = xlsread(filename,st,xlRange1);
    sz_num = size(tp_input,1);
    dur = zeros(sz_num,3);
    durN = zeros(sz_num,3);
    wholebar = zeros(sz_num,1);
    for i = 1:sz_num
        tp = [tp_input{i,1};tp_input(i,2);tp_input(i,3);tp_input{i,4}];
    % Calculate the whole duration of this seizure
        t1 = datenum(tp(1,:),'HH:MM:SS');
        t2 = datenum(tp(4,:),'HH:MM:SS');
        episode_whole = t2-t1;
        time  = datestr(episode_whole,'HH:MM:SS');
        min_whole = str2double(time(4:5));
        sec_whole = str2double(time(7:8));
        wholebar(i) = 60.* min_whole + sec_whole;
        % Calculate the duration of each section
        for iSec = 1:3
            t3 = datenum(tp(iSec,:),'HH:MM:SS');
            t4 = datenum(tp(iSec+1,:),'HH:MM:SS');
            episode = t4-t3;
            time  = datestr(episode,'HH:MM:SS');
            min = str2double(time(4:5));
            sec = str2double(time(7:8));
            dur(i,iSec) = 60.* min + sec;
            % scale the time duration into 1
            durN(i,iSec) = dur(i,iSec)./wholebar(i);
        end
    end
    % Calculate the mean of each patient
    xlRange2 = ['C2' ':C' num2str(sz_num + 1)];
    % this process aimed to omit input the range of id manually
    [id] = xlsread(filename,st,xlRange2);
    % initial avg_
    avg_dur = zeros(sz_num,3);
    avg_durN = zeros(sz_num,3);
    for i = 1 : size(id,1)
        same_id = find(id == id(i));
        % mean the three section as a whole
        avg_dur(i,:) = mean(dur(same_id,:),1);
        avg_durN(i,:) = mean(durN(same_id,:),1);
    end
    % delete the repitition data
    rm_raw = [];
    for i = 2 : size(id)
        if mean(avg_dur(i,:) == avg_dur(i-1,:)) == 1
            rm_raw = [ rm_raw ; i];
        end
    end 
    avg_dur(rm_raw,:) = [];
    avg_durN(rm_raw,:) = [];
    id(rm_raw,:) = [];
    % merge the id and results of averaged data
    output_gp = [id, avg_dur(:,1:2), avg_durN(:,1:2)];
    % Save the data in excel
    filename2 = 'time_output_v1.4e.xlsx';
    title = {'ID', 'dl_pt','dur_pt', 'dlN_pt', 'durN_pt'};
    % xlswrite(filename2, title, st, 'A1');
    % xlswrite(filename2, output_gp, st, 'A2');
    curve = [id, avg_durN];
    curve_asc = sortrows(curve,2);
end