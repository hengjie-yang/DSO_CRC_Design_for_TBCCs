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