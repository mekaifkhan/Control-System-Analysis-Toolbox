function root_locus_analysis(G)

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                  ROOT LOCUS ANALYSIS\n');
    fprintf('====================================================\n');

    figure('Name','Root Locus');

    rlocus(G);

    grid on;

    title('Root Locus');
    xlabel('Real Axis');
    ylabel('Imaginary Axis');

end