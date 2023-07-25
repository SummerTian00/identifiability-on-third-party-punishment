function P=gPPI_para_maker(sub_name,sub_path,mask_path,work_dir,ROI_name)
P.subject=sub_name;  %% set the subject names
P.directory=sub_path;%% set the path where SPM.mat file is stored for each subject
P.VOI= [mask_path filesep ROI_name]; %[mask_path filesep 'R_insula_from_spmF_0004.img']; %% this need to be changed for different studies
P.Region=ROI_name(1:end-4);  %% this is the base name of the output directory
P.analysis='psy';
P.method='cond';
P.Estimate=1;
P.contrast=0;
P.extract='mean';
P.Tasks={'0','amb', 'ide'};
P.Weights=[];
P.CompContrasts=1;
P.Weighted=0;
P.GroupDir=[work_dir 'PPI_analysis' filesep 'Group_PPI_' ROI_name(1:end-4)];
P.ConcatR=0;
P.preservevarcorr=0;
P.equalroi=0;
P.FLmask=1;
%%
P.Contrasts(1).left={'amb'};
P.Contrasts(1).right={'none'};
P.Contrasts(1).Contrail={'inequity^1'};
P.Contrasts(1).STAT='T';
P.Contrasts(1).Weighted=0;
P.Contrasts(1).MinEvents=1;

P.Contrasts(2).left={'ide'};
P.Contrasts(2).right={'none'};
P.Contrasts(2).Contrail={'inequity^1'};
P.Contrasts(2).STAT='T';
P.Contrasts(2).Weighted=0;
P.Contrasts(2).MinEvents=1;

P.Contrasts(3).left={'ide'};
P.Contrasts(3).right={'amb'};
P.Contrasts(3).Contrail={'inequity^1'};
P.Contrasts(3).STAT='T';
P.Contrasts(3).Weighted=0;
P.Contrasts(3).MinEvents=1;
return;





