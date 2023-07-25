root_path=['..',filesep,'fMRI_data'];
folders=dir([root_path,filesep,'sub*']);

for sub_num=1:length(folders)
    path=[root_path,filesep,folders(sub_num).name];
    runfolder=dir([path,filesep,'ge_func*']);
    for run=1:2 %2 runs
        cond={'ambF_S','ambUF_S','ideF_S','ideUF_S','R'};
        
        [ons_S,dur_S,ons_R,dur_R]=onsets_getting(path,run);
        ons_R=reshape(ons_R,1,numel(ons_R));
        t=0;
        %% parameters for each run
        for typ_num=1:4
            for evn=1:length(ons_S)
                t                = t+1;
                names{t}         = [cond{typ_num} num2str(evn,'%02d')];
                onsets{t}        = ons_S(evn,typ_num);
                durations{t}     = 4;
                pmod(t).name{1}  = 'none';
                pmod(t).param{1} = 0;
                pmod(t).poly{1}  = 1;
            end
        end
        
        names{t+1}     = cond{5};
        onsets{t+1}    = ons_R;
        durations{t+1} = 3;
        
        pmod(t+1).name{1}='none';
        pmod(t+1).param{1}=0;
        pmod(t+1).poly{1}=1;
        
        %save conditions.mat conditions;
        oup_name=['conditions_' runfolder(run).name '_MVPA.mat'];
        save([path,filesep,oup_name], 'names', 'onsets', 'durations','pmod');
    end
end