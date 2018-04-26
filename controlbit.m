function output = controlbit(input, follow)
%CONTROLBIT Add an empty bit after every 'follow' quantity in the signal
%   Useful to avoid unwanted xcorr or mesure signal integrity.
%   If input is a matrix, it *MUST* be a column oriented matrix!
%   i.e. The sample of the same signal are in the same row and each signal
%   is in a separate row.
%
%   Copyright 2018 Alexis Nootens <me@axn.io>
%
if isempty(input)
    error('Missing signal');
elseif nargin ~= 2
    error('Invalid arguments');
elseif follow < 2
    error('Invalid ''follow'' argument.');
end

[M,N] = size(input);
if M~=1 && N~=1
    input = num2cell(input, 1);
else
    wascolumn = false;
    if N > 1
        wascolumn = true;
        input = input';
    end
    output = addBit(input, follow);
    if wascolumn, output = output'; end
    return
end

try
    output = cellfun(@(x) addBit(x,follow), input, 'UniformOutput', false);
    output = cell2mat(output);
catch ME
    if strcmp(ME.identifier, 'MATLAB:getReshapeDims:notDivisible')
        error(['The matrix cannot be divided as an natural number of ' ...
            'group. Is it a column oriented matrix?']);
    end
end
end

% -------------------------------------------------------------------------

function padded = addBit(unpadded, position)
% Add an empty bit every position-nth bit in a row vector
required = mod(numel(unpadded), position);
if required ~= 0
    % the result of unpadded/position must be an integer
    unpadded = [unpadded; zeros(position-required, 1)];
end
padded = reshape(unpadded, position, []);
padded(position+1,:) = 0;
padded = reshape(padded, [], 1);
end
