function [E10,E7]=holdEDGAR;
% holdEDGAR - store EDGAR in a persistent to speed code development


persistent EDGARv10 EDGARv7
if isempty(EDGARv7)
    EDGARv10=    load(['~/DataProducts/ext/EDGAR/Feb11_2026/processeddata/EdgarV2025.mat']);
    EDGARv7=load(['~/DataProducts/ext/EDGAR/EDGARV7/EdgarV70_withuniquecode.mat']);

    EDGARv10=aggregatefossilandbio(EDGARv10);
    EDGARv7=aggregatefossilandbio(EDGARv7);

    X=EDGARv10;

    fn=fieldnames(X);

    for j=1:numel(fn)
       % j
        Y=X.(fn{j});
        tmp=fieldnames(Y);
        Ynames=tmp(strmatch('Y',tmp));

        for mm=1:numel(Ynames)
            Yname=Ynames{mm};
            x=Y.(Yname);

            if iscell(x);
                z=str2double(x);
                x=z;
            end

            Y.(Yname)=x;
        end

        X.(fn{j})=Y;
    end
    EDGARv10=X;


    X=EDGARv7;

    fn=fieldnames(X);

    for j=1:numel(fn)
    %    j
        Y=X.(fn{j});
        tmp=fieldnames(Y);
        Ynames=tmp(strmatch('Y',tmp));

        for mm=1:numel(Ynames)
            Yname=Ynames{mm};
            x=Y.(Yname);

            if iscell(x);
                z=str2double(x);
                x=z;
            end

            Y.(Yname)=x;
        end

        X.(fn{j})=Y;
    end
    EDGARv7=X;



end


E10=EDGARv10;
E7=EDGARv7;
