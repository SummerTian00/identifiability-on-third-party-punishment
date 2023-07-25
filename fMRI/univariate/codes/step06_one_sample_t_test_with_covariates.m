spm('defaults', 'FMRI');
img_path=['..',filesep,'group_analysis',filesep,'con_ideVSunide_p'];
con_file=spm_select ('FPList',[img_path,filesep], '.*sub.*\.nii');
con_file= cellstr(con_file);
load([img_path,'/ref_point_ideVSunide.mat']);

mkdir(img_path,'Group_cov_ref_point');
out_path=[img_path,filesep,'Group_cov_ref_point'];

matlabbatch{1}.spm.stats.factorial_design.dir =cellstr(out_path);
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = con_file;
matlabbatch{1}.spm.stats.factorial_design.cov.c = cov_dat;
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'ref_point';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [0 1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
spm_jobman('serial', matlabbatch);
clear matlabbatch;



