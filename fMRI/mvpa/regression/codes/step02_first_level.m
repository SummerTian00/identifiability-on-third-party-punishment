spm('defaults', 'FMRI');
img_path=['..',filesep,'fMRI_data'];
img_folders=dir([img_path,filesep,'sub*']);

for sub_num=1:length(img_folders)
    path=[img_path,filesep,img_folders(sub_num).name];
    mkdir([path,filesep,'first_level_MVPA_reg']);
    out_path=[path,filesep,'first_level_MVPA_reg'];
    run_folder=dir([path,filesep,'ge_func_3p5x3p5x3p5_270*']);
    
    run1_file=spm_select ('FPList',[path,filesep,run_folder(1).name,filesep], '^uaf.*\.nii');
    run1_file= cellstr(run1_file);
    run2_file=spm_select ('FPList',[path,filesep,run_folder(2).name,filesep], '^uaf.*\.nii');
    run2_file= cellstr(run2_file);

    run1_vector=[path ,filesep,'conditions_' run_folder(1).name '_MVPA_reg.mat'];
    run1_vector=cellstr(run1_vector);
    run2_vector=[path,filesep,'conditions_' run_folder(2).name '_MVPA_reg.mat'];
    run2_vector=cellstr(run2_vector);
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(out_path);
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;  
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = run1_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi =run1_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 80;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = run2_file;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi =run2_vector;
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg ={''};
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 80;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    spm_jobman('serial', matlabbatch);
    clear matlabbatch;
end

