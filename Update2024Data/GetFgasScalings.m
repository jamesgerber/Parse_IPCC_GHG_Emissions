function x=GetFgasScalings(ISO,YYYY,sector);

[EDGARv10,EDGARv7]=holdEDGAR;

E10Fgas_2006=EDGARv10.EdgarEmissions_Fgas_IPCC2006;
E10Fgas_1996=EDGARv10.EdgarEmissions_Fgas_IPCC1996;

E10Fgas_1996=subsetofstructureofvectors(E10Fgas_1996,strmatch(ISO,E10Fgas_1996.Country_code_A3));
E10Fgas_2006=subsetofstructureofvectors(E10Fgas_2006,strmatch(ISO,E10Fgas_2006.Country_code_A3));

if YYYY<1990
    % we have extended to pre-1990.  Dno't have any data prior to 1990 to
    % use for scaling, just just limit to 1990.
    YYYY=1990;
end
ValueColNew=['Y_' int2str(YYYY)];
% GetFgasScalings('USA',2019,'buildnc')
% GetFgasScalings('USA',2019,'othenergy')
% GetFgasScalings('USA',2019,'industrychem')
% GetFgasScalings('USA',2019,'industrymetals')
% GetFgasScalings('USA',2019,'industryotherind')


if isempty(E10Fgas_2006.Y_2000)
    x=1;
    return
end

global GWPFLAG
GWPFLAGstash=GWPFLAG;

switch sector

    case 'buildnc'
        tonsOverGg=1000;
        d10=E10Fgas_2006;
        d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;

        GWPFLAG=100
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Other Product Manufacture and Use',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP100=d10agg.tonsco2eq(idx);
        GWPFLAG=20;
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Other Product Manufacture and Use',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP20=d10agg.tonsco2eq(idx);

        x=GWP20/GWP100;


    case 'othenergy'
        tonsOverGg=1000;
        d10=E10Fgas_1996;
        d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;

        GWPFLAG=100
        d10agg=AggregateFgasesWithin1996SectorByGWP(d10);
        idx=strmatch('Other F-gas use',d10agg.ipcc_code_1996_for_standard_report_name);

        GWP100=d10agg.tonsco2eq(idx);
        GWPFLAG=20;
        d10agg=AggregateFgasesWithin1996SectorByGWP(d10);
        idx=strmatch('Other F-gas use',d10agg.ipcc_code_1996_for_standard_report_name);

        GWP20=d10agg.tonsco2eq(idx);

        x=GWP20/GWP100;

    case  'industrychem'

  tonsOverGg=1000;
        d10=E10Fgas_2006;
        d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;

        GWPFLAG=100
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Chemical Industry',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP100=d10agg.tonsco2eq(idx);
        GWPFLAG=20;
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Chemical Industry',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP20=d10agg.tonsco2eq(idx);

        x=GWP20/GWP100;





    case 'industrymetals'
  tonsOverGg=1000;
        d10=E10Fgas_2006;
        d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;

        GWPFLAG=100
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Metal Industry',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP100=d10agg.tonsco2eq(idx);
        GWPFLAG=20;
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Metal Industry',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP20=d10agg.tonsco2eq(idx);

        x=GWP20/GWP100;




    case 'industryotherind'
        tonsOverGg=1000;
        d10=E10Fgas_2006;
        d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;

        GWPFLAG=100
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Other Product Manufacture and Use',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP100=d10agg.tonsco2eq(idx);
        GWPFLAG=20;
        d10agg=AggregateFgasesWithin2006SectorByGWP(d10);
        idx=strmatch('Other Product Manufacture and Use',d10agg.ipcc_code_2006_for_standard_report_name);

        GWP20=d10agg.tonsco2eq(idx);

        x=GWP20/GWP100;


    otherwise
        keyboard
end


if isempty(x)
    x=1;
end
GWPFLAG=GWPFLAGstash;
