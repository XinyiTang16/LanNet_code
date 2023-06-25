#! /bin/bash

#The infant 1-yr-old template used could be download from: https://www.nitrc.org/projects/pediatricatlas
#The adult MNI152 template used could be download from: https://www.bic.mni.mcgill.ca/ServicesAtlases/ICBM152NLin2009

#Codes used to generate the registration matrix (from adult MNI152 template to infant 1-yr-old template)
antsRegistrationSyNQuick.sh -d 3 -f infant-1yr-withCerebellum.nii.gz -m mni_icbm152_t1_tal_nlin_asym_09a.nii -o ICBM15221yr

#Twelve ROIs
images=('ROI01_L_IFGorb'
'ROI02_L_IFG'
'ROI03_R_IFGorb'
'ROI04_R_IFG'
'ROI05_L_MFG'
'ROI06_R_MFG'
'ROI07_L_AntTemp'
'ROI08_L_PostTemp'
'ROI09_R_AntTemp'
'ROI10_R_PostTemp'
'ROI11_L_AngG'
'ROI12_R_AngG'
);

cd ~/step02_transform_infant_ROIs/

pre="ICBM152"

thres="25"

for ((i=0;i<=11;i++))

do

tempimg=${images[i]};

#upsample the adult ROI
#'adult_folder' is the folder that contain ROIs in adult MNI152 space
#'process' is the folder that used to save process files

flirt -in adult_folder/${tempimg}_${thres}.nii -applyisoxfm 1 -ref adult_folder/${tempimg}_${thres}.nii -out process/upsample_${tempimg}_mask.nii -init $FSLDIR/etc/flirtsch/ident.mat

mri_binarize --i process/upsample_${tempimg}_mask.nii.gz --min 0.1 --o process/bi_upsample_${tempimg}_mask.nii.gz

#negate the adult

ImageMath 3 process/${tempimg}_neg.img Neg process/bi_upsample_${tempimg}_mask.nii.gz

#transform the ROI in adult space to 1-yr-old infant space

antsApplyTransforms -d 3 -i process/${tempimg}_neg.img -o process/neg_deform_${pre}${tempimg}_mask.nii -r infant-1yr-withCerebellum.nii.gz -t ICBM15221yr1Warp.nii.gz -t ICBM15221yr0GenericAffine.mat

#negate back to the infant mask

ImageMath 3 process/${pre}_deform_${tempimg}_mask.nii Neg process/neg_deform_${pre}${tempimg}_mask.nii

#apply a brain mask to get rid of the border voxels

fslmaths process/${pre}_deform_${tempimg}_mask.nii -mas infant-1yr-withCerebellum_mask_z33.nii process/correct_${pre}_deform_${tempimg}.nii.gz

#reslice to the infant functional space

flirt -in process/correct_${pre}_deform_${tempimg}.nii.gz -applyisoxfm 3 -ref infant-1yr-withCerebellum_downsamplefunc.nii.gz -out process/func_correct_mask_${pre}_deform_${tempimg}.nii -init $FSLDIR/etc/flirtsch/ident.mat

#binarize the infant ROI

mri_binarize --i process/func_correct_mask_${pre}_deform_${tempimg}.nii.gz --min 0.5 --o process/bi_func_correct_mask_${pre}_deform_${tempimg}.nii.gz

mri_convert process/bi_func_correct_mask_${pre}_deform_${tempimg}.nii.gz final_1yr_25/${tempimg}_1yr_25.nii

echo "\nfinishing for ${i}\n"

done






