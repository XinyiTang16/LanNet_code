clc;
clear;
%% set directory
%compute each set of rois one by one 
%extract fisher-z value!
rootfolder='/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step03_lannet_FCs/ROIcorrelation_fisherz/';
corrfile=dir([rootfolder 'ROICorrelation*.mat']); % direct to the datafile folder

%% 1-compute FC within whole language network

%make model of whole language network
model=zeros(12,12);
for i=1:12
    for j=1:i-1
        model(j,i)=1;
    end
end

model_line=model(model~=0);

%extract FC values within whole language network
for i=1:length(corrfile)
    
    load([rootfolder corrfile(i).name]);  % load correlation matrix
    neural_line=data_corr_fisherz(model~=0);
    
    connection_mean(i,1)=mean(neural_line(model_line==1));
    
end


%% 2-compute FC within language subnetworks (3-subnetwork model)

load('model_lan_3subnetwork.mat');

model_line=model(model~=0);

for i=1:length(corrfile)
    
    load([rootfolder corrfile(i).name]);  % load correlation matrix
    neural_line=data_corr_fisherz(model~=0);
    
    for modeli=1:max(model_line)
        connection_mean(i,1+modeli)=mean(neural_line(model_line==modeli));
    end
    
end
