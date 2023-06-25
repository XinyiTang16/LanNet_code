clc;
clear;

% Set directory
% direct to the datafile folder
rootfolder = '';
corrfile = dir([rootfolder 'ROICorrelation*.mat']); 

%% Compute FC of each module within infant language module

load('model_lan_3module.mat');

model_line = model(model~=0);

for i = 1:length(corrfile)
    
    % load correlation matrix
    load([rootfolder corrfile(i).name]);  
    neural_line = data_corr_fisherz(model~=0);
    
    for modeli = 1:max(model_line)
        connection_mean(i,modeli) = mean(neural_line(model_line == modeli));
    end
    
end
