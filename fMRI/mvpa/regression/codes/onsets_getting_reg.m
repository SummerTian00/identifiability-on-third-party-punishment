function [ons_S,dur_S,ons_R,dur_R]=onsets_getting_reg(path,run,inequ,cond)

%% get the data
nTXT=dir(fullfile([path], 'ITEfMRI*.txt'));

rData=textread([path, filesep, nTXT.name],'%s');
[m,n]=size(rData);
nData=reshape(rData,21,m*n/21);
nData=nData';
nData=nData(2:end,3:end-1);
[m,n]=size(nData);
nData3=zeros(m,n);
%i;
for j=1:m
    for k=1:n
        nData3(j,k)=str2num(nData{j,k});
    end
end
nData=nData3;

%% extracting onsets
ons_S=[];
dur_S=[];

ons_R=[];
dur_R=[];


nData(:,7)=(nData(:,7)>2)+1;  %convert the cotnext id: 1=amb;2=ide.
%inequ  = [0,1,2,5,6];%offers to the victim, corresponding to inequality level of 12,10,8,2,0

ons_S=nData(find(nData(:,4)==run & nData(:,7)==cond & nData(:,8)==inequ),12);
dur_S=ones(length(ons_S),1)*4;

ons_R=nData(find(nData(:,4)==run & nData(:,7)==cond & nData(:,8)==inequ),13);
dur_R=ones(length(ons_R),1)*3;

