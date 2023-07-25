function [ons_S,dur_S,ons_R,dur_R]=onsets_getting(path,run)

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

for cond=1:4
    ons_S(:,cond)=nData(find(nData(:,4)==run & nData(:,7)==cond),12);
    dur_S(:,cond)=ones(length(ons_S),1)*4;
    ons_R(:,cond)=nData(find(nData(:,4)==run & nData(:,7)==cond),13);
    dur_R(:,cond)=ones(length(ons_R),1)*3;
end

