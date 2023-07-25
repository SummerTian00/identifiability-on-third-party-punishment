spm('defaults','fMRI');
spm_jobman('initcfg');
clear matlabbatch;
path=['..',filesep, 'PPI_analysis'];
folders=dir([path,filesep,'Group_PPI*']);
Tvalue=3.435; % to form clusters, corresponding to P < 0.001
for xm=1:length(folders)
    spm('defaults', 'FMRI');
    left_path={'ide_minus_none'};
    right_path={'amb_minus_none'};
    test_name={'SnPM_pt_ideVSamb'};
    for xxx=1:length(test_name);
        mkdir([path,filesep,folders(xm).name,filesep,test_name{xxx}]);
        left_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,left_path{xxx},filesep], '^con.*\.nii$');
        left_img=cellstr(left_img);
        right_img = spm_select ('FPList',[path,filesep, folders(xm).name,filesep,right_path{xxx},filesep], '^con.*\.nii$');
        right_img=cellstr(right_img);
        matlabbatch{1}.spm.tools.snpm.des.PairT.DesignName = 'MultiSub: Paired T test; 2 conditions, 1 scan per condition';
        matlabbatch{1}.spm.tools.snpm.des.PairT.DesignFile = 'snpm_bch_ui_PairT';
        matlabbatch{1}.spm.tools.snpm.des.PairT.dir = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx},filesep]);
        for ym=1:length(left_img)
            matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(ym).scans = {left_img{ym};right_img{ym}};
            matlabbatch{1}.spm.tools.snpm.des.PairT.fsubject(ym).scindex = [1 2];
        end
        matlabbatch{1}.spm.tools.snpm.des.PairT.nPerm = 5000;
        matlabbatch{1}.spm.tools.snpm.des.PairT.vFWHM = [0 0 0];
        matlabbatch{1}.spm.tools.snpm.des.PairT.bVolm = 1;
        matlabbatch{1}.spm.tools.snpm.des.PairT.ST.ST_U = Tvalue;
        matlabbatch{1}.spm.tools.snpm.des.PairT.masking.tm.tm_none = 1;
        matlabbatch{1}.spm.tools.snpm.des.PairT.masking.im = 1;
        matlabbatch{1}.spm.tools.snpm.des.PairT.masking.em = {''};%cellstr(['..',filesep,'group_analysis',filesep,'MVPA',filesep,'ROI_mask.nii']); % no masked used: {''}
        matlabbatch{1}.spm.tools.snpm.des.PairT.globalc.g_omit = 1;
        matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.gmsca.gmsca_no = 1;
        matlabbatch{1}.spm.tools.snpm.des.PairT.globalm.glonorm = 1;
        matlabbatch{2}.spm.tools.snpm.cp.snpmcfg = cellstr([path,filesep,folders(xm).name,filesep,test_name{xxx},filesep,'SnPMcfg.mat']);
        spm_jobman('serial', matlabbatch);
        clear matlabbatch;
    end
end


