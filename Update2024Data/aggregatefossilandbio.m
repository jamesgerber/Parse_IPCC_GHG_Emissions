function X=aggregatefossilandbio(X);
%aggregatefossilandbio - collapse across fossil and bio

fn=fieldnames(X);

for j=1:numel(fn)

    Y=X.(fn{j});

    %%  Y is now something like EdgarEmissions_CH4_IPCC1996


% add a field with a code that is unique
% for example, have this in CO2
% ipcc_code_1996_for_standard_report	ipcc_code_1996_for_standard_report_name
% 1B2	Fugitive emissions from gaseous fuels
% 1B2	Fugitive emissions from liquid fuels
% 1B2	Fugitive emissions from oil and gas

% if isfield(Y,'ipcc_code_2006_for_standard_report')
%     ipccYYYYcode='ipcc_code_2006_for_standard_report';
%     ipccYYYYname='ipcc_code_2006_for_standard_report_name';
% else
%     ipccYYYYcode='ipcc_code_1996_for_standard_report';
%     ipccYYYYname='ipcc_code_1996_for_standard_report_name';
% end







    if isfield(Y,'fossil_bio') & numel(unique(Y.fossil_bio))>1
        % second conditions makes sure we don't try to combine across
        % substances

        % ok, there is a fossil_bio field.  Let's go through for every field
        % that doesn't start 'Y_' (those are the data fields

        CClist=unique(Y.Country_code_A3);

     %   namelist=unique(Y.ipcc_code_2006_for_standard_report);
        namelist=unique(Y.codeplus);


        for countA3=1:numel(CClist)
            for countcode=1:numel(namelist);
                ISO=CClist{countA3};
                code=namelist{countcode};
                ii=strmatch(ISO,Y.Country_code_A3);
                jj=strmatch(code,Y.codeplus);

                if numel(intersect(ii,jj))>1
                    kk=intersect(ii,jj);
                    
                    if numel(kk)~=2
                        keyboard
                        error
                    end
                    W=subsetofstructureofvectors(Y,kk);

                    tmp=fieldnames(W);
                    Ynames=tmp(strmatch('Y',tmp));
                    
                    for mm=1:numel(Ynames)
                        Yname=Ynames{mm};
                        x1=W.(Yname)(1);
                        x2=W.(Yname)(2);

                        % force sum to go into 1st one
                        % useful for debugging, but better to write directly into Y
                        %                      W.(Yname)(1)=flexiblesum(x1,x2);
                        %                      W.(Yname)(2)=0;

                        Y.(Yname)(kk(1))=flexiblesum(x1,x2);
                    end

                    % now remove kk(2) from Y
                    Y=subsetofstructureofvectors(Y,setdiff(1:numel(Y.fossil_bio),kk(2)));

                end
            end
        end
    end
    X.(fn{j})=Y;


end