spm('defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch;
path=['..',filesep,'..',filesep,'MVPA_reg'];
folders=dir([path,filesep,'first_level_MVPA_reg*']);
for xm=1:length(folders)
    spm('defaults', 'FMRI');
    left_path={'decoding_ide_ineq_searchlight'};
    right_path={'decoding_amb_ineq_searchlight'};
    test_name={'group_pt_inequ_IvsA'};
    
    for xxx=1:length(test_name);
        mkdir([path,filesep,folders(xm).name,filesep,test_name{xxx} '_zcorr']);
        left_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,left_path{xxx},filesep,'mswres_zcorr',filesep], '^mswres.*\.nii$');
        left_img=cellstr(left_img);
        right_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,right_path{xxx},filesep,'mswres_zcorr',filesep], '^mswres.*\.nii$');
        right_img=cellstr(right_img);
        matlabbatch{1}.spm.stats.factorial_design.dir = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx} '_zcorr',filesep]);
        matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
        matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
        matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
        matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
        matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
        matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
        for ym=1:length(left_img)
            matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(ym).scans = {left_img{ym};right_img{ym}};
        end
        matlabbatch{2}.spm.stats.fmri_est.spmmat = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx} '_zcorr',filesep,'SPM.mat']);
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'pos';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 0;
        spm_jobman('serial', matlabbatch);
        clear matlabbatch;
    end
end




