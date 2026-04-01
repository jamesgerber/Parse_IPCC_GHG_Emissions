function [Msum,Mvect,LUvect,ISOlist]=MakeEmissionsCSVFile_updated(ISOlist,YYYY,filename)
% MakeEmissionsCSVFile_NoLULUCF - make .csv of emissions
%
% Syntax
%    MakeEmissionsCSVFile_NoLULUCF(ISO,YYYY) - makes a .csv file
%
%    MakeEmissionsCSVFile_NoLULUCF(ISOlist,YYYY,filename) will output to a
%    particular filename
%
%    MakeEmissionsCSVFile_NoLULUCF(ISOlist,YYYY,directoryname) will output to a
%    particular directory with the default filename
%
%    'WORLD' can be used for ISO
%
%    [Msum,Mvect,LUvect,ISOlist]=MakeEmissionsCSVFile_NoLULUCF(ISOlist,YYYY,filename)    

if nargin==1
    disp('need a year ')
    return
end

if nargin==2
    if ischar(ISOlist)
        filename=['GHGOutputs_NoLULUC_' ISOlist '_' int2str(YYYY) '_updated.csv'];
    else
        error([' need a filename for non-char ISOlist ']);
    end
end

if nargin==3
    if isequal(filename(end),filesep)
        filename=[filename 'GHGOutputs_NoLULUC_' ISOlist '_' int2str(YYYY) '_updated.csv'];
    end
end




if isequal(lower(ISOlist),'world');
    ISOlist=MinxCountriesList;
end

if ischar(ISOlist)
    ISOlist={ISOlist};
end


for j=1:numel(ISOlist);
    ISO=ISOlist{j}
    [M,rows,cols,A,B,OE,IND,T]=AllocateEmissions2026update(ISO,YYYY);
    [LULUCF,version]=getLULUC(ISO,YYYY);
    if numel(find(isnan(M)))>0
        ISO
        keyboard
    end
    if numel(find(isinf(M)))>0
        
        ISO
        rows(find(isinf(sum(M,2))))
        cols(find(isinf(sum(M,1))))
        keyboard
       if j>1
           error('about to add nans to good numbers')
       end
       M(isinf(M))=nan;
        keyboard
    end
    if j==1
        Msum=M;
    else
        Msum=Msum+M;
    end
    Mvect(j)=sum(M(:));
    LUvect(j)=LULUCF;

end

% now some modifications so the output aligns with the original sheet that
% has rows for LULUC and Electricity for AFOLU

newrows(1:6)=rows(1:6);
newrows{7}='LULUCF';
newrows(8:10)=rows(7:9);
newrows{11}='Electrity for FALU';
newrows(12:38)=rows(10:36);

newM(1:6,:)=Msum(1:6,:);
newM(7,4)=LULUCF*1e6;
newM(8:10,:)=Msum(7:9,:);
newM(11,:)=0;
newM(12:38,:)=Msum(10:36,:);

%% now let's make some additions to newM in case we are outputting a 20-year GWP
%DO NOT MODIFY Msum!! don't want to return this ... only goes to csv


global GWPFLAG
if GWPFLAG==20
    disp(['modifying output for GWP20years'])

    if isempty(findstr('20',filename)) | isempty(findstr('GWP',filename))
        error(' only allowed to write to filenames with GWP and 20 in name');
    end

    % first CH4, very easy:
    newMscaled=newM;
    newMscaled(:,5:8)=newM(:,5:8)*81.2/27.9;
    % these are the ratio of GWP for methane from
    % https://www.ipcc.ch/report/ar6/wg1/downloads/report/IPCC_AR6_WGI_Chapter07_SM.pdf

    icol=15;
    irow=strmatch('buildings_nonCO2',newrows);
    x=GetFgasScalings(ISO,YYYY,'buildnc');
    newMscaled(irow,icol)=newM(irow,icol)*x;


    icol=14;
    irow=strmatch('otherenergy_other',newrows);
    x=GetFgasScalings(ISO,YYYY,'othenergy');
    newMscaled(irow,icol)=newM(irow,icol)*x;


    icol=15;
    irow=strmatch('industry_chemical',newrows);

    x=GetFgasScalings(ISO,YYYY,'industrychem');
    newMscaled(irow,icol)=newM(irow,icol)*x;

    icol=15;
    irow=strmatch('industry_metals',newrows);
    x=GetFgasScalings(ISO,YYYY,'industrymetals');
    newMscaled(irow,icol)=newM(irow,icol)*x;


    icol=15;
    irow=strmatch('industry_other',newrows);
    x=GetFgasScalings(ISO,YYYY,'industryotherind')
    newMscaled(irow,icol)=newM(irow,icol)*x;

    newM=newMscaled;
end
%%
clear WriteStruct
WriteStruct.Rows=newrows;

for j=1:numel(cols)
    WriteStruct.(cols{j})=newM(:,j)/1e9;
end
struct2csv(filename,WriteStruct);