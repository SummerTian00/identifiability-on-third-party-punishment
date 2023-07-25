function post_MVPA_masking_after_smoothing(analysis_name,img_path,folder_pattern)

spm('defaults', 'FMRI');
path=img_path;
folders=dir([path,filesep,folder_pattern]);

for i=1:length(folders)
    
    sub_file=folders(i).name;
    
    MVPAfolder=dir([path,filesep,sub_file,filesep,analysis_name '*']);
    
    for j=1:length(MVPAfolder)
        mask_image=spm_select ('FPList',[path,filesep,sub_file,filesep,MVPAfolder(j).name,filesep], '^wmask.*\.nii'); %normalized mask image
        
        %% dprime image
        dprime_folder=dir([path,filesep,sub_file,filesep,MVPAfolder(j).name,filesep,'decoding*']);
        
        for xx=1:length(dprime_folder)
            
            dprime_image=spm_select ('FPList',[path,filesep,sub_file,filesep,MVPAfolder(j).name,filesep,dprime_folder(xx).name,filesep], '^swres_.*\.nii'); %smoothed and masked dprime images
            dprime_image=cellstr(dprime_image);
            
            for yy=1:length(dprime_image)
                [~,fn,~] = fileparts(dprime_image{yy});
                cal_images={mask_image;dprime_image{yy}};
                out_path=[path,filesep,sub_file,filesep,MVPAfolder(j).name,filesep,dprime_folder(xx).name];
                
                %-----------------------------------------------------------------------
                matlabbatch{1}.spm.util.imcalc.input = cellstr(cal_images);
                matlabbatch{1}.spm.util.imcalc.output =  ['m' fn];
                matlabbatch{1}.spm.util.imcalc.outdir = cellstr(out_path);
                matlabbatch{1}.spm.util.imcalc.expression = '(i1>0.9).*i2';
                matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
                matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
                matlabbatch{1}.spm.util.imcalc.options.mask = 0;
                matlabbatch{1}.spm.util.imcalc.options.interp = 1;
                matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
                
                %% do the job
                spm_jobman('serial', matlabbatch);
                clear matlabbatch;
            end
        end
    end
end
