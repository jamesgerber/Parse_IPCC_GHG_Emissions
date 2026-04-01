function dagg=AggregateFgasesWithin2006SectorByGWP(d);
% AggregateFgasesWithin2006SectorByGWP
% d must have a field called tonssubstance

namelist=unique(d.ipcc_code_2006_for_standard_report_name);

global GWPFLAG


for j=1:numel(namelist)
    name=namelist{j};
    ii=strmatch(name,d.ipcc_code_2006_for_standard_report_name);

    totgwp=0;
    for m=1:numel(ii)
        idx=ii(m);
        substance=d.Substance{idx};

    if GWPFLAG==100

        GWP100=substancetoGWP100(substance);
        totgwp=nansum([totgwp d.tonssubstance(idx).*GWP100]);


    elseif GWPFLAG==20

        GWP20=substancetoGWP20(substance);
        totgwp=nansum([totgwp d.tonssubstance(idx).*GWP20]);


    else
        error
    end


    end
    dagg.ipcc_code_2006_for_standard_report_name{j}=name;
    dagg.tonsco2eq(j)=totgwp;
end
