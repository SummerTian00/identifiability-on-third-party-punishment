%%  This script is used to copy files; From each subject's folder to a  group folder.
path=['..',filesep,'fMRI_data'];
outpath=['..',filesep,'group_analysis',filesep,'PPI_analysis'];
folders=dir([path,filesep,'sub*']);
outputs=dir([outpath,filesep,'Group_PPI*']);
for i=1:length(folders)
    path2=[path,filesep,folders(i).name,filesep, 'first_level_uniact'];
    for j=1:length(outputs)
        outp2={'amb_minus_none','ide_minus_amb','ide_minus_none'};
        for k=1:length(outp2)
            real_input=[path2,filesep,outputs(j).name(7:end),filesep,'con_PPI_' outp2{k} '_' folders(i).name '.nii'];
            if i==1
                mkdir([outpath,filesep,outputs(j).name,filesep,outp2{k}]);
            end
            real_output=[outpath,filesep,outputs(j).name,filesep,outp2{k},filesep,'con_PPI_' outp2{k} '_' folders(i).name(1:5) '.nii'];
            copyfile(real_input,real_output);
        end
    end
end