root_path=['..',filesep,'fMRI_data'];
folders=dir([root_path,filesep,'sub*']);

for sub_num=1:length(folders)
    path=[root_path,filesep,folders(sub_num).name];
    runfolder=dir([path,filesep,'ge_func*']);
    for run=1:2 %2 runs
        cond   = {'amb12_S','amb10_S','amb08_S','amb02_S','amb00_S','ide12_S','ide10_S','ide08_S','ide02_S','ide00_S','R'};
        inequ  = [0,1,2,5,6];%offers to the victim, corresponding to inequality level of 12,10,8,2,0
        t=0;
        ons_R_all=[];
        %% parameters for each run
        for typ_num=1:2
            for off_num=1:5
                [ons_S,dur_S,ons_R,dur_R]=onsets_getting_reg(path,run,inequ(off_num),typ_num);
                ons_R_all = [ons_R_all;ons_R];
                for evn=1:length(ons_S)
                    t                = t+1;
                    names{t}         = [cond{(typ_num-1)*5+off_num} num2str(evn,'%02d')];
                    onsets{t}        = ons_S(evn);
                    durations{t}     = 4;
                    pmod(t).name{1}  = 'none';
                    pmod(t).param{1} = 0;
                    pmod(t).poly{1}  = 1;
                end
                clear ons_S dur_S ons_R dur_R
            end
        end
        
        names{t+1}     = cond{11};
        onsets{t+1}    = ons_R_all';
        durations{t+1} = 3;
        
        pmod(t+1).name{1}='none';
        pmod(t+1).param{1}=0;
        pmod(t+1).poly{1}=1;
        
        %save conditions.mat conditions;
        oup_name=['conditions_' runfolder(run).name '_MVPA_reg.mat'];
        save([path,filesep,oup_name], 'names', 'onsets', 'durations','pmod');
        clear ons_R_all names onsets durations pmod
    end
end