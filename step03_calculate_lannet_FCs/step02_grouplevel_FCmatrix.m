clc;
clear;

%% Make group level mean FC map (r-value)

% direct to the datafile folder
rootfolder = '';
corrfile = dir([rootfolder 'ROICorrelation*.mat']);

for i = 1:length(subject)
    load([rootfolder corrfile(i).name]);  % load FC matrix of each subject
    corrcombined(:,:,i) = data_corr_fisherz; % combine each subject's FC matrix
end

% calculate group-level FC matrix
for i = 1:12
    for j = 1:12
        mean_lanFC(i,j) = tanh(mean(squeeze(corrcombined(i,j,:)))); % average all subjects' FC matrix (z-value) and transform the group mean z-value matrix to r-value
    end
end



