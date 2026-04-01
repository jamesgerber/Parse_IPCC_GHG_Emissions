function GWP100=substancetoGWP100(substance);
% substancetoGWP100 - return a 100yr GWP for F-gases
%
%   GWP100=substancetoGWP100(substance);
%
%  JSG used claude to reformat, data put into a spreadsheet by Sarah Gleeson

gwp_table = {
    'C2F6',         12400;
    'C3F8',          9290;
    'C4F10',        10000;
    'CF4',           7380;
    'HCFC-141b',      860;
    'HCFC-142b',     2300;
    'HFC-125',       3740;
    'HFC-134a',      1530;
    'HFC-143a',      5810;
    'HFC-152a',       164;
    'HFC-23',       14600;
    'HFC-32',         771;
    'SF6',          24300;
    'c-C4F8',        8700;
    'HFC-227ea',     3600;
    'HFC-236fa',     8690;
    'HFC-245fa',      962;
    'NF3',          17400;
    'HFC-365mfc',     914;
    'HFC-41',         135;
    'HFC-43-10-mee', 1600;
    'HFC-134',       1260;
    'HFC-143',        364;
    'C6F14',         8620;
    'C5F12',         9220;
};


idx = strcmp(gwp_table(:,1), substance);
GWP100 = gwp_table{idx, 2};