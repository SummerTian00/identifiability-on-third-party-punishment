path=['..',filesep,'fMRI_data'];
folders=dir([path,filesep,'sub*']);

for sub_num=1:length(folders)
    outpath=['..',filesep,'group_analysis',filesep,'uniact']; % the aim folder.
    contrast_names={'01amb','02amb_p','03ide','04ide_p','05_p'};
    filepath=[path,filesep,folders(sub_num).name,filesep,'first_level_uniact']; % contrast files are in "analysis" folder
    confiles=dir([filepath,filesep,'con*.nii']); % find all the contrast files
    for conNum=1:length(confiles)
        if sub_num==1
            mkdir([outpath,filesep],[confiles(conNum).name(1:end-4) '_' contrast_names{conNum}]);
        end
        real_input=[filepath,filesep,confiles(conNum).name(1:end-4) '.nii']; %
        real_output=[outpath,filesep,[confiles(conNum).name(1:end-4) '_' contrast_names{conNum}],filesep,[folders(sub_num).name '_' confiles(conNum).name(1:end-4) '.nii']];
        
        copyfile(real_input, real_output);
    end
end


