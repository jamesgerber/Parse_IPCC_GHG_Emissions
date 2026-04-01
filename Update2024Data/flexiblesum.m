function y=flexiblesum(x1,x2);
% flexiblesum  sum where blank and nan and chars are 0


if ~isnumeric(x1)
    x1=str2double(char(x1));
end

if isnan(x1)
    x1=0;
end

if ~isnumeric(x2)
    x2=str2double(char(x2));
end

if isnan(x2)
    x2=0;
end



y=x1+x2;