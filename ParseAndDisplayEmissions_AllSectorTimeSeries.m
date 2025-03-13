function [DS,McolSum,Y]=ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlist,RegionName)
% ParseAndDisplayEmissions_AllSectorTimeSeries
%
% [DS,McolSum,Y]=ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlist,RegionName)
% [DS,McolSum,Y]=ParseAndDisplayEmissions_AllSectorTimeSeries(ISOlist,'noplot')
% suppresses plot
%

%
%
% Electricity
% R=253 G=99 B=23
% #FD6317
%
% Food / Ag
% R=101 G=157 B=42
% #659D2A
%
% Industry
% R=90 G=137 B=215
% #5A89D7
%
% Transport
% R=23 G=161 B=166
% #17A1A6
%
% Buildings
% R=178 G=110 B=185
% #B26EB9
%
% Land Sinks
% R=195 G=136 B=19
% #C38813

AfoluRGB=[101 157 42]/255;
BuildRGB=[178 110 185]/255;
ElecRGB=[253 99 23]/255;
OtherRGB=[200 200 200]/255;
IndRGB=[90 137 215]/255;
TransRGB=[23 161 166]/255;


% prepare ISOlist
if ischar(ISOlist)
    ISOlist={ISOlist};
end

if nargin==1
    RegionName=[ISOlist{1}];
    if numel(ISOlist)>1
        j=2:min(numel(ISOlist),6)
        RegionName=[RegionName '_' ISOlist{j}];
    end
    if numel(ISOlist)>6
        RegionName=[RegionName '_etc'];
    end
end


yearvect=1990:2019;

for jISO=1:numel(ISOlist)
    ISO=ISOlist{jISO};

    for jyear=1:numel(yearvect);
        YYYY=yearvect(jyear);
        [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevH(ISO,YYYY);
        Mcol(:,jyear)=sum(M,2);
    end

    if jISO==1
        McolSum=Mcol;
    else
        McolSum=McolSum+Mcol;
    end
end


McolSum=McolSum/1e9;
%% Now crunch rows
AfoluEmissions=McolSum(strmatch('afolu',rows),:);
BuildEmissions=McolSum(strmatch('build',rows),:);
ElecEmissions=McolSum(strmatch('ele',rows),:);
OtherEmissions=McolSum(strmatch('oth',rows),:);
IndEmissions=McolSum(strmatch('ind',rows),:);
TransEmissions=McolSum(strmatch('trans',rows),:);


Y=[sum(AfoluEmissions,1);sum(BuildEmissions,1); sum(ElecEmissions,1);...
    sum(OtherEmissions,1);sum(IndEmissions,1);sum(TransEmissions,1)];
%%
if isequal(RegionName,'noplot')
    disp('not plotting')
else
    figure
harea=area(yearvect,Y.')

harea(1).FaceColor=AfoluRGB;
harea(2).FaceColor=BuildRGB;
harea(3).FaceColor=ElecRGB;
harea(4).FaceColor=OtherRGB;
harea(5).FaceColor=IndRGB;
harea(6).FaceColor=TransRGB;


    ht=title(['Non-land use Sectors. ' RegionName])
    set(ht,'Interpreter','none')
    %  legend('AFOLU','Buildings','Electricity','Other','Industry','Transportation')
    leglist={'AFOLU','Buildings','Electricity','Other','Industry','Transportation'};
    legend(harea(end:-1:1),leglist(end:-1:1),'location','northwest')

    ylabel('Gt CO_2-eq')
    reallyfattenplot
    uplegend,uplegend

    hold on

    plot(yearvect,cumsum(AfoluEmissions),'k--')
    plot(yearvect,cumsum(BuildEmissions)+sum(Y(1,:),1),'k--')
    plot(yearvect,cumsum(ElecEmissions )+sum(Y(1:2,:),1),'k--')
    plot(yearvect,cumsum(OtherEmissions)+sum(Y(1:3,:),1),'k--')
    plot(yearvect,cumsum(IndEmissions)+sum(Y(1:4,:),1),'k--')
    plot(yearvect,cumsum(TransEmissions)+sum(Y(1:5,:),1),'k--')
    legend('AFOLU','Buildings','Electricity','Other','Industry','Transportation')

    %outputfig('Force',['figures/CountrySectorTimeSeries/SectorTimeSeries_' RegionName]);

    %%
    figure,
    %subplot(1,2,1),
    hax1=axes('Position',[.13 .11 .5 .815]);
    harea=area(yearvect,Y.')

    harea(1).FaceColor=AfoluRGB;
    harea(2).FaceColor=BuildRGB;
    harea(3).FaceColor=ElecRGB;
    harea(4).FaceColor=OtherRGB;
    harea(5).FaceColor=IndRGB;
    harea(6).FaceColor=TransRGB;

    ht=title(['Non-land use Sectors. ' RegionName])
    set(ht,'Interpreter','none')
    reallyfattenplot

    hold on

    plot(yearvect,cumsum(AfoluEmissions),'k--')
    plot(yearvect,cumsum(BuildEmissions)+sum(Y(1,:),1),'k--')
    plot(yearvect,cumsum(ElecEmissions )+sum(Y(1:2,:),1),'k--')
    plot(yearvect,cumsum(OtherEmissions)+sum(Y(1:3,:),1),'k--')
    plot(yearvect,cumsum(IndEmissions)+sum(Y(1:4,:),1),'k--')
    plot(yearvect,cumsum(TransEmissions)+sum(Y(1:5,:),1),'k--')
    ylabel('Gt CO_2-eq');
    hax=axes('Position',[.63 .11 .3 .815]);
    for j=1:32
        %ht=text(0, .01+(j-1)*(1/32), [num2str(sum(McolSum(j,end))/1e6,3) ' Mt. ' rows{j}]);

        ht=text(0,.01+(j-1)*(1/32),sprintf('%12.3f %s',sum(McolSum(j,end)),rows{j}));
        set(ht,'Interpreter','none')
        set(ht,'fontweight','bold')
    end
    set(hax,'Visible','off')
end
%outputfig('Force',['figures/CountrySectorTimeSeries/SectorTimeSeriesWithNums_' RegionName]);

DS.yearvect=yearvect;
DS.AfoluEmissions=cumsum(AfoluEmissions);
DS.BuildEmissions=cumsum(BuildEmissions);
DS.ElecEmissions=cumsum(ElecEmissions);
DS.OtherEmissions=cumsum(OtherEmissions);
DS.IndEmissions=cumsum(IndEmissions);
DS.TransEmissions=cumsum(TransEmissions);

DS.AllAfoluEmissions=sum(DS.AfoluEmissions(end,:),1);
DS.AllBuildEmissions=sum(DS.BuildEmissions(end,:),1);
DS.AllElecEmissions=sum(DS.ElecEmissions(end,:),1);
DS.AllOtherEmissions=sum(DS.OtherEmissions(end,:),1);
DS.AllIndEmissions=sum(DS.IndEmissions(end,:),1);
DS.AllTransEmissions=sum(DS.TransEmissions(end,:),1);

DS.AllEmissions=DS.AllAfoluEmissions+DS.AllBuildEmissions+DS.AllElecEmissions + ...
    DS.AllOtherEmissions+DS.AllIndEmissions+DS.AllTransEmissions;




%%

if 3==4
    %%
    AllISO=unique(c.ISO);
    for j=133:numel(AllISO);
        ISO=AllISO{j};
        idx=strmatch(ISO,c.ISO);

        ParseAndDisplayEmissions_AllSectorTimeSeries(ISO,c.country{idx(1)});
    end
end



