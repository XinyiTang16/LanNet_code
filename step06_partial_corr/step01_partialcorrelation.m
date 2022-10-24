clc;
clear;

%% load data

% load behaviors data
load('LanRead_Behaviors.mat');

%load FC file
load('Prop50_LanFC.mat');

% load control parameters
load('ControlVar.mat');

%% calculate partial correlation between FC and language/reading skills tests
%calculate partial correlation
for i = 1:size(lanread_behav,2)
    for j=1:size(prop50_FC,2)
        [r,p]=partialcorr(lanread_behav(:,i),prop50_FC(:,j),control_var,'Rows','pairwise');%Pearson partial correlation
        %[r,p]=partialcorr(lanread_behav(:,i),prop50_FC(:,j),control_var,'type','Spearman','Rows','pairwise');%Spearman partial correlation
        corr_result(i,j)=r;
        uncorrected_p_result(i,j)=p;
    end
end
%calculate the FDR-corrected p values for each behavior & FC correlation
for i=1:4
    temp_p=uncorrected_p_result(i,:);
    FDR(i,:)=mafdr(temp_p,'BHFDR',true);
end

