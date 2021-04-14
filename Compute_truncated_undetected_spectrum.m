function [dist_spec] = Compute_truncated_undetected_spectrum(code_generator, d_tilde, N, crc_poly, base)


% This function computes the truncated weight spectrum up to 'd_tilde' for
% a given CRC polynomial and the TBCC.
%
% Input parameters:
%   1) code_generator: a row vector denoting the TBCC encoder
%   2) d_tilde: a scalar denoting the distance threshold
%   3) N: a scalar denoting the trellis length
%   4) crc_poly: a string represented by "base" with degree from highest
%       to lowest.
%   5) base: a scalar denoting the base of each CRC component
%
% Output parameters:
%   1) dist_spec: a d_tilde-by-1 vector indicating the truncated distance
%       spectrum. The actual distance is one less than its index.
%
% Remarks:
%   1) The information length k = N - deg(crc_poly).
%
% Written by Hengjie Yang (hengjie.yang@ucla.edu)   04/14/21
%




dist_spec = zeros(d_tilde, 1);


if nargin < 5
    base = 16;
end


% Step 1: load all length-N TBPs
code_string = '';
for iter = 1:size(code_generator,2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

fileName = ['TBP_node_TBCC_',code_string,'d_',num2str(d_tilde),'_N_',num2str(N),'.mat'];

if ~exist(fileName, 'file')
    disp(['Error: the file ',fileName, ' does not exist!']);
    return
end
load(fileName, 'TBP_node');
Valid_TBPs = TBP_node.list;

poly = dec2bin(base2dec(crc_poly, base))-'0';
poly = fliplr(poly); % degree from lowest to highest


for dist = 1:d_tilde-1 % true distance
    if ~isempty(Valid_TBPs{dist+1})
        dist_spec(dist+1) = Check_divisible_by_distance(poly, Valid_TBPs{dist+1});
    end
end

end




function weight = Check_divisible_by_distance(poly_vec, error_events)

% This function computes the undetected weight for "poly_vec" based on "error_events".

weight = 0;

for ii = 1:size(error_events,1)
    temp = double(error_events(ii,:));
    temp = fliplr(temp); % flip input sequence degree to "lowest to highest"
    [~, remd] = gfdeconv(temp,poly_vec);
    if any(remd) == 0
        weight = weight + 1;
    end
end

end






    













