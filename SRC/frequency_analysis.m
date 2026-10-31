function [GM_dB, PM, Wcg, Wcp] = frequency_analysis(G)

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('           FREQUENCY-DOMAIN ANALYSIS\n');
    fprintf('====================================================\n');

    %% Calculate Stability Margins

    [GM, PM, Wcg, Wcp] = margin(G);

    %% Convert Gain Margin to dB

    if isinf(GM)
        GM_dB = Inf;
    elseif GM > 0
        GM_dB = 20*log10(GM);
    else
        GM_dB = NaN;
    end

    %% Display Results

    fprintf('\nGain Margin        : ');

    if isinf(GM_dB)
        fprintf('Infinite\n');
    else
        fprintf('%.4f dB\n', GM_dB);
    end

    fprintf('Phase Margin       : %.4f degrees\n', PM);

    fprintf('Gain Crossover     : %.4f rad/s\n', Wcg);
fprintf('Phase Crossover    : %.4f rad/s\n', Wcp);
    %% Bode Plot

    figure('Name','Bode Plot');

    margin(G);

    grid on;

    title('Bode Plot with Stability Margins');

    %% Completion Message

    fprintf('\nFrequency-domain analysis completed successfully.\n');

end
