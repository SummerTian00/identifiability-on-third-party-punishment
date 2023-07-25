load('design.mat');
[par,~,~]=xlsread('IndPars_fit_vm_ad.xlsx');
subs=par(:,1);
par=par(:,2:size(par,2));

names={'subid',	'xd','xv','choice','cond','choice_category','trial','choice_real'};
commaheader = [names;repmat({','},1,numel(names))];
commaheader=commaheader(:)';
textheader=cell2mat(commaheader);

for sim_n=1:50 %do the simulation 50 times
    for n=1:length(subs)
        design_sub=design(design(:,1)==subs(n),:);
        if n==1
            sim_data=simu_fit_vm_ad(par(n,:),design_sub);
        else
            sim_data=[sim_data;simu_fit_vm_ad(par(n,:),design_sub)];
        end
    end
    
    fid = fopen([pwd,filesep,'sim_data',filesep,'sim_data_vm_ad' num2str(sim_n,'%02d') '.csv'],'w');
    fprintf(fid,'%s\n',textheader);
    %write out data to end of file
    dlmwrite([pwd,filesep,'sim_data',filesep,'sim_data_vm_ad' num2str(sim_n,'%02d') '.csv'],sim_data,'-append','precision',8);
    fclose('all');
    
    %save([pwd,filesep,'sim_data',filesep,'sim_data_vm_ad' num2str(sim_n,'%02d') '.mat'], 'sim_data');
    sim_data_all(:,:,sim_n)=sim_data;
    clear design_sub sim_data fid
end
