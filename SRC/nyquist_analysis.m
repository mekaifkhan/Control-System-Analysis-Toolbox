function nyquist_analysis(G)

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                  NYQUIST ANALYSIS\n');
    fprintf('====================================================\n');

    figure('Name','Nyquist Plot');

    nyquist(G);

    grid on;

    title('Nyquist Plot');

end
