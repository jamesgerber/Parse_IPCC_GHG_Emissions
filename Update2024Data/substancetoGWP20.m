function GWP20=substancetoGWP20(substance);

% used chatGPT to reformat, data put into a spreadsheet by Sarah Gleeson

gwp_table = {
    'C2F6', 8940;
    'C3F8', 6770;
    'C4F10', 7300;
    'CF4', 5300;
    'HCFC-141b', 2710;
    'HCFC-142b', 5510;
    'HFC-125', 6740;
    'HFC-134a', 4140;
    'HFC-143a', 7840;
    'HFC-152a', 591;
    'HFC-23', 12400;
    'HFC-32', 2690;
    'SF6', 18200;
    'c-C4F8', 6000;
    'HFC-227ea', 5850;
    'HFC-236fa', 7450;
    'HFC-245fa', 3170;
    'NF3', 13400;
    'HFC-365mfc', 2920;
    'HFC-41', 485;
    'HFC-43-10-mee', 3960;
    'HFC-134', 3900;
    'HFC-143', 1300;
    'C6F14', 6260;
    'C5F12', 6680
};


idx = strcmp(gwp_table(:,1), substance);
GWP20 = gwp_table{idx, 2};