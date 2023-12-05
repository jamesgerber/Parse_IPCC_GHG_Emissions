function m=uglyhash(string)
% uglyhash - really ugly and awful hash that will work in Matlab and Octave


m=ASCII2Integer(string(1:2:end));
