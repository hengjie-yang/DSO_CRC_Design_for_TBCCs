function weight = Check_divisible_by_distance(poly_vec,error_events)

% This function computes the undetected weight for "poly_vec" based on "error_events".

weight = 0;
poly_vec = fliplr(poly_vec); % flip degree order from lowest to highest

for i = 1:size(error_events,1)
    [~, remd] = gfdeconv(error_events(i,:),poly_vec, 2);
    if remd == 0
        weight = weight + 1;
    end
end

end