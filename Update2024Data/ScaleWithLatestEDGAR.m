function Xout=ScaleWithLatestEDGAR(X,sector,ISO,YYYYold,YYYY);




[EDGARv10,~]=holdEDGAR;

% is intentional (even though it looks like a bug) because the differences
% between v7 and v10 are significant (in other words can't compare v7 and
% v10, and since we want to scale to 2024 we ahve to only use V10)

EDGARv7=EDGARv10;


E10CO2_1996=EDGARv10.EdgarEmissions_CO2_IPCC1996;
E10CO2_1996=subsetofstructureofvectors(E10CO2_1996,strmatch(ISO,E10CO2_1996.Country_code_A3));
E10CH4_1996=EDGARv10.EdgarEmissions_CH4_IPCC1996;
E10CH4_1996=subsetofstructureofvectors(E10CH4_1996,strmatch(ISO,E10CH4_1996.Country_code_A3));
E10N2O_1996=EDGARv10.EdgarEmissions_N2O_IPCC1996;
E10N2O_1996=subsetofstructureofvectors(E10N2O_1996,strmatch(ISO,E10N2O_1996.Country_code_A3));
E10Fgas_1996=EDGARv10.EdgarEmissions_Fgas_IPCC1996;
E10Fgas_1996=subsetofstructureofvectors(E10Fgas_1996,strmatch(ISO,E10Fgas_1996.Country_code_A3));

E10CO2_2006=EDGARv10.EdgarEmissions_CO2_IPCC2006;
E10CO2_2006=subsetofstructureofvectors(E10CO2_2006,strmatch(ISO,E10CO2_2006.Country_code_A3));
E10CH4_2006=EDGARv10.EdgarEmissions_CH4_IPCC2006;
E10CH4_2006=subsetofstructureofvectors(E10CH4_2006,strmatch(ISO,E10CH4_2006.Country_code_A3));
E10N2O_2006=EDGARv10.EdgarEmissions_N2O_IPCC2006;
E10N2O_2006=subsetofstructureofvectors(E10N2O_2006,strmatch(ISO,E10N2O_2006.Country_code_A3));
E10Fgas_2006=EDGARv10.EdgarEmissions_Fgas_IPCC2006;
E10Fgas_2006=subsetofstructureofvectors(E10Fgas_2006,strmatch(ISO,E10Fgas_2006.Country_code_A3));


E7CO2_1996=EDGARv7.EdgarEmissions_CO2_IPCC1996;
E7CO2_1996=subsetofstructureofvectors(E7CO2_1996,strmatch(ISO,E7CO2_1996.Country_code_A3));
E7CH4_1996=EDGARv7.EdgarEmissions_CH4_IPCC1996;
E7CH4_1996=subsetofstructureofvectors(E7CH4_1996,strmatch(ISO,E7CH4_1996.Country_code_A3));
E7N2O_1996=EDGARv7.EdgarEmissions_N2O_IPCC1996;
E7N2O_1996=subsetofstructureofvectors(E7N2O_1996,strmatch(ISO,E7N2O_1996.Country_code_A3));
E7Fgas_1996=EDGARv7.EdgarEmissions_Fgas_IPCC1996;
E7Fgas_1996=subsetofstructureofvectors(E7Fgas_1996,strmatch(ISO,E7Fgas_1996.Country_code_A3));

E7CO2_2006=EDGARv7.EdgarEmissions_CO2_IPCC2006;
E7CO2_2006=subsetofstructureofvectors(E7CO2_2006,strmatch(ISO,E7CO2_2006.Country_code_A3));
E7CH4_2006=EDGARv7.EdgarEmissions_CH4_IPCC2006;
E7CH4_2006=subsetofstructureofvectors(E7CH4_2006,strmatch(ISO,E7CH4_2006.Country_code_A3));
E7N2O_2006=EDGARv7.EdgarEmissions_N2O_IPCC2006;
E7N2O_2006=subsetofstructureofvectors(E7N2O_2006,strmatch(ISO,E7N2O_2006.Country_code_A3));
E7Fgas_2006=EDGARv7.EdgarEmissions_Fgas_IPCC2006;
E7Fgas_2006=subsetofstructureofvectors(E7Fgas_2006,strmatch(ISO,E7Fgas_2006.Country_code_A3));


%E10CH4_2006=aggregatefossilandbio(E10CH4_2006);

ValueColNew=['Y_' num2str(YYYY)];
ValueColOld=['Y_' num2str(YYYYold)];

switch sector

    case 'afolu'
        afolu=X;  % makes for more readable code

        % biomass burning
        % %  CO2 - dont need to include this (just propagating 0s but
        % leaving it in for consistency)
        idxnew=strmatch('Emissions from biomass burning',E10CO2_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Emissions from biomass burning',E7CO2_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.bb.CO2=afolu.bb.CO2.*E10CO2_2006.(ValueColNew)(idxnew)./E7CO2_2006.(ValueColOld)(idxold);

        % %  CH4
        idxnew=strmatch('Emissions from biomass burning',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Emissions from biomass burning',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.bb.CH4=afolu.bb.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);

        % %  N2O
        idxnew=strmatch('Emissions from biomass burning',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Emissions from biomass burning',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.bb.N2O=afolu.bb.N2O.*E10N2O_2006.(ValueColNew)(idxnew)./E7N2O_2006.(ValueColOld)(idxold);

        % managed soils ms
        % % CO2 'Other direct soil emissions' in 1996 categories
        idxnew=strmatch('Other direct soil emissions',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other direct soil emissions',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        afoluNew.ms.CO2=afolu.ms.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        if isinf(afoluNew.ms.CO2)
            afoluNew.ms.CO2=afolu.ms.CO2;
        end

        % % CH4 - no hay

        idxnew=strmatch('Other direct soil emissions',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other direct soil emissions',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        afoluNew.ms.CH4=afolu.ms.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        % % N2O - Direct soil emissions
        idxnew=strmatch('Direct soil emissions',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Direct soil emissions',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        afoluNew.ms.N2O=afolu.ms.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);


        % manure management
        % %  CO2 - dont include this
        % %  CH4
        idxnew=strmatch('Manure Management',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Manure Management',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.mm.CH4=afolu.mm.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);

        % %  N2O
        idxnew=strmatch('Manure Management',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Manure Management',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxnew2=strmatch('Indirect N2O Emissions from manure management',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold2=strmatch('Indirect N2O Emissions from manure management',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.mm.N2O=afolu.mm.N2O.*...
            (E10N2O_2006.(ValueColNew)(idxnew)+E10N2O_2006.(ValueColNew)(idxnew2))./...
            (E7N2O_2006.(ValueColOld)(idxold)+E7N2O_2006.(ValueColOld)(idxold2));

        % enteric fermentation
        idxnew=strmatch('Enteric Fermentation',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Enteric Fermentation',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.ef.CH4=afolu.ef.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);


        % rice cultivation
        idxnew=strmatch('Rice cultivation',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Rice cultivation',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.rc.CH4=afolu.rc.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);

        % synthetic fertilizer

        % %  N2O
        idxnew=strmatch('Direct N2O Emissions from managed soils',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Direct N2O Emissions from managed soils',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxnew2=strmatch('Indirect N2O Emissions from managed soils',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold2=strmatch('Indirect N2O Emissions from managed soils',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        afoluNew.sf.N2O=afolu.sf.N2O.*...
            (E10N2O_2006.(ValueColNew)(idxnew)+E10N2O_2006.(ValueColNew)(idxnew2))./...
            (E7N2O_2006.(ValueColOld)(idxold)+E7N2O_2006.(ValueColOld)(idxold2));

        afoluNew.sf.CH4=afolu.sf.CH4; % no need to scale this it's zero

        if afolu.sf.CH4 ~= 0
            keyboard
        end

        afoluNew.ef.N2O=afolu.ef.N2O; % no need to scale this it's zero

        if afolu.ef.N2O ~= 0
            keyboard
        end

        afoluNew.rc.N2O=afolu.rc.N2O; % no need to scale this it's zero

        if afolu.rc.N2O ~= 0
            keyboard
        end


        afoluNew.sf.Fgas=[];


        Xout=afoluNew;

    case 'buildings'
        buildings=X;

        % now CO2
        idxnew=strmatch('Residential and other sectors',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Residential and other sectors',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        buildingsNew.nr.CO2=buildings.nr.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);
        buildingsNew.re.CO2=buildings.re.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);
        if numel(idxold)>1
            keyboard
        end
        if numel(idxnew)>1
            keyboard
        end
        % CH4
        idxnew=strmatch('Residential and other sectors',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Residential and other sectors',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        buildingsNew.re.CH4=buildings.re.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);
        buildingsNew.nr.CH4=buildings.nr.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);
        if numel(idxold)>1
            keyboard
        end
        if numel(idxnew)>1
            keyboard
        end
        %N2O
        idxnew=strmatch('Residential and other sectors',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Residential and other sectors',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        buildingsNew.re.N2O=buildings.re.N2O.*E10N2O_2006.(ValueColNew)(idxnew)./E7N2O_2006.(ValueColOld)(idxold);
        buildingsNew.nr.N2O=buildings.nr.N2O.*E10N2O_2006.(ValueColNew)(idxnew)./E7N2O_2006.(ValueColOld)(idxold);


        if numel(idxold)>1
            keyboard
        end
        if numel(idxnew)>1
            keyboard
        end



        % end with Fgases ... this is complicated.

        % need to construct a smaller version of the data SOV (structure of
        % vectors).  About to aggregate, need a column called
        % 'tonssubstance'
        tonsOverGg=1000;

        d10=E10Fgas_2006;

        if YYYY>=1990
            if isempty(d10.Y_2019)
                disp(['skipping Fgas scaling for building sector for ' ISO]);
                buildingsNew.nc.Fgas=0;
            else
                d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;
                d10agg=AggregateFgasesWithin2006SectorByGWP(d10);

                d7=E7Fgas_2006;
                d7.tonssubstance=d7.(ValueColOld)*tonsOverGg;
                d7agg=AggregateFgasesWithin2006SectorByGWP(d7);


                idxNew=strmatch('Product Uses as Substitutes for Ozone Depleting Substances',d10agg.ipcc_code_2006_for_standard_report_name);
                idxOld=strmatch('Product Uses as Substitutes for Ozone Depleting Substances',d7agg.ipcc_code_2006_for_standard_report_name);

                if ~isequal(idxNew,idxOld)
                    keyboard
                    % this shouldn't be the case, means different gases reported in Edgar 7
                    % and Edgar 10, could be error, could be different years have different
                    % gases
                end
                buildingsNew.nc.Fgas=buildings.nc.Fgas.*d10agg.tonsco2eq(idxNew)./d7agg.tonsco2eq(idxOld);
            end
        else
            % disp(['year prior to 1990.  Method breaks down.  Swap in data from NFIRevH (Minx)'])

            [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevH(ISO,YYYY);

            % kind of dumb ... but this well get put into the correct place
            % in AllocateEmissions2026Update
            buildingsNew.nc.Fgas=B.Fgas(1,3);
        end
        Xout=buildingsNew;

    case 'otherenergy'
        % other energy according to subsectors
        % 1A1c
        % 1A4ci
        % 1A5a
        % 1B1c
        % 1G1b
        % 5.B
        % 5.A
        % cmf: [1×1 struct] coal minign
        % ogf: [1×1 struct] oil and gas
        % oth: [1×1 struct] other
        % prf: [1×1 struct] petroleum refining

        otherenergy=X;

        % scale coal with 'Fugitive emissions from solid fuels'  (1B1 in
        % RevH spreadsheet)
        % scale 'other' with 'other'
        % scale 'petroleum' with 'other'
        % scale 'oil and gas' with 'Fugitive emissions from oil and gas'

        % scaling default is "Other Energy Industries"
        % this is because in the edgar data, that is by far the biggest
        % component.  However, in the Minx data it is small.   Diving in a
        % bit deeper, 'other energy industries' in EDGAR is 1A1BC, which
        % encompassess refining (1A1B) and whatever is 1A1C.  So there's
        % no way, with EDGAR data, to get the precise other energy
        % components, therefore i'll just sale.


        % complication 'Other Energy Industries'isn't unique ... so use
        % 1A1bc = code
        % CO2
        idxnew=strmatch('Fugitive emissions from solid fuels',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from solid fuels',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.cmf.CO2=otherenergy.cmf.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Fugitive emissions from oil and gas',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from oil and gas',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.ogf.CO2=otherenergy.ogf.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('1A1bc',E10CO2_1996.ipcc_code_1996_for_standard_report);
        idxold=strmatch('1A1bc',E7CO2_1996.ipcc_code_1996_for_standard_report);
        otherenergyNew.oth.CO2=otherenergy.oth.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        if isinf(otherenergyNew.oth.CO2)
            otherenergyNew.oth.CO2=otherenergy.oth.CO2;
        end
        if isinf(otherenergyNew.ogf.CO2)
            otherenergyNew.ogf.CO2=otherenergy.ogf.CO2;
        end
        if isinf(otherenergyNew.cmf.CO2)
            otherenergyNew.cmf.CO2=otherenergy.cmf.CO2;
        end


        idxnew=strmatch('1A1bc',E10CO2_1996.ipcc_code_1996_for_standard_report);
        idxold=strmatch('1A1bc',E7CO2_1996.ipcc_code_1996_for_standard_report);
        otherenergyNew.prf.CO2=otherenergy.prf.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);


        % CH4
        idxnew=strmatch('Fugitive emissions from solid fuels',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from solid fuels',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.cmf.CH4=otherenergy.cmf.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Fugitive emissions from oil and gas',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from oil and gas',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.ogf.CH4=otherenergy.ogf.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('1A1bc',E10CH4_1996.ipcc_code_1996_for_standard_report);
        idxold=strmatch('1A1bc',E7CH4_1996.ipcc_code_1996_for_standard_report);
        otherenergyNew.oth.CH4=otherenergy.oth.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        if isinf(otherenergyNew.oth.CH4)
            otherenergyNew.oth.CH4=otherenergy.oth.CH4;
        end



        idxnew=strmatch('1A1bc',E10CH4_1996.ipcc_code_1996_for_standard_report);
        idxold=strmatch('1A1bc',E7CH4_1996.ipcc_code_1996_for_standard_report);
        otherenergyNew.prf.CH4=otherenergy.prf.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        % N2O
        idxnew=strmatch('Fugitive emissions from solid fuels',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from solid fuels',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.cmf.N2O=otherenergy.cmf.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        if isinf(otherenergyNew.cmf.N2O)
            otherenergyNew.cmf.N2O=otherenergy.cmf.N2O;
        end

        idxnew=strmatch('Fugitive emissions from oil and gas',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Fugitive emissions from oil and gas',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        otherenergyNew.ogf.N2O=otherenergy.ogf.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        if isinf(otherenergyNew.ogf.N2O)
            otherenergyNew.ogf.N2O=otherenergy.ogf.N2O;
        end


        idxnew=strmatch('1A1bc',E10N2O_1996.ipcc_code_1996_for_standard_report);
        idxold=strmatch('1A1bc',E7N2O_1996.ipcc_code_1996_for_standard_report);
        otherenergyNew.oth.N2O=otherenergy.oth.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);


        if isinf(otherenergyNew.oth.N2O)
            otherenergyNew.oth.N2O=otherenergy.oth.N2O;
        end

        % also scale here ('other Energy Industries') nothing corresponds to
        % petroleum refining.

        otherenergyNew.prf.N2O=otherenergy.prf.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        % FGgas



        if isempty(E10Fgas_1996.Y_2019)
            disp(['skipping Fgas scaling for otherenergy sector for ' ISO]);
            otherenergyNew.cmf.Fgas=0;
            otherenergyNew.ogf.Fgas=0;
            otherenergyNew.oth.Fgas=0;
            otherenergyNew.prf.Fgas=0;
        else

            if YYYY>=1990
                tonsOverGg=1000;

                d10=E10Fgas_1996;

                d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;
                d10agg=AggregateFgasesWithin1996SectorByGWP(d10);

                d7=E7Fgas_1996;
                d7.tonssubstance=d7.(ValueColOld)*tonsOverGg;
                d7agg=AggregateFgasesWithin1996SectorByGWP(d7);

                idxnew=strmatch('Other F-gas use',d10agg.ipcc_code_1996_for_standard_report_name);
                idxold=strmatch('Other F-gas use',d7agg.ipcc_code_1996_for_standard_report_name);

                % all but 'oth' zero unless EDGAR changes things, but this is
                % safe coding:
                otherenergyNew.cmf.Fgas=otherenergy.cmf.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);
                otherenergyNew.ogf.Fgas=otherenergy.ogf.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);
                otherenergyNew.oth.Fgas=otherenergy.oth.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);
                otherenergyNew.prf.Fgas=otherenergy.prf.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);
            else
                %  putting in Minx
                [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevH(ISO,YYYY);

                otherenergyNew.cmf.Fgas=OE.Fgas(1,2);
                otherenergyNew.ogf.Fgas=OE.Fgas(2,2);
                otherenergyNew.oth.Fgas=OE.Fgas(3,2);
                otherenergyNew.prf.Fgas=OE.Fgas(4,2);




            end
        end

        %
        % idxnew=strmatch('1A1bc',E10Fgas_1996.ipcc_code_1996_for_standard_report);
        %  idxold=strmatch('1A1bc',E7Fgas_1996.ipcc_code_1996_for_standard_report);
        %  otherenergyNew.prf.Fgas=otherenergy.prf.Fgas.*E10Fgas_1996.(ValueColNew)(idxnew)./E7Fgas_1996.(ValueColOld)(idxold);



        Xout=otherenergyNew;


    case 'industry'
        industry=X;
        % CO2
        idxnew=strmatch('Cement production',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Cement production',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.cem.CO2=industry.cem.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);


        if isinf(industryNew.cem.CO2)
            industryNew.cem.CO2=industry.cem.CO2;
        end


        idxnew=strmatch('Production of chemicals',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Production of chemicals',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.chem.CO2=industry.chem.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Production of metals',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Production of metals',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.met.CO2=industry.met.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        % note .... Other includes 1.A.2 from Minx and Edgar subsectors
        % (revH spreadsheet)
        idxnew=strmatch('Manufacturing Industries and Construction',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Manufacturing Industries and Construction',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.oth.CO2=industry.oth.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Wastewater Treatment and Discharge',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Wastewater Treatment and Discharge',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.wwt.CO2=industry.wwt.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Biological Treatment of Solid Waste',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Biological Treatment of Solid Waste',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.btsw.CO2=industry.btsw.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);


        idxnew=strmatch('Solid Waste Disposal',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Solid Waste Disposal',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.swd.CO2=industry.swd.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);


        % CH4
        idxnew=strmatch('Cement production',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Cement production',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.cem.CH4=industry.cem.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Production of chemicals',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Production of chemicals',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.chem.CH4=industry.chem.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Production of metals',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Production of metals',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.met.CH4=industry.met.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        % note .... Other includes 1.A.2 from Minx and Edgar subsectors
        % (revH spreadsheet)
        idxnew=strmatch('Manufacturing Industries and Construction',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Manufacturing Industries and Construction',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.oth.CH4=industry.oth.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Wastewater handling',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Wastewater handling',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.wwt.CH4=industry.wwt.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Biological Treatment of Solid Waste',E10CH4_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Biological Treatment of Solid Waste',E7CH4_2006.ipcc_code_2006_for_standard_report_name);
        industryNew.btsw.CH4=industry.btsw.CH4.*E10CH4_2006.(ValueColNew)(idxnew)./E7CH4_2006.(ValueColOld)(idxold);


        idxnew=strmatch('Solid waste disposal on land',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Solid waste disposal on land',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.swd.CH4=industry.swd.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);


        % N2O
        idxnew=strmatch('Cement production',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Cement production',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.cem.N2O=industry.cem.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Production of chemicals',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Production of chemicals',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.chem.N2O=industry.chem.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        % seems like a bug (since it's used nearby) but there's nothing
        % specific for metals
        idxnew=strmatch('Manufacturing Industries and Construction',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Manufacturing Industries and Construction',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.met.N2O=industry.met.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        % note .... Other includes 1.A.2 from Minx and Edgar subsectors
        % (revH spreadsheet)
        % seems like a bug (since it's used nearby) but there's nothing
        % specific for metals
        %        idxnew=strmatch('Manufacturing Industries and Construction',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Manufacturing Industries and Construction',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.oth.N2O=industry.oth.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Wastewater handling',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Wastewater handling',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.wwt.N2O=industry.wwt.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        if isfinite(industry.wwt.N2O) & E7N2O_1996.(ValueColOld)(idxold) ==0
            industryNew.wwt.N2O=industry.wwt.N2O;
        end



        idxnew=strmatch('Biological Treatment of Solid Waste',E10N2O_2006.ipcc_code_2006_for_standard_report_name);
        idxold=strmatch('Biological Treatment of Solid Waste',E7N2O_2006.ipcc_code_2006_for_standard_report_name);
        industryNew.btsw.N2O=industry.btsw.N2O.*E10N2O_2006.(ValueColNew)(idxnew)./E7N2O_2006.(ValueColOld)(idxold);

        % emissions zero in Minx et al - so realliy doesn't matter how me match.
        idxnew=strmatch('Other waste handling',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other waste handling',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        industryNew.swd.N2O=industry.swd.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);


        tonsOverGg=1000;

        d10=E10Fgas_2006;

        if isempty(d10.Y_2018)
            disp(['skipping scaling of Fgases for industry for ' ISO]);

            industryNew.cem.Fgas=industry.cem.Fgas;
            industryNew.chem.Fgas=industry.chem.Fgas;
            industryNew.met.Fgas=industry.met.Fgas;
            industryNew.oth.Fgas=industry.oth.Fgas;
            industryNew.cem.Fgas=industry.cem.Fgas;

        else
            if YYYY>=1990
                d10.tonssubstance=d10.(ValueColNew)*tonsOverGg;
                d10agg=AggregateFgasesWithin2006SectorByGWP(d10);

                d7=E7Fgas_2006;
                d7.tonssubstance=d7.(ValueColOld)*tonsOverGg;
                d7agg=AggregateFgasesWithin2006SectorByGWP(d7);

                % Fgas
                idxnew=strmatch('Cement production',E10Fgas_1996.ipcc_code_1996_for_standard_report_name);
                idxold=strmatch('Cement production',E7Fgas_1996.ipcc_code_1996_for_standard_report_name);
                industryNew.cem.Fgas=industry.cem.Fgas.*E10Fgas_1996.(ValueColNew)(idxnew)./E7Fgas_1996.(ValueColOld)(idxold);

                idxnew=strmatch('Chemical Industry',d10agg.ipcc_code_2006_for_standard_report_name);
                idxold=strmatch('Chemical Industry',d7agg.ipcc_code_2006_for_standard_report_name);
                industryNew.chem.Fgas=industry.chem.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);

                idxnew=strmatch('Metal Industry',d10agg.ipcc_code_2006_for_standard_report_name);
                idxold=strmatch('Metal Industry',d7agg.ipcc_code_2006_for_standard_report_name);
                industryNew.met.Fgas=industry.met.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);

                % note .... Other includes 1.A.2 from Minx and Edgar subsectors
                % (revH spreadsheet)
                idxnew=strmatch('Other Product Manufacture and Use',d10agg.ipcc_code_2006_for_standard_report_name);
                idxold=strmatch('Other Product Manufacture and Use',d7agg.ipcc_code_2006_for_standard_report_name);
                industryNew.oth.Fgas=industry.oth.Fgas.*d10agg.tonsco2eq(idxnew)./d7agg.tonsco2eq(idxold);
            else
                [M,rows,cols,A,B,OE,IND,T]=AllocateEmissionsNFIRevH(ISO,YYYY);

                industryNew.cem.Fgas=IND.Fgas(1,3);
                industryNew.chem.Fgas=IND.Fgas(2,3);
                industryNew.met.Fgas=IND.Fgas(3,3);
                industryNew.oth.Fgas=IND.Fgas(4,3);

            end


        end

        Xout=industryNew;

    case 'electricity'

        % special case ... just passing out a factor.

        idxnew=strmatch('Public electricity and heat production',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Public electricity and heat production',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        Xout=E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

    case 'transport'

        transport=X;
        transportNew=transport;
        % CO2
        idxnew=strmatch('Domestic aviation',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Domestic aviation',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.da.CO2=transport.da.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Inland navigation',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Inland navigation',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.inls.CO2=transport.inls.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        if isinf(transportNew.inls.CO2)
            transportNew.inls.CO2=transport.inls.CO2;
        end


        idxnew=strmatch('Other transportation',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other transportation',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ot.CO2=transport.ot.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Rail transportation',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Rail transportation',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ra.CO2=transport.ra.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);
        if isfinite(transport.ra.CO2) & E7CO2_1996.(ValueColOld)(idxold) ==0
            transportNew.ra.CO2=transport.ra.CO2;
        end


        idxnew=strmatch('Road transportation no resuspension',E10CO2_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Road transportation no resuspension',E7CO2_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ro.CO2=transport.ro.CO2.*E10CO2_1996.(ValueColNew)(idxnew)./E7CO2_1996.(ValueColOld)(idxold);

        if isfinite(transport.ro.CO2) & E7CO2_1996.(ValueColOld)(idxold) ==0
            transportNew.ro.CO2=transport.ro.CO2;
        end

        if isinf(transportNew.ot.CO2)
            transportNew.ot.CO2=transport.ot.CO2;
        end

        % CH4
        idxnew=strmatch('Domestic aviation',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Domestic aviation',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.da.CH4=transport.da.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Inland navigation',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Inland navigation',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.inls.CH4=transport.inls.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);
        if isinf(transportNew.inls.CH4)
            transportNew.inls.CH4=transport.inls.CH4;
        end
        idxnew=strmatch('Other transportation',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other transportation',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ot.CH4=transport.ot.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        if isinf(transportNew.ot.CH4)
            transportNew.ot.CH4=transport.ot.CH4;
        end


        idxnew=strmatch('Rail transportation',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Rail transportation',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ra.CH4=transport.ra.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Road transportation no resuspension',E10CH4_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Road transportation no resuspension',E7CH4_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ro.CH4=transport.ro.CH4.*E10CH4_1996.(ValueColNew)(idxnew)./E7CH4_1996.(ValueColOld)(idxold);

        if isinf(transportNew.ra.CH4)
            transportNew.ra.CH4=transport.ra.CH4;
        end
        if isinf(transportNew.ro.CH4)
            transportNew.ro.CH4=transport.ro.CH4;
        end


        % N2O
        idxnew=strmatch('Domestic aviation',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Domestic aviation',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.da.N2O=transport.da.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        idxnew=strmatch('Inland navigation',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Inland navigation',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.inls.N2O=transport.inls.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);
        if isinf(transportNew.inls.N2O)
            transportNew.inls.N2O=transport.inls.N2O;
        end
        idxnew=strmatch('Other transportation',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Other transportation',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ot.N2O=transport.ot.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        if isinf(transportNew.ot.N2O)
            transportNew.ot.N2O=transport.ot.N2O;
        end

        idxnew=strmatch('Rail transportation',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Rail transportation',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ra.N2O=transport.ra.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);

        if isinf(transportNew.ra.N2O)
            transportNew.ra.N2O=transport.ra.N2O;
        end


        idxnew=strmatch('Road transportation no resuspension',E10N2O_1996.ipcc_code_1996_for_standard_report_name);
        idxold=strmatch('Road transportation no resuspension',E7N2O_1996.ipcc_code_1996_for_standard_report_name);
        transportNew.ro.N2O=transport.ro.N2O.*E10N2O_1996.(ValueColNew)(idxnew)./E7N2O_1996.(ValueColOld)(idxold);


        Xout=transportNew;

end
