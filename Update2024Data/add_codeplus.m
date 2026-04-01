function X = add_codeplus(X)
% ADD_CODEPLUS  Append disambiguation suffixes to codes with multiple names.
%
%   X = ADD_CODEPLUS(X) scans the 'code' and 'name' fields of structure X
%   and creates a new field 'codeplus' that preserves a unique 1-to-1
%   mapping from code to name. Where a single code maps to multiple distinct
%   names, a numeric suffix (_1, _2, ...) is appended to the code. Suffix
%   numbers are assigned by alphabetical order of the associated names,
%   making the output independent of row order in the input.
%
%   INPUT:
%     X        - Scalar structure with the following fields:
%                  X.code   : cell array of strings {N x 1} or {1 x N}
%                  X.name   : cell array of strings {N x 1} or {1 x N},
%                             same length as X.code
%
%   OUTPUT:
%     X        - Input structure with additional field:
%                  X.codeplus : cell array of strings, same size as X.code.
%                             Codes with a unique name are unchanged.
%                             Codes with multiple names are suffixed _1, _2,
%                             etc., ordered alphabetically by name. The same
%                             code+name pair always receives the same suffix.
%
%   EXAMPLE:
%     X.code  = {'A01','B02','B02','B02','A01','C03'};
%     X.name  = {'Apple','Berry','Banana','Berry','Apple','Cherry'};
%     X = add_codeplus(X);
%     % X.codeplus -> {'A01','B02_2','B02_1','B02_2','A01','C03'}
%     %   (Banana < Berry alphabetically, so Banana -> _1, Berry -> _2)
%
%   NOTES:
%     - Suffix assignment is deterministic and order-independent: results
%       are identical regardless of row ordering in the input.
%     - Codes mapping to only one distinct name receive no suffix.
%     - Duplicate rows (identical code+name) always receive the same codeplus.
%
%   See also: UNIQUE, CONTAINERS.MAP, SORT.
%
%
%
% This code was written by Claude.ai with the following prompts:
%
%
%I have a Matlab structure X with vector of string fields 'code' and
%'name'.   there is supposed to be a 1-1 mapping from code to name, but
%sometimes there are multiple names for a single code.  can you write me
%code that will produce a new field name 'codeplus' that will have a unique
%mapping from code to name, and codeplus will have _1 _2 _3 appended to
%code where appropriate?     
%
%  and then 
%
% can you modify so suffix number assignation is independent of order names
% are encountered (i.e. first do a global check on all codes and names).
% (so outputs are the same no matter what order 'code' and 'name' appear
% in)    
%
%  and then
%
%  can you write a Matlab-standard header comment? (with syntax for calling, etc)



    % --- PASS 1: Global scan to build deterministic code -> names mapping ---
    % Collect all unique (code, name) pairs first
    code_name_map = containers.Map('KeyType','char','ValueType','any');
    
    for i = 1:length(X.code)
        c = X.code{i};
        n = X.name{i};
        if isKey(code_name_map, c)
            existing = code_name_map(c);
            if ~ismember(n, existing)
                code_name_map(c) = [existing, {n}];
            end
        else
            code_name_map(c) = {n};
        end
    end
    
    % Sort names for each code alphabetically -> deterministic suffix assignment
    all_codes = keys(code_name_map);
    suffix_map = containers.Map('KeyType','char','ValueType','char');
    
    for i = 1:length(all_codes)
        c = all_codes{i};
        names = code_name_map(c);
        names_sorted = sort(names);  % alphabetical sort -> deterministic order
        
        if length(names_sorted) == 1
            % 1-to-1: no suffix needed
            suffix_map([c '|||' names_sorted{1}]) = c;
        else
            % Assign _1, _2, ... based on sorted name order
            for j = 1:length(names_sorted)
                key = [c '|||' names_sorted{j}];
                suffix_map(key) = sprintf('%s_%d', c, j);
            end
        end
    end
    
    % --- PASS 2: Assign codeplus to each row ---
    X.codeplus = X.code;
    for i = 1:length(X.code)
        key = [X.code{i} '|||' X.name{i}];
        X.codeplus{i} = suffix_map(key);
    end
end