function [p, z] = pole_zero_analysis(G)

    %% Calculate poles and zeros

    p = pole(G);
    z = zero(G);

    %% Display results

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                POLE-ZERO ANALYSIS\n');
    fprintf('====================================================\n');

    fprintf('\nPoles:\n');
    disp(p);

    fprintf('Zeros:\n');

    if isempty(z)
        fprintf('No finite zeros.\n');
    else
        disp(z);
    end

    %% Pole-Zero Map

    figure('Name','Pole-Zero Map');

    pzmap(G);
    grid on;

    title('Pole-Zero Map');
    xlabel('Real Axis');
    ylabel('Imaginary Axis');

end