function validate_system(num, den)

    %% Validate numerator

    if isempty(num)
        error('Numerator cannot be empty.');
    end

    if ~isvector(num) || ~isnumeric(num)
        error('Numerator must be a numeric vector.');
    end

    %% Validate denominator

    if isempty(den)
        error('Denominator cannot be empty.');
    end

    if ~isvector(den) || ~isnumeric(den)
        error('Denominator must be a numeric vector.');
    end

    %% Check denominator leading coefficient

    if den(1) == 0
        error('First denominator coefficient cannot be zero.');
    end

    %% Check denominator polynomial

    if all(den == 0)
        error('Denominator cannot be zero polynomial.');
    end

    fprintf('\nSystem input validated successfully.\n');

end