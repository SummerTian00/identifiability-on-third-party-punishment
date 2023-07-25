function file_copy_MVPA(analysis_name,path,folder_pattern,outpath)

folders=dir([path,filesep,folder_pattern]);
for i=1:length(folders)
    sub_file=folders(i).name;
    MVPAfolder=dir([path,filesep,sub_file,filesep,analysis_name '*']);
    
    for j=1:length(MVPAfolder)
        filepath=[path,filesep,folders(i).name,filesep,MVPAfolder(j).name];
        
        search_folders=dir([filepath,filesep,'*_searchlight']);
        
        for conNum=1:length(search_folders)
            
            outputs=dir([filepath,filesep,search_folders(conNum).name,filesep,'msw*.nii']);
            
            for zz=1:length(outputs)
                
                if i==1
                    mkdir([outpath,filesep,MVPAfolder(j).name,filesep],[search_folders(conNum).name,filesep,outputs(zz).name(1:end-4)]); %making some output folders in the aim folder
                end
                real_input=[filepath,filesep,search_folders(conNum).name,filesep,outputs(zz).name(1:end-4) '.nii']; %
                real_output=[outpath,filesep,MVPAfolder(j).name,filesep,search_folders(conNum).name,filesep,outputs(zz).name(1:end-4),filesep,[outputs(zz).name(1:end-4) '_' folders(i).name(1:5) '.nii']];
                copyfile(real_input, real_output);
            end
        end
    end
end


