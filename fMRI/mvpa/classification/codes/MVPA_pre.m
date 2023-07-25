function MVPA_pre(analysis_name,path,folder_pattern)
%% this is a wapper to call the MVPA function
toolpath='/home/cfeng/CF_software/spm12/toolbox/decoding_toolbox_V3.97b2';
addpath(genpath(toolpath));%add all subfolders
spm('defaults', 'FMRI');
subfolders=dir([path,filesep,folder_pattern]);
for xx=1:length(subfolders)
    subfold=dir([path,filesep,subfolders(xx).name,filesep,analysis_name '*']);
    
    
    %% 1. setup paths
    subpath=[path,filesep,subfolders(xx).name,filesep,subfold.name];
    ROIfile=fullfile(subpath,'mask.nii');
    
    %% 2.extract SPM.mat
    load([subpath,filesep,'SPM.mat']);
    for i=1:length(SPM.Vbeta)
        betafile{i,1}=SPM.Vbeta(i).fname;
        betafile{i,2}=SPM.Vbeta(i).descrip;
    end
    
    IF_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ideF';'S'});
    IF_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ideF';'S'});
    IUF_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ideUF';'S'});
    IUF_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ideUF';'S'});
    
    AF_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ambF';'S'});
    AF_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ambF';'S'});
    AUF_run1_images=extract_beta(subpath,betafile,{'Sn(1)';'ambUF';'S'});
    AUF_run2_images=extract_beta(subpath,betafile,{'Sn(2)';'ambUF';'S'});
    
    %% 3.1.Fair vs. Unfair, identified context
    outfolder=fullfile(subpath,'decoding_IFvsIUF_searchlight');
    MVPA_analysis(IF_run1_images,IF_run2_images,IUF_run1_images,IUF_run2_images,'IF','IUF',outfolder,ROIfile)
    
    %% 3.2. Fair vs. Unfair, unidentified context
    outfolder=fullfile(subpath,'decoding_AFvsAUF_searchlight');
    MVPA_analysis(AF_run1_images,AF_run2_images,AUF_run1_images,AUF_run2_images,'AF','AUF',outfolder,ROIfile)
end