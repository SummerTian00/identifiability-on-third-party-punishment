
img_path=['..',filesep,'fMRI_data'];
folder_pattern='sub*';
outpath=['..',filesep,'group_analysis',filesep,'MVPA'];
mkdir(outpath);

analysis_name='first_level_MVPA';

MVPA_pre(analysis_name,img_path,folder_pattern);
post_MVPA_normalize(analysis_name,img_path,folder_pattern);
post_MVPA_normalize_mask(analysis_name,img_path,folder_pattern);
post_MVPA_masking_after_smoothing(analysis_name,img_path,folder_pattern);
file_copy_MVPA(analysis_name,img_path,folder_pattern,outpath);
