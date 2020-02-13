function crc_gen_poly = Search_DSO_CRC_by_Construction(constraint_len, code_generator, m, d_tilde, N)

%
%   The function searches the distance-spectrum-optimal (DSO) CRC generator
%   polynomial for the given TBCC.
%
%   Inputs:
%       1) constraint_len: a scalar indicating the constraint length of
%       TBCC
%       2) code_generator: a matrix specifying the generator of TBCC
%       3) m: the degree of the objective DSO CRC generator polynomial
%       3) d_tilde: the distance threshold
%       4) N: the trellis length
%
%   Outputs:
%       1) crc_gen_poly: the DSO CRC generator polynomial in octal
%
%   Notes:
%       1) Must run "Collect_Irreducible_Error_Events" first if IEEEs are
%       not generated before
%       

%   Copyright 2020 Hengjie Yang

crc_gen_poly = NaN;
code_string = '';
for iter = 1:size(code_generator,2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

file_name = ['IEEs_CC_',code_string,'dtilde_',num2str(d_tilde),'.mat'];
if ~exist(file_name, 'file')
    disp(['Error: the file ',file_name, ' does not exist!']);
    return
end

load(file_name, 'IEE');

%Reconstruct the tail-biting path












