img_path=['..',filesep,'..',filesep,'fMRI_data'];
folder_pattern='sub*';

outpath=['..',filesep,'..',filesep,'MVPA_reg'];
mkdir(outpath);
analysis_name='first_level_MVPA_reg';
MVPA_pre(analysis_name,img_path,folder_pattern);
post_MVPA_normalize(analysis_name,img_path,folder_pattern);
post_MVPA_normalize_mask(analysis_name,img_path,folder_pattern);
post_MVPA_masking_after_smoothing(analysis_name,img_path,folder_pattern);
file_copy_MVPA(analysis_name,img_path,folder_pattern,outpath);

