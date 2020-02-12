function [IEE_list, IEE_lengths] = Collect_Irreducible_Error_Events(constraint_length, code_generator, d_tilde, V)

% 
%   The collection algorithm collects all irreducible error events (IEEs)
%   on the trellis of a rate-1/n tail-biting convolutional code (TBCC).
%   
%   Inputs:
%       1) constraint_length: a scalar indicating the constraint length of
%       TBCC
%       2) code_generator: a matrix specifying the generator of TBCC
%       3) d_tilde: the distance threshold
%       4) V: the predetermined ordering of states. The default ordering is
%       the natural ordering. The index starts from 1.
%
%   Outputs:
%       1) IEE_list: a 2^v*1 cell, with the i-th cell representing the
%       list of input sequence whose IEE is of distance 'i'.
%       2) IEE_lengths: a 2^v*1 cell of vectors, with the i-th vector
%       representing the list of lengths of the i-th matrix in IEE_list
%
%

%   Copyright 2020 Hengjie Yang



% Build the tail-biting trellis
trellis = poly2trellis(constraint_length, code_generator);
NumStates = trellis.numStates;
NumInputs = trellis.numInputSymbols; % for rate-1/n, NumInputs = 2
MaxLen = 100;

if nargin > 3
    V = 1:NumStates; % state indices start from 1

IEE_list = cell(NumStates, 1);
IEE_lengths = cell(NumStates, 1);



%Initialize some important parameters
State_Init = fliplr(dec2bin(0:2^(NumStates)-1) - '0');
inv_V = zeros(1, size(V,2));
for i = 1: NumStates
    inv_V(V(i)) = i;
end

for iter = 1:NumStates
        IEE_list{iter}=cell(d_tilde,1);
        IEE_lengths{iter}=cell(d_tilde,1);
end


% Viterbi search at each starting state
for iter = 1:NumStates
    start_state = V(iter); % determine the start state
    Column{0} = cell(NumStates, 1);
    Column{1} = cell(NumStates, 1);
    for depth = 0:MaxLen    % start a Viterbi search
        if depth == 0
            for input = 1:NumInputs
                next_state = trellis.nextStates(start_state, input) + 1;
                if inv_V(next_state) >= iter % check if the state has been traversed in V
                    if isempty(Column{mod(iteration+1, 2)+1}{next_state})
                        Column{mod(iteration+1, 2)+1}{next_state}=cell(d_tilde, 1);%initialization
                    end
                    weight=sum(dec2bin(oct2dec(trellis.outputs(start_state, input)))-'0');
                    Column{mod(iteration+1,2)+1}{next_state}{weight}=[Column{mod(iteration+1,2)+1}{next_state}{weight};input-1]; 
                    % we use the assumption that NumInputs=2
                end
            end
        else
            for cur_state=1:NumStates
                if ~isempty(Column{mod(iteration,2)+1}{cur_state})
                    if cur_state == start_state % meet the error event condition, stop extending
                        for dist = 1:d_tilde
                            [row_dim, col_dim] = size(IEE_list{start_state}{dist});
                            [row, col] = Column{mod(iteration,2)+1}{cur_state}{dist};
                            
                    
            
            
        
        











