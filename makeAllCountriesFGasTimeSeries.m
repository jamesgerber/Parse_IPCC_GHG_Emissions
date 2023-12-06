
% not sure if this is necessary ... but it can't hurt
ParseGHGDataConstantsDefaults

warning('this code is really slow - not very efficient at all')


% call a script to get a full list of countries (this corrects an error
% that James had noticed in late Nov 2023 (viz. that GADM countries don't
% overlap with Minx countries))
ISOlist=MinxCountriesList;

%ISOlist=ISOlist(1:10)
% Call AllocateEmissions to get 'rows' and 'cols'.  This is better than
% hard coding here because code won't break if we ever change rows/cols
% into M.
[M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG('USA',2019);

% M is a big matrix ... rows are sectors, cols are gases.  It's all just
% bookkeeping from here.


%%% if you wanted to just limit to sectors, you'd need code like this:
%icf=strmatch('otherenergy_coalfugitive',rows);
%iof=strmatch('otherenergy_oilfugitive',rows);
%iburn=strmatch('industry_burningtreatingsolidwaste',rows);
%itreat=strmatch('industry_solidwastedisposal',rows);
%iwastewater=strmatch('industry_wastewatertreatment',rows);


%%
yrvect=1970:2019;
for j=1:numel(ISOlist)
    ISO=ISOlist{j};

    for jyr=1:numel(yrvect);
        YYYY=yrvect(jyr);

        [M, rows, cols, A, B, OE, IND, T]=AllocateEmissionsNFIRevG(ISO,YYYY);

        FgasEmissions(jyr,j)=sum(sum(M(:,13:16)));
        TotEmissions(jyr,j)=sum(sum(M(:,:)));

    end

end
figure,plot(yrvect,sum(FgasEmissions,2)/1e6)
grid on
xlabel('year')
ylabel('Mt CO_2eq')
title(['F gas emissions (Minx et al)'])
fattenplot

figure,plot(yrvect,sum(FgasEmissions,2)./sum(TotEmissions,2)*100)
grid on
xlabel('year')
ylabel('%')
title(['F gas emissions as fraction of total emissions (Minx et al)'])
fattenplot



