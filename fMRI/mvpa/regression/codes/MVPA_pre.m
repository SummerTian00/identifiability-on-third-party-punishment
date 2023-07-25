function MVPA_pre(analysis_name,path,folder_pattern)
%% this is a wapper to call the MVPA function
toolpath='D:\software\MATLAB\MATLAB2016\toolbox\spm12\toolbox\decoding_toolbox_V3.97b';
addpath(genpath(toolpath));%add all subfolders
spm('defaults', 'FMRI');
subfolders=dir([path,filesep,folder_pattern]);
for xx=1:length(subfolders)
    subfold=dir([path,filesep,subfolders(xx).name,filesep,analysis_name '*']);
    for mm=1:length(subfold)
        %% 1. setup paths
        subpath=[path,filesep,subfolders(xx).name,filesep,subfold(mm).name];
        ROIfile=fullfile(subpath,'mask.nii');
        %% 2.extract SPM.mat
        load([subpath,filesep,'SPM.mat']);
        for i=1:length(SPM.Vbeta)
            betafile{i,1}=SPM.Vbeta(i).fname;
            betafile{i,2}=SPM.Vbeta(i).descrip;
        end
        
        I12_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ide12';'S'});
        I12_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ide12';'S'});
        
        I10_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ide10';'S'});
        I10_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ide10';'S'});
        
        I08_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ide08';'S'});
        I08_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ide08';'S'});
        
        I02_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ide02';'S'});
        I02_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ide02';'S'});
        
        I00_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ide00';'S'});
        I00_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ide00';'S'});
        
        
        
        A12_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'amb12';'S'});
        A12_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'amb12';'S'});
        
        A10_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'amb10';'S'});
        A10_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'amb10';'S'});
        
        A08_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'amb08';'S'});
        A08_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'amb08';'S'});
        
        A02_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'amb02';'S'});
        A02_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'amb02';'S'});
        
        A00_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'amb00';'S'});
        A00_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'amb00';'S'});
        
        %% 3.1. run the offer stage: Fair vs. Unfair, identified context
        outfolder  = fullfile(subpath,'decoding_ide_ineq_searchlight');
        
        ide_files  = [I12_run1_images;I10_run1_images;I08_run1_images;I02_run1_images;I00_run1_images;...
                      I12_run2_images;I10_run2_images;I08_run2_images;I02_run2_images;I00_run2_images];
                  
        ide_labels = [ones(length(I12_run1_images),1)*12;ones(length(I10_run1_images),1)*10;ones(length(I08_run1_images),1)*8;ones(length(I02_run1_images),1)*2;ones(length(I00_run1_images),1)*0;...
                      ones(length(I12_run2_images),1)*12;ones(length(I10_run2_images),1)*10;ones(length(I08_run2_images),1)*8;ones(length(I02_run2_images),1)*2;ones(length(I00_run2_images),1)*0];
                  
        ide_desps  = [repmat('ide12',length(I12_run1_images),1); repmat('ide10',length(I10_run1_images),1); repmat('ide08',length(I08_run1_images),1);repmat('ide02',length(I02_run1_images),1);repmat('ide00',length(I00_run1_images),1);...
                      repmat('ide12',length(I12_run2_images),1); repmat('ide10',length(I10_run2_images),1); repmat('ide08',length(I08_run2_images),1);repmat('ide02',length(I02_run2_images),1);repmat('ide00',length(I00_run2_images),1)];
                  
        ide_chunks = [ones(length(I12_run1_images) + length(I10_run1_images) + length(I08_run1_images) + length(I02_run1_images) + length(I00_run1_images),1);...
                      ones(length(I12_run2_images) + length(I10_run2_images) + length(I08_run2_images) + length(I02_run2_images) + length(I00_run2_images),1)*2];
        
        MVPA_reg(ide_files,ide_labels,ide_desps,ide_chunks,outfolder,ROIfile)
        
        %% 3.2. run the offer stage: Fair vs. Unfair, unidentified context
        outfolder  = fullfile(subpath,'decoding_amb_ineq_searchlight');
        
        amb_files  = [A12_run1_images;A10_run1_images;A08_run1_images;A02_run1_images;A00_run1_images;...
            A12_run2_images;A10_run2_images;A08_run2_images;A02_run2_images;A00_run2_images];
        
        amb_labels = [ones(length(A12_run1_images),1)*12;ones(length(A10_run1_images),1)*10;ones(length(A08_run1_images),1)*8;ones(length(A02_run1_images),1)*2;ones(length(A00_run1_images),1)*0;...
            ones(length(A12_run2_images),1)*12;ones(length(A10_run2_images),1)*10;ones(length(A08_run2_images),1)*8;ones(length(A02_run2_images),1)*2;ones(length(A00_run2_images),1)*0];
        
        amb_desps  = [repmat('amb12',length(A12_run1_images),1); repmat('amb10',length(A10_run1_images),1); repmat('amb08',length(A08_run1_images),1);repmat('amb02',length(A02_run1_images),1);repmat('amb00',length(A00_run1_images),1);...
            repmat('amb12',length(A12_run2_images),1); repmat('amb10',length(A10_run2_images),1); repmat('amb08',length(A08_run2_images),1);repmat('amb02',length(A02_run2_images),1);repmat('amb00',length(A00_run2_images),1)];
        
        amb_chunks = [ones(length(A12_run1_images) + length(A10_run1_images) + length(A08_run1_images) + length(A02_run1_images) + length(A00_run1_images),1);...
            ones(length(A12_run2_images) + length(A10_run2_images) + length(A08_run2_images) + length(A02_run2_images) + length(A00_run2_images),1)*2];
        
        MVPA_reg(amb_files,amb_labels,amb_desps,amb_chunks,outfolder,ROIfile)
    end
end