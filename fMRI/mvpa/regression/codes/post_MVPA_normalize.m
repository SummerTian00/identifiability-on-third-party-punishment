function post_MVPA_normalize(analysis_name,path,folder_pattern)

%% This script is used to normalize and smooth zcorr images after MVPA analysis.
spm('defaults', 'FMRI');
folders=dir([path,filesep,folder_pattern]);
for i=1:length(folders)
    sub_file=folders(i).name;
    % anat file
    anat_folder=dir([path,filesep, sub_file,filesep,'t1_mprage*']);
    anat_file=spm_select ('FPList',[path,filesep,sub_file,filesep,anat_folder(1).name,filesep], '^Brain.*\.nii');
    anat_file=cellstr(anat_file);
    
    %%  transform matrix
    def_file=spm_select ('FPList',[path,filesep,sub_file,filesep,anat_folder(1).name], '^y_s.*\.nii');
    def_file=cellstr(def_file);
    
    %% zcor image
    MVPAfolder=dir([path,filesep,sub_file,filesep,analysis_name '*']);
    
    for j=1:length(MVPAfolder)
        zcorr_folder=dir([path,filesep, sub_file,filesep,MVPAfolder(j).name,filesep,'*_searchlight']);
        
        for xx=1:length(zcorr_folder)
            
            zcorr_image=spm_select ('FPList',[path,filesep,sub_file,filesep,MVPAfolder(j).name,filesep,zcorr_folder(xx).name,filesep], '^res.*\.nii');
            zcorr_image=cellstr(zcorr_image);
            
            for yy=1:length(zcorr_image)
                
                %1. coregister to T1 image
                matlabbatch{1}.spm.spatial.coreg.estimate.ref = anat_file;
                matlabbatch{1}.spm.spatial.coreg.estimate.source = zcorr_image(yy);
                matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                
                %2. normalize the image
                matlabbatch{2}.spm.spatial.normalise.write.subj.def(1) = def_file;
                matlabbatch{2}.spm.spatial.normalise.write.subj.resample(1) =  zcorr_image(yy);
                matlabbatch{2}.spm.spatial.normalise.write.woptions.bb = [-90 -126 -72
                    90 90 108];
                matlabbatch{2}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
                matlabbatch{2}.spm.spatial.normalise.write.woptions.interp = 4;
                matlabbatch{2}.spm.spatial.normalise.write.woptions.prefix = 'w';
                
                %smooth the image
                matlabbatch{3}.spm.spatial.smooth.data =cfg_dep('Normalise: Write: Normalised Images (Subj 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
                matlabbatch{3}.spm.spatial.smooth.fwhm = [8 8 8];
                matlabbatch{3}.spm.spatial.smooth.dtype = 0;
                matlabbatch{3}.spm.spatial.smooth.im = 0;
                matlabbatch{3}.spm.spatial.smooth.prefix = 's';
                
                spm_jobman('serial', matlabbatch);
                clear matlabbatch;
            end
        end
    end
end
