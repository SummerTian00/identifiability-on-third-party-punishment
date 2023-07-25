root_path=['..',filesep,'fMRI_data'];
folders=dir([root_path,filesep,'sub*']);

for sub_num=1:length(folders)
    path=[root_path,filesep,folders(sub_num).name];
    xlsfile=dir([path,filesep,'ITEfMRI*uniact.xlsx']);
    
    [para,~,~]=xlsread([path,filesep,xlsfile.name]); %1=inequity level;2=ons-offer;3=ons-dec;4=cond
    runfolder=dir([path,filesep,'ge_func*']);
    conds={'unide','ide','Respstage'};
    
    for run=1:2 %2 runs
        %onsets and durations
        %para_temp=[];
        para_temp=para((run-1)*40+1:run*40,:);
        %% parameters for each run
        %amb condition, offer stage
        names{1}=conds{1};
        onsets{1}=para_temp(find(para_temp(:,4)==1),2);
        durations{1}=4;
        pmod(1).name{1}='ineq_unide';
        pmod(1).param{1}=para_temp(find(para_temp(:,4)==1),1);
        pmod(1).poly{1}=1;
        
        %ide condition, offer stage
        names{2}=conds{2};
        onsets{2}=para_temp(find(para_temp(:,4)==2),2);
        durations{2}=4;
        pmod(2).name{1}='ineq_ide';
        pmod(2).param{1}=para_temp(find(para_temp(:,4)==2),1);
        pmod(2).poly{1}=1;
        
        %response stage
        names{3}=conds{3};
        onsets{3}=para_temp(:,3);
        durations{3}=3;
        
        %save conditions.mat conditions;
        oup_name=['conditions_' runfolder(run).name '_uniact.mat'];
        save([path,filesep, oup_name], 'names', 'onsets', 'durations','pmod');
        clear para_temp names onsets durations pmod
    end
    clear para
end