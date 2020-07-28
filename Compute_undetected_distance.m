function udist = Compute_undetected_distance(code_generator, d_tilde, N, crc_poly, base)


%
%   This function computes the undetected distance for the "crc_poly"
%   Inputs:
%       1) code_generator: a matrix specifying the generator of TBCC
%       2) d_tilde: the distance threshold
%       3) N: a scalar denoting the trellis length
%       4) crc_poly: a string represented by "base"
%       5) base: the scalar denoting the base of each crc component
%
%   Outputs:
%       1) udist: a scalar denoting the undetected distance
%

%   Copyright 2020 Hengjie Yang

if nargin < 5
    base = 16;
end

udist = -1;
code_string = '';
for iter = 1:size(code_generator,2)
    code_string = [code_string, num2str(code_generator(iter)), '_'];
end

file_name = ['IEEs_TBCC_',code_string,'d_',num2str(d_tilde),'.mat'];
if ~exist(file_name, 'file')
    disp(['Error: the file ',file_name, ' does not exist!']);
    return
end

load(file_name, 'IEE');

V = IEE.state_ordering;
NumStates = length(V);
Temp_TBPs = cell(d_tilde, 1); % used to find TBPs at each state


TBPs = cell(d_tilde, 1); % official list
for dist = 1:d_tilde
    TBPs{dist} = cell(N+1,1);
end

State_spectrum = zeros(NumStates,1);
Valid_TBPs = cell(d_tilde,1); % stores TBPs of length equal to N


% Step 1: Rebuild the tail-biting paths (TBPs) via IEEs
% Warning: the true distance = dist - 1 because we manually add 1
disp('Step 1: Reconstruct length-N TBPs using dynamic programming.');
for iter = 1:NumStates % find TBPs from every possible start state
    for dist = 1:d_tilde
        Temp_TBPs{dist} = cell(N+1, 1);
    end

    start_state = V(iter);
    List = IEE.list{start_state};
    Lengths = IEE.lengths{start_state};
    disp(['    Current start state: ', num2str(start_state),' number of IEEs: ',...
        num2str(IEE.state_spectrum(start_state))]);

    for dist = 0:d_tilde-1 % true distance
        for len = 1:N %true length
            for weight = dist:-1:0 % true IEE weight
                for ii = 1:size(List{weight+1},1)
                    l = Lengths{weight+1}(ii);
                    if  weight == dist && l == len
                        Temp_TBPs{dist+1}{len+1} =[Temp_TBPs{dist+1}{len+1}; List{weight+1}(ii,1:l)];    
                    elseif l < len && ~isempty(Temp_TBPs{dist-weight+1}{len-l+1})
                        [row, ~] = size(Temp_TBPs{dist-weight+1}{len-l+1});
                        Added_bits = repmat(List{weight+1}(ii,1:l), row ,1);
                        New_TBPs = [Temp_TBPs{dist-weight+1}{len-l+1}, Added_bits];
                        Temp_TBPs{dist+1}{len+1} = [Temp_TBPs{dist+1}{len+1}; New_TBPs];
                    end
                end
            end
        end
    end

    % After building, we need to stack newly found TBPs to existing
    % TBPs
    for dist = 1:d_tilde
        for len = 1:N+1
            if ~isempty(Temp_TBPs{dist}{len})
                TBPs{dist}{len} = [TBPs{dist}{len}; Temp_TBPs{dist}{len}];
            end
        end
    end
end



for dist=1:d_tilde
    if ~isempty(TBPs{dist}{N+1})
        Valid_TBPs{dist} = TBPs{dist}{N+1};
    end
end

clearvars TBPs Temp_TBPs

% Step 2: Build all valid TBPs through circular shift
disp('Step 2: Build remaining TBPs through cyclic shift.');
parfor iter = 1:d_tilde
    disp(['    Current distance: ',num2str(iter-1)]);
    [row, ~] = size(Valid_TBPs{iter});
    % hash table was defined here.

    HashTable = containers.Map;
    for ii  = 1:size(Valid_TBPs{iter},1)
        cur_seq = Valid_TBPs{iter}(ii,:);
        key_cur_seq = dec2bin(bi2de(cur_seq),N);
        HashTable(key_cur_seq) = 1;
    end

    for ii = 1:row
        cur_seq = Valid_TBPs{iter}(ii,:);        
        Extended_seq = [cur_seq, cur_seq]; 
        for shift = 1:N-1
            cyclic_seq = Extended_seq(1+shift:N+shift);
            key_cyclic_seq = dec2bin(bi2de(cyclic_seq),N);
            if isequal(cyclic_seq, cur_seq) % termination condition for cyclic shift
                break
            end
            if ~isKey(HashTable, key_cyclic_seq)
                Valid_TBPs{iter} = [Valid_TBPs{iter};cyclic_seq]; % find a new TBP
                HashTable(key_cyclic_seq) = 1;
            end
        end
    end
end

% Step 3: Identify the minimum undetected distance.
disp('Step 3: Identify the minimum undetected distance by the DSO CRC.');

crc_gen_poly_vec = dec2bin(base2dec(crc_poly, base)) - '0';

for dist = 2:d_tilde
    if ~isempty(Valid_TBPs{dist})
        w = Check_divisible_by_distance(crc_gen_poly_vec, Valid_TBPs{dist});
        if w > 0
            udist = dist - 1;
            disp(['    DSO CRC polynomial: ',num2str(crc_poly)]);
            disp(['    Minimum undetected distance: ',num2str(udist)]);
            break
        end
        if w == 0 && dist == d_tilde
            disp('    d_tilde is insufficient to determine the minimum undetected distance.');
        end
    end
end





