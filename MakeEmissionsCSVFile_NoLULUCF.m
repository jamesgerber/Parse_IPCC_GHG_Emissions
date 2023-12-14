function [Msum,Mvect,LUvect,ISOlist]=MakeEmissionsCSVFile_NoLULUCF(ISOlist,YYYY,filename)
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
        filename=['GHGOutputs_NoLULUC_' ISOlist '_' int2str(YYYY) '.csv'];
    else
        error([' need a filename for non-char ISOlist ']);
    end
end

if nargin==3
    if isequal(filename(end),filesep)
        filename=[filename 'GHGOutputs_NoLULUC_' ISOlist '_' int2str(YYYY) '.csv'];
    end
end




if isequal(lower(ISOlist),'world');
    ISOlist=MinxCountriesList;
end



for j=1:numel(ISOlist);
     ISO=ISOlist{j}
    [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevG(ISO,YYYY);
     LULUCF=SpatializeRegionalLULUCF_Emissions(ISO);
    if numel(find(isnan(M)))>0
        ISO
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


%%
clear WriteStruct
WriteStruct.Rows=rows;

for j=1:numel(cols)
    WriteStruct.(cols{j})=Msum(:,j)/1e9;
end
struct2csv(filename,WriteStruct);