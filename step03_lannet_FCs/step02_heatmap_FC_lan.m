clc;
clear;
%% make group level mean FC map (r-value)

rootfolder='/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step03_lannet_FCs/ROIcorrelation_fisherz/';

corrfile=dir([rootfolder 'ROICorrelation*.mat']); % direct to the datafile folder

% longitudinal sample (language test)
for i=1:64
    load([rootfolder corrfile(i).name]);  % load correlation matrix
    corrcombined(:,:,i)=data_corr_fisherz; % combine each subject's language network matrix
end

% calculate and draw heatmap
for i=1:12
    for j=1:12
        mean_lanFC(i,j)=tanh(mean(squeeze(corrcombined(i,j,:)))); % average all subjects' language matrix (z-value) and transform the group mean matrix to r-value
    end
end

heatmap(mean_lanFC);
save Groupmean_LanNet_rvalue_n64.mat mean_lanFC


