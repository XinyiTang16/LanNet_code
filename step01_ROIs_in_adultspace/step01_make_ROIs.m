clc;
clear;

%% Extract peak voxels from each language probabilistic parcels: Original language parcels from Ev Fedorenko group * LanA atlas
% Original language parcels could be download from: https://evlab.mit.edu/funcloc/
% LanA atlas could be download from: http://evlabwebapps.mit.edu:8763/#/
% To create language probabilistic parcels (i.e., Original language parcels * LanA) 
% you could use the Image Caculate function in the MATLAB toolboxs REST (https://www.nitrc.org/projects/rest/) to multiply Orginal language parcels with LanA atlas
% Need to load the NIFTI toolbox

% Direct to the folder of twelve language probabilistic parcels
roifolder = '~\adult_prob_parcels\';
roifile = dir([roifolder '*.nii']);
a = load_untouch_nii(['LanA_n806_2mm.nii']);

% Set the region-level threshold: e.g., 25%
thres = 0.25;

for roin = 1:length(roifile)

    %load each probabilistic parcel
    temp_roi = load_untouch_nii([roifolder roifile(roin).name]);
    temp_roi = double(temp_roi.img);
    
    %get voxel numbers of each parcel
    tempcoord = findn(temp_roi > 0); % get ROI coordinates
    tempno = size(tempcoord,1); % the number of voxels with this ROI
    
    voxelno = round(tempno*thres); % determine cluster size according to region threshold
    
    %sort probability values in descending order
    values_sorted = sort(temp_roi(:),'descend');
    values_sorted_prop = values_sorted(1:voxelno,1);
    
    %get and save coordinates of target voxels (i.e., the 25% of voxels that have the highest values in LanA within each parcel)
    coordinates_sorted = zeros(1,3);
    for i = 1:voxelno
        temp_coord = findn(temp_roi == values_sorted_prop(i,1));
        coordinates_sorted = [coordinates_sorted; temp_coord];
    end 
    coordinates_sorted = coordinates_sorted(2:end,1:3);
    
    %assign the top 25% voxels with new value -- in order to make binary ROIs
    for i=1:size(coordinates_sorted,1)
        temp_roi(coordinates_sorted(i,1),coordinates_sorted(i,2),coordinates_sorted(i,3))=20;
    end
    
    %save ROIs
    temp_roi(temp_roi~=20)=0;
    temp_roi(temp_roi==20)=1;
    propotion_map=make_nii(temp_roi);
    
    a.img = propotion_map.img;
    temp_filename=[roifile(roin).name '_25'];
    save_untouch_nii(a,temp_filename)

     clear temp* coordinates* values_sorted
end
    
    


