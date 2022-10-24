clc;
clear;

%% set root
addpath /mnt/data1/toolbox/NIFTI;

%% Check whether the voxel size within each new language parcels is half of the original language parcels (or other threshold)

% Get the voxel size of each parcels in Fedorenko original language map (in
% adult space)
roifolder = '/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step01_create_adult_ROIs/for_check_adult_Fedo_original_parcels/';
roifile = dir([roifolder '*.nii']);

for roin=1:length(roifile)
    tempatlas_ROI = load_untouch_nii([roifolder,roifile(roin).name]);
    tempatlas_ROI = double(tempatlas_ROI.img);
    tempcoord = findn(tempatlas_ROI); % get ROI coordinates
    tempno = size(tempcoord,1); % the number of voxels with this ROI
    voxelno_reslut(1,roin)=tempno;
end

% Get the voxel size of each parcels in 50% probabilistic language map (new
% ROIs we created) in adult space
roifolder = '/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step01_create_adult_ROIs/adult_prob_50/';
roifile = dir([roifolder '*.nii']);

for roin=1:length(roifile)
    tempatlas_ROI = load_untouch_nii([roifolder,roifile(roin).name]);
    tempatlas_ROI = double(tempatlas_ROI.img);
    tempcoord = findn(tempatlas_ROI); % get ROI coordinates
    tempno = size(tempcoord,1); % the number of voxels with this ROI
    voxelno_reslut(2,roin)=tempno;
end

