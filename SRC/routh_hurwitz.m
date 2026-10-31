function [R, sign_changes, stable] = routh_hurwitz(coeff)

    % =========================================================
    % ROBUST ROUTH-HURWITZ STABILITY ANALYSIS
    % =========================================================

    tol = 1e-10;

    coeff = coeff(:).';

    % Remove leading zeros
    first_nonzero = find(abs(coeff) > tol, 1);

    if isempty(first_nonzero)
        error('Characteristic polynomial cannot be zero.');
    end

    coeff = coeff(first_nonzero:end);

    n = length(coeff);
    cols = ceil(n/2);

    R = zeros(n, cols);

    % ---------------------------------------------------------
    % First two rows
    % ---------------------------------------------------------

    first_row = coeff(1:2:end);
    second_row = coeff(2:2:end);

    R(1,1:length(first_row)) = first_row;
    R(2,1:length(second_row)) = second_row;

    % ---------------------------------------------------------
    % Construct Routh table
    % ---------------------------------------------------------

    for i = 3:n

        % Case: first element is zero
        if abs(R(i-1,1)) < tol

            R(i-1,1) = tol;

            fprintf('\nZero encountered in first column.');
            fprintf('\nUsing epsilon = %.2e\n', tol);

        end

        for j = 1:cols-1

            R(i,j) = ...
                ((R(i-1,1) * R(i-2,j+1)) - ...
                 (R(i-2,1) * R(i-1,j+1))) ...
                 / R(i-1,1);

        end

        % -----------------------------------------------------
        % Entire row zero
        % -----------------------------------------------------

        if all(abs(R(i,:)) < tol)

            fprintf('\nEntire row of zeros detected.');
            fprintf('\nAuxiliary polynomial required.\n');

            % Row above is used to generate auxiliary polynomial
            auxiliary = R(i-1,:);

            power = n - (i-2)*2;

            derivative = zeros(size(auxiliary));

            for k = 1:length(auxiliary)-1

                derivative(k) = ...
                    auxiliary(k) * (power - 2*(k-1));

            end

            R(i,:) = derivative;

        end

    end

    % ---------------------------------------------------------
    % Display Routh table
    % ---------------------------------------------------------

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('              ROUTH-HURWITZ ANALYSIS\n');
    fprintf('====================================================\n');

    fprintf('\nRouth Table:\n\n');
    disp(R);

    % ---------------------------------------------------------
    % First column
    % ---------------------------------------------------------

    first_column = R(:,1);

    fprintf('First Column:\n');
    disp(first_column);

    % ---------------------------------------------------------
    % Count sign changes
    % ---------------------------------------------------------

    signs = sign(first_column);

    % Remove numerical zeros
    signs(abs(first_column) < tol) = 0;

    % Replace zero signs using previous non-zero sign
    for i = 2:length(signs)

        if signs(i) == 0
            signs(i) = signs(i-1);
        end

    end

    sign_changes = sum(signs(2:end) .* signs(1:end-1) < 0);

    fprintf('Number of sign changes : %d\n', sign_changes);

    % ---------------------------------------------------------
    % Stability conclusion
    % ---------------------------------------------------------

    stable = (sign_changes == 0);

    fprintf('\n');

    if stable

        fprintf('Routh Criterion : STABLE\n');

    else

        fprintf('Routh Criterion : UNSTABLE\n');
        fprintf('Right-half-plane poles : %d\n', sign_changes);

    end

    fprintf('====================================================\n');

end