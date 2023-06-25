clc;
clear;

%Need to load toolbox: NIFTI

%Set directory
%Directory of ROI folder
roifolder = '~\step02_transform_infant_ROIs\final_1yr_25\';
roifile = dir([roifolder '*.nii']);

%Directory of data folder
datafolder = '';
%Directory of FC result folder
fisherz_destfolder = ''; % Save FC results for each subject

%% Caulate Language network FC matrix for each subject

for subi = 1:length(subject) 
	
    % read rs-fMRI image of each infant
    datafile = [subject{subi,1} '.mat'];
	tempdata_reg = load([datafolder datafile]); 
    tempdata_reg = tempdata_reg.tempdata_reg2;
	nVt = size(tempdata_reg,4); % get the number of volumes (time points)
	roisignal = zeros(12,nVt);
    
    % extract time courses from each ROI
    for roin = 1:12
        tempatlas_ROI = load_untouch_nii([roifolder,roifile(roin).name]);
        tempatlas_ROI = double(tempatlas_ROI.img);
        tempcoord = findn(tempatlas_ROI); % get ROI coordinates
        tempno = size(tempcoord,1); % the number of voxels with this ROI
        temptimecourse = zeros(tempno,nVt);
        for k = 1:tempno
            temptimecourse(k,:) = tempdata_reg(tempcoord(k,1),tempcoord(k,2),tempcoord(k,3),:); % combine each voxel's time course
        end
        roisignal(roin,:) = mean(temptimecourse,1); % calculate the mean of all voxels' time course within this ROI and combine each ROI's time course
        clear tempatlas_ROI tempcoord tempno tempti;
    end
    
    %calculate FC matrix of each infant
    roisignal = roisignal';
    data_corr = corr(roisignal);
    data_corr_fisherz = 0.5*(log((1+data_corr)./(1-data_corr))); %transform the r-value into Fisher-z value
    save([fisherz_destfolder 'ROICorrelation_FisherZ_' subject{subi,1}],'data_corr_fisherz');
    
end
