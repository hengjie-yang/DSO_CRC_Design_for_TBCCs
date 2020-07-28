%
% This script aims at studying how the number of TB codewords of distance i
% (and of length <=74) grows with i.
%
% Here, we take [133, 171] as an example.
%

set(0,'DefaultTextFontName','Times','DefaultTextFontSize',14,...
    'DefaultAxesFontName','Times','DefaultAxesFontSize',14,...
    'DefaultLineLineWidth',1,'DefaultLineMarkerSize',7.75);
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');


d = 22;
Dists = 1:d;
Num_codewords = zeros(1,size(d,2)); 
% the i-th entry stores the number of TB codewords of distance equal to i.

polys = [];
trellis = poly2trellis(7, [133, 171]);
NumStates = trellis.numStates;
T = zeros(NumStates, NumStates);
T = sym(T);
syms X;


% Step 1: compute the one-step transfer function
disp('Step 1: Compute the one-step transfer function.');
for cur_state = 1:NumStates
    for input = 1:2
        next_state = trellis.nextStates(cur_state,input) + 1;
        output_weight = sum(dec2bin(oct2dec(trellis.outputs(cur_state, input)))-'0');     
        output_symbol = convert_to_symbol(output_weight);
        T(cur_state, next_state) = output_symbol;
    end
end

% Step 2: Compute the weight enumerating function for all finite-length
% TBCCs
disp('Step 2: compute the weight enumerating function for each starting state.');
B = eye(NumStates);
B = sym(B);

N = length(Ns);
total = 0;
for iter = 1:N
    disp(['Current depths: ',num2str(iter)]);
    B = B*T;
    B = expand(B);
    polys = diag(B);
    Poly = sum(polys); % weight enumrating function of length 'iter'
    weight_spectrum = coeffs(Poly,'All');
    weight_spectrum = fliplr(weight_spectrum);
    weight_spectrum = double(weight_spectrum);
    d_max = min(d, length(weight_spectrum));
    if d_max < d
        weight_spectrum = [weight_spectrum, zeros(1, d-d_max)];
    else
        weight_spectrum = weight_spectrum(1:d);
    end
    Num_codewords = Num_codewords + weight_spectrum;
end



semilogy(Dists(1:2:end), Num_codewords(1:2:end), '-*');
grid on
xlabel('$d$','interpreter','latex');
ylabel('Number of TB codewords','interpreter','latex');

saveas(gcf,'plot_num_codewords_TBCC_133_171_d_22_N_74_v2');





function chr = convert_to_symbol(weight)

chr = 0; %invalid string
syms X

if weight == 0
    chr = 1;
elseif weight == 1
    chr = X;
elseif weight == 2
    chr = X^2;
end
end

