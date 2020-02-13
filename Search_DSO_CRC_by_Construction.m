function [crc_gen_poly, Valid_TBPs] = Search_DSO_CRC_by_Construction(code_generator, m, d_tilde, N)

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
    TBPs{dist} = cell(N,1);
end


% Warning: the true distance = dist - 1 because we manually add 1
for iter = 1:NumStates % find TBPs from every possible start state
    for dist = 1:d_tilde
        Temp_TBPs{dist} = cell(N, 1);
    end
        
    start_state = V(iter);
    List = IEE.list{start_state};
    Lengths = IEE.lengths{start_state};
    
    % try each possible IEE as starting point for dynamic programming
    for ds=1:d_tilde
        if~isempty(List{ds})
            for is = 1:size(List{ds},1)
                len = Lengths{ds}(is);
                Temp_TBPs{ds}{len} = List{ds}(is,1:len);
    
                % dynamic programming
                for dd = 1:d_tilde
                    if ~isempty(List{dd})
                        for ii = 1:size(List{dd},1)
                            len = Lengths{dd}(ii);
                            weight = dd-1;
                            for dist=1:d_tilde-weight % fake distance
                                for st_len = 1:N-len % true start length                        
                                    if ~isempty(Temp_TBPs{dist}{st_len})
                                        [row,~] = size(Temp_TBPs{dist}{st_len});
                                        Added_Bits = repmat(List{dd}(ii, 1:len),row,1);
                                        New_TBPs = [Temp_TBPs{dist}{st_len}, Added_Bits];
                                        Temp_TBPs{dist+weight}{st_len+len}=[Temp_TBPs{dist+weight}{st_len+len};New_TBPs]; 
                                    end                      
                                end
                            end
                        end
                    end
                end
                
                % After building, we need to merge newly found TBPs into existing
                % TBPs
                for dist=1:d_tilde
                    for len=1:N
                        if ~isempty(Temp_TBPs{dist}{len})
                            TBPs{dist}{len} = [TBPs{dist}{len}; Temp_TBPs{dist}{len}];
                        end
                    end
                end
            
                % Clear data and try a different starting point
                for dist = 1:d_tilde
                    Temp_TBPs{dist} = cell(N, 1);
                end
            end
        end
    end
end

Valid_TBPs = cell(d_tilde,1); % stores TBPs of length equal to N
for dist=1:d_tilde
    if ~isempty(TBPs{dist}{N})
        Valid_TBPs{dist} = TBPs{dist}{N};
    end
end




        
        
    
    
        
        
        
    












