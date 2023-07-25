function MVPA_reg(files,labels,desps,chunks,outfolder,ROIfile)

%% initialize TDT & cfg
cfg = decoding_defaults;

%% 1. setting beta images, including file names and lables (condition names): edit with SPM.mat file
cfg.files.name=files;
cfg.files.descr=desps;
cfg.files.chunk=chunks;  %a vector, one chunk number for each file in cfg.files.name. Chunks can be used to keep data together
cfg.files.label=labels;  % inequality levels:12,10,8,2,0


%% 2. generate design file (cv: cross-validattion)
cfg.design.train=zeros(length(chunks),2); %two folds
cfg.design.test=zeros(length(chunks),2);
cfg.design.label=repmat(labels,1,2); % should be 2 columns, the same number with n_folds

for n_fold=1:2 %two folds
    cfg.design.train(chunks~=n_fold,n_fold)=1;
    cfg.design.test(chunks==n_fold,n_fold)=1;
end

cfg.design.set=ones(1,2);
%% 3. set progress display
cfg.plot_selected_voxels=0; %plot every step
cfg.plot_design = 0; %(default); will plot your design.

%% 4. set the type of analysis that is performed
cfg.analysis='searchlight';% alternatives: 'searchlight', 'wholebrain' ('ROI' does not make sense here);
cfg.searchlight.unit = 'voxels'; % comment or set to 'mm' if you want mm as units
cfg.searchlight.radius = 4; % set searchlight size in voxels
cfg.decoding.method = 'regression'; % choose this for regression

%% 5. set output etc.
%cfg.results.output = {'accuracy_minus_chance', 'dprime'};
cfg.results.output = {'zcorr'};%% For a regression analysis, you would like to 'corr' or better 'zcorr'. 
cfg.results.dir=outfolder; %Output directory [default = fullfile(pwd,'decoding_results')]

cfg.design.unbalanced_data = 'ok'; %Unbalanced training data detected in cfg.design.train(:, 1). If this is ok, set cfg.design.unbalanced_data = 'ok'
cfg.results.overwrite = 1;
cfg.software = 'SPM12';


%% set ROI masks
cfg.files.mask =ROIfile;

[results, cfg] = decoding(cfg);

