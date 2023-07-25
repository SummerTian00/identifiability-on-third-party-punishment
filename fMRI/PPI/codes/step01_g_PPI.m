
%% Add the path to the gPPPI toolbox.
spmpath=fileparts(which('spm.m')); % find the pathway of spm.m
addpath([spmpath filesep 'toolbox']);
addpath([spmpath filesep 'toolbox' filesep 'PPPI']);
spm('defaults','fmri')

%% %%%%%%%%%%%%%%%%%%%%%%%%%% path %%%%%%%%%%%%%%%%%%%
returnHere=pwd;
pathx=['..',filesep];
root_dir=[pathx filesep 'fMRI_data'];  %setup path
work_dir=[pathx filesep,'group_analysis',filesep, 'PPI_analysis'];  %working directory, where to store .psfiles

path=root_dir;  %% PPI is based on the first-level analysis of tranditional GLM
mask_path=work_dir; %% where VOI/mask is stored

subfiles=dir([path filesep 'sub*']); %% filename of each subject's directory. start with 3.
ROIfiles=dir([mask_path,filesep,'*.nii']);

%% performing the gPPI for each subject
for x=1:length(subfiles)
    sub_name=subfiles(x).name;
    sub_path=fullfile(path,[subfiles(x).name filesep 'first_level_uniact']);
    for ROI_num=1:length(ROIfiles)
        cd(returnHere)
        ROI_name=ROIfiles(ROI_num).name;
        if exist([sub_path,filesep,'PPI_' ROI_name(1:end-4)],'dir')
            continue;
        end
        P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name);
        PPPI(P,[sub_path,filesep, 'gPPI_' sub_name '_' ROI_name '.mat']);  %% set the parameter for each subject
        clear P;
    end
end
 





 
 
 
