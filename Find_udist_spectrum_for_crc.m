function dist_spec = Find_udist_spectrum_for_crc(code_generator, d_tilde, N, crc_poly, base)

%
%   This function is to find the undetected distance spectrum up to d_tilde
%   for the given "crc_poly". The function relies on the output of
%   "Reconstruct_TBPs"
%
%   Inputs:
%       1) code_generator: a matrix specifying the generator of TBCC
%       2) d_tilde: the distance threshold
%       3) N: the trellis length
%       4) crc_poly: the CRC polynomial in hexadecimal
%       5) base: a scalar denoting the base of crc_poly representation,
%       typically 8 or 16
%
%   Outputs:
%       1) dist_spec: a d_tilde*1 vector, with the i-th entry representing
%       the undetected TBPs with respect to "crc_poly".
%
%   Notes
%       1) Must run "Reconstruct_TBPs.m" first if TBPs are not generated
%       before.

%   Copyright 2020 Hengjie Yang

tic
dist_spec = zeros(d_tilde, 1);

if nargin < 5
    base = 16;
end




code_string = '';
for iter = 1:size(code_generator,2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

% write status messages in a .txt file
file_name = ['status_log_udist_spec_crc_',code_string,'d_',num2str(d_tilde),...
    '_N_',num2str(N),'_CRC_',num2str(crc_poly),'.txt'];
StateFileID = fopen(file_name,'w');



file_name = ['TBP_node_TBCC_',code_string,'d_',num2str(d_tilde),...
    '_N_',num2str(N),'.mat'];
if ~exist(file_name, 'file')
    msg = ['Error: the file ',file_name, ' does not exist!'];
    disp(msg);
    fprintf(StateFileID, '%s\n', msg);
    return
end
load(file_name, 'TBP_node');



Valid_TBPs = TBP_node.list;
d_start = 2;
crc_poly_binary =dec2bin(base2dec(crc_poly, base))-'0';



% Compute the undetected distance spectrum
msg = 'Compute the undetected distance spectrum.';
disp(msg);
fprintf(StateFileID, '%s\n', msg);
aggregate = 0;
for dist = d_start: d_tilde
    if ~isempty(Valid_TBPs{dist})
        dist_spec(dist) = Check_divisible_by_distance(crc_poly_binary, Valid_TBPs{dist});
        aggregate = aggregate + dist_spec(dist);
        msg = ['     Current distance: ',num2str(dist-1),' # of undetected TBPs: ',...
        num2str(dist_spec(dist))];
        disp(msg);
        fprintf(StateFileID, '%s\n', msg);
    end
end
msg = ['Total # of undetected TBPs: ',num2str(aggregate)];
disp(msg);
fprintf(StateFileID, '%s\n', msg);


% Save results
file_name = ['Udist_spec_TBCC_',code_string,'d_',num2str(d_tilde),'_N_',num2str(N),...
    '_CRC_',num2str(crc_poly),'.mat'];
save(file_name,'dist_spec','-v7.3');



timing = toc;
msg = ['Execution time: ',num2str(timing),'s'];
disp(msg);
fprintf(StateFileID, '%s\n', msg);
fclose(StateFileID);

end



function weight = Check_divisible_by_distance(poly_vec,error_events)

% This function computes the undetected weight for "poly_vec" based on "error_events".

weight = 0;
poly_vec = fliplr(poly_vec); % flip degree order from lowest to highest

for i = 1:size(error_events,1)
    temp = double(error_events(i,:));
    [~, remd] = gfdeconv(temp,poly_vec, 2);
    if remd == 0
        weight = weight + 1;
    end
end

end







