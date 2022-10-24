clc;
clear;

%% add toolbox
addpath /mnt/data1/toolbox/NIFTI;

%% Extract peak voxels from each ROI in map: fedorenko original language parcels * lanA
%direct to 12 probabilistic language parcels
roifolder = '/mnt/data4/tangxinyi/P1_LangNet/7_baby_longitudinal/code_for_check/step01_create_adult_ROIs/adult_prob_parcels/';
roifile = dir([roifolder '*.nii']);

a=load_untouch_nii(['LanA_n806_2mm.nii']);

for roin=1:length(roifile)

    %load each probabilistic parcel
    temp_roi = load_untouch_nii([roifolder roifile(roin).name]);
    temp_roi = double(temp_roi.img);
    
    %get voxel numbers of each parcel
    tempcoord = findn(temp_roi>0); % get ROI coordinates
    tempno = size(tempcoord,1); % the number of voxels with this ROI
    
    voxelno = round(tempno*0.50); % determine cluster size according to certian porportion -- currently 50%
    
    %Sort probability values in the parcel from high to low
    values_sorted = sort(temp_roi(:),'descend');
    values_sorted_percent = values_sorted(1:voxelno,1);
    
    %get and save coordinates of new voxels (i.e., the 50% of voxels that
    %have the highest overlap values in LanA within each parcel)
    coordinates_sorted = zeros(1,3);
    for i=1:voxelno
        temp_coord = findn(temp_roi == values_sorted_percent(i,1));
        coordinates_sorted = [coordinates_sorted; temp_coord];
    end 
    coordinates_sorted = coordinates_sorted(2:end,1:3);
    
    %assign the top 50% voxels with new value -- in order to make new ROIs
    for i=1:size(coordinates_sorted,1)
        temp_roi(coordinates_sorted(i,1),coordinates_sorted(i,2),coordinates_sorted(i,3))=20;
    end
    
    %make and save new ROIs (i.e., 50% probabilistic language parcels)
    temp_roi(temp_roi~=20)=0;
    temp_roi(temp_roi==20)=1;
    propotion_map=make_nii(temp_roi);
    
    a.img = propotion_map.img;
    temp_end = size(roifile(roin).name,2);
    temp_filename=[roifile(roin).name(1:temp_end-4) '_50'];
    save_untouch_nii(a,temp_filename)

     clear temp* coordinates* values_sorted
end
    
    


