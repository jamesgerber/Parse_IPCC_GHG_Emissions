function [CO2eq,rawgas]=getEdgarData(ISO,gas,subsector,YYYY);


persistent   EdgarEmissions_CO2_IPCC1996 EdgarEmissions_CO2_IPCC2006 EdgarEmissions_CO2_CountryTot ...
    EdgarEmissions_CH4_IPCC1996 EdgarEmissions_CH4_IPCC2006 EdgarEmissions_CH4_CountryTot ...
    EdgarEmissions_N2O_IPCC1996 EdgarEmissions_N2O_IPCC2006 EdgarEmissions_N2O_CountryTot ...
    EdgarEmissions_Fgas_IPCC1996 EdgarEmissions_Fgas_IPCC2006 EdgarEmissions_Fgas_CountryTot

if isempty(EdgarEmissions_CO2_IPCC1996)
    
    datadir='/Users/jsgerber/sandbox/jsg203_ClimateSolutionsExplorer/data';
    load([datadir '/EDGAR70/individualsheets/EdgarV70.mat'])
end

idxcountry2006=strmatch(ISO,EdgarEmissions_CH4_IPCC2006.Country_code_A3);
if numel(idxcountry2006)==0
    warning(['did not find ' ISO ' in Edgar data']);
    CO2eq=0;
    rawgas=0;
    return
end

idxcountry1996=strmatch(ISO,EdgarEmissions_CH4_IPCC2006.Country_code_A3);
if numel(idxcountry1996)==0
    error(['did not find ' ISO ' in Edgar data']);
end



switch gas
    
    case {'CH4','ch4','methane'}
        
        
        idx1996=strmatch(subsector,EdgarEmissions_CH4_IPCC1996.ipcc_code_1996_for_standard_report_name);
        idx2006=strmatch(subsector,EdgarEmissions_CH4_IPCC2006.ipcc_code_2006_for_standard_report_name);
        
        if ~isempty(idx1996) & ~isempty(idx2006)
            error(' subsectors overlap - ambiguous')
        end
        
        
        if numel(idx2006)>0
            % IPCC 2006 sectors
            
            % let's confirm we don't have ambiguity here
            
            subsectorname=unique(EdgarEmissions_CH4_IPCC2006.ipcc_code_2006_for_standard_report_name(idx2006));
            
            if numel(subsectorname)>1
                error(' ambiguous subsector name ');
            end
            
            
            idxvect=intersect(idxcountry2006,idx2006);
            
            switch numel(idxvect)
                case 0
                    rawgas=0;
                    CO2eq=0;
                    fossil_bio='fossil';
                case 1
                    idx=idxvect;
                    fieldvalues=EdgarEmissions_CH4_IPCC2006.(['Y_' int2str(YYYY)]);
                    rawgas=fieldvalues(idx);
                    fossil_bio=EdgarEmissions_CH4_IPCC2006.fossil_bio(idx);
                    switch char(fossil_bio)
                        case 'fossil'
                            CO2eq=rawgas*28;
                        case 'bio'
                            CO2eq=rawgas*28;
                    end
                case 2
                    for j=1:numel(idxvect)
                        idx=idxvect(1);
                        fieldvalues=EdgarEmissions_CH4_IPCC2006.(['Y_' int2str(YYYY)]);
                        rawgas=fieldvalues(idx);
                        fossil_bio=EdgarEmissions_CH4_IPCC2006.fossil_bio(idx);
                        
                        switch char(fossil_bio)
                            case 'fossil'
                                CO2eq=rawgas*30;
                            case 'bio'
                                CO2eq=rawgas*28;
                        end
                        
                        idx=idxvect(2);
                        
                        fieldvalues=EdgarEmissions_CH4_IPCC2006.(['Y_' int2str(YYYY)]);
                        rawgastmp=fieldvalues(idx);
                        fossil_bio=EdgarEmissions_CH4_IPCC2006.fossil_bio(idx);
                        
                        
                        switch char(fossil_bio)
                            case 'fossil'
                                CO2eq=CO2eq+rawgastmp*30;
                            case 'bio'
                                CO2eq=CO2eq+rawgastmp*28;
                        end
                        
                        rawgas=rawgas+rawgastmp;
                    end
                    
                otherwise
                    error
            end
        end
        
        
         case {'n2o','N2O'}
        
        idxcountry2006=strmatch(ISO,EdgarEmissions_N2O_IPCC2006.Country_code_A3);

        idx1996=strmatch(subsector,EdgarEmissions_N2O_IPCC1996.ipcc_code_1996_for_standard_report_name);
        idx2006=strmatch(subsector,EdgarEmissions_N2O_IPCC2006.ipcc_code_2006_for_standard_report_name);
        
        if ~isempty(idx1996) & ~isempty(idx2006)
            error(' subsectors overlap - ambiguous')
        end
        
        
        if numel(idx2006)>0
            % IPCC 2006 sectors
            
            % let's confirm we don't have ambiguity here
            
            subsectorname=unique(EdgarEmissions_N2O_IPCC2006.ipcc_code_2006_for_standard_report_name(idx2006));
            
            if numel(subsectorname)>1
                error(' ambiguous subsector name ');
            end
            
            
            idxvect=intersect(idxcountry2006,idx2006);
            
            switch numel(idxvect)
                case 0
                    rawgas=0;
                    CO2eq=0;
                    fossil_bio='fossil';
                case 1
                    idx=idxvect;
                    fieldvalues=EdgarEmissions_N2O_IPCC2006.(['Y_' int2str(YYYY)]);
                    rawgas=fieldvalues(idx);
                    fossil_bio=EdgarEmissions_N2O_IPCC2006.fossil_bio(idx);
                    switch char(fossil_bio)
                        case 'fossil'
                            CO2eq=rawgas*28;
                        case 'bio'
                            CO2eq=rawgas*28;
                    end
                case 2
                    for j=1:numel(idxvect)
                        idx=idxvect(1);
                        fieldvalues=EdgarEmissions_N2O_IPCC2006.(['Y_' int2str(YYYY)]);
                        rawgas=fieldvalues(idx);

                                CO2eq=rawgas*279;
                             
                        
                        idx=idxvect(2);
                        
                        fieldvalues=EdgarEmissions_N2O_IPCC2006.(['Y_' int2str(YYYY)]);
                        rawgastmp=fieldvalues(idx);
                        fossil_bio=EdgarEmissions_N2O_IPCC2006.fossil_bio(idx);
                        
                        

                                CO2eq=CO2eq+rawgastmp*265;
     
                        
                        rawgas=rawgas+rawgastmp;
                    end
                    
                otherwise
                    error
            end
        end
        
        
        
    otherwise
        disp(['have not written this part yet'])
end
