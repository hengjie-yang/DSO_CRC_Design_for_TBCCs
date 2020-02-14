 function [aggregate, HashTable, TBPs] = Search_DSO_CRC_by_Construction(code_generator, m, d_tilde, N)

%
%   The function searches the distance-spectrum-optimal (DSO) CRC generator
%   polynomial for the given TBCC.
%
%   Inputs:
%       1) code_generator: a matrix specifying the generator of TBCC
%       2) m: the degree of the objective DSO CRC generator polynomial
%       3) d_tilde: the distance threshold
%       4) N: the trellis length
%
%   Outputs:
%       1) crc_gen_poly: the DSO CRC generator polynomial in octal
%
%   Notes:
%       1) Must run "Collect_Irreducible_Error_Events" first if IEEEs are
%       not generated before
%       2) The distance index equals true distance + 1, whereas the length
%       index equals true length.
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

%Reconstruct the tail-biting paths (TBPs)
V = IEE.ordering;
NumStates = length(V);
Temp_TBPs = cell(d_tilde, 1); % used to find TBPs at each state


TBPs = cell(d_tilde, 1); % official list
for dist = 1:d_tilde
    TBPs{dist} = cell(N+1,1);
end


% Warning: the true distance = dist - 1 because we manually add 1
for iter = 1:NumStates % find TBPs from every possible start state
    for dist = 1:d_tilde
        Temp_TBPs{dist} = cell(N+1, 1);
    end
        
    start_state = V(iter);
    List = IEE.list{start_state};
    Lengths = IEE.lengths{start_state};
    
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
    
    % After building, we need to merge newly found TBPs into existing
    % TBPs
    for dist = 1:d_tilde
        for len = 1:N+1
            if ~isempty(Temp_TBPs{dist}{len})
                TBPs{dist}{len} = [TBPs{dist}{len}; Temp_TBPs{dist}{len}];
            end
        end
    end
            
    
end


Valid_TBPs = cell(d_tilde,1); % stores TBPs of length equal to N
for dist=1:d_tilde
    if ~isempty(TBPs{dist}{N+1})
        Valid_TBPs{dist} = TBPs{dist}{N+1};
    end
end


% % Verify if there are repetitive TBPs after building
% HashNumber = 2^N+1; % This is the maximum number of cyclic shift
% HashTable = zeros(HashNumber, 1);
% for iter = 1:d_tilde
%     for ii = 1:size(Valid_TBPs{iter},1)
%         cur_seq = Valid_TBPs{iter}(ii,:);
%         h = ComputeHash(cur_seq, HashNumber);
%         HashTable(h) = HashTable(h) + 1;
%     end
% end


% Build all valid TBPs through circular shift


for iter = 1:d_tilde
    [row, ~] = size(Valid_TBPs{iter});
    % hash table was defined here.
    
    HashNumber = 2^N+1;
    HashTable = zeros(HashNumber, 1);
    for ii = 1:size(Valid_TBPs{iter},1)
        cur_seq = Valid_TBPs{iter}(ii,:);
        h = ComputeHash(cur_seq, HashNumber);
        HashTable(h) = HashTable(h) + 1;
    end
    
    for ii = 1:row
        cur_seq = Valid_TBPs{iter}(ii,:);
        h_self = ComputeHash(cur_seq, HashNumber);
%         HashTable(h_self) = 1; % mark the original sequence
        Extended_seq = [cur_seq, cur_seq]; 
        for shift = 1:N-1
            cyclic_seq = Extended_seq(1+shift:N+shift);
            h_cyclic = ComputeHash(cyclic_seq, HashNumber);
            if h_cyclic == h_self % termination condition for cyclic shift
                break
            end
            if HashTable(h_cyclic) == 0
                Valid_TBPs{iter} = [Valid_TBPs{iter};cyclic_seq]; % find a new TBP
                HashTable(h_cyclic) = HashTable(h_cyclic) + 1;
            end
        end
    end
end


aggregate = 0;
for dist = 1:d_tilde
    aggregate = aggregate +size(Valid_TBPs{dist},1);
end


end





function h = ComputeHash(input_sequence, HashNumber)
h = 0;
base = 1;
N = size(input_sequence, 2);
for j = 1:N
    h = mod(h + input_sequence(j)*base, HashNumber);
    base = mod(base*2, HashNumber);
end

h = h + 1; % move the starting index to 1

end

            




        
        
    
    
        
        
        
    












