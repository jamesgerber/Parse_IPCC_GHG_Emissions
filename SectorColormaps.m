function cmap=SectorColormaps(sector);
% return a single colormap as an rgb vector or all of them as a cell


switch lower(sector)
    case {'AFOLU','afolu'}
        cmap=[95 146 46]/256;
    case {'Buildings','buildings'}
        cmap=[163 99 174]/256;
    case {'electricity','elec'};
        cmap=[243 89 36]/256;
    case {'ind','industry'}
        cmap=[84   126   206]/256;
    case {'transportation','tran','trans'}
        cmap=[47   150   155]/256;
    case {'other energy','other'};
        cmap=[194   194   194]/256};
    otherwise
        error('don''t know this sector')
end

