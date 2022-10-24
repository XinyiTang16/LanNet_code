clc;
clear;
addpath /mnt/data1/toolbox/NIFTI;

load('Longi_Lan_sublist.mat');
%% set directory
roifolder='/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step02_transform_infant_ROIs/final_1yr_50/';
roifile=dir([roifolder '*.nii']);

datafolder='/mnt/data1/yuxi/';

% need to change below!!
fisherz_destfolder='/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step03_lannet_FCs/ROIcorrelation_fisherz/'; % Save corr results for each subject

%% 
for subi=1:length(subject) 
	
    % read rs-fMRI data file for each longitudinal infant
    datafile = ['resample_preprocessed_' subject{subi,1} '.mat'];
	tempdata_reg = load([datafolder datafile]); 
    tempdata_reg = tempdata_reg.tempdata_reg2;
	nVt = size(tempdata_reg,4); % the number of volumes (time points)
	roisignal = zeros(12,nVt);
    
    % extract signals from each 50% probabilistic language parcels
    for roin=1:12
        tempatlas_ROI = load_untouch_nii([roifolder,roifile(roin).name]);
        tempatlas_ROI = double(tempatlas_ROI.img);
        tempcoord = findn(tempatlas_ROI); % get ROI coordinates
        tempno = size(tempcoord,1); % the number of voxels with this ROI
        temptimecourse = zeros(tempno,nVt);
        for k=1:tempno
            temptimecourse(k,:)=tempdata_reg(tempcoord(k,1),tempcoord(k,2),tempcoord(k,3),:); % combine each voxel's time course
        end
        roisignal(roin,:)=mean(temptimecourse,1); % calculate the mean of all voxels' time course within this ROI and combine each ROI's time course
        clear tempatlas_ROI tempcoord tempno tempti;
    end
    
    roisignal=roisignal';
    data_corr=corr(roisignal);
    data_corr_fisherz=0.5*(log((1+data_corr)./(1-data_corr)));
    save([fisherz_destfolder 'ROICorrelation_FisherZ_' subject{subi,1}],'data_corr_fisherz');
    
    subject{subi,1} %show done subjects
    
end
