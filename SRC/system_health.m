function system_health(G, p, info, routh_stable, sign_changes, ...
                       GM_dB, PM, Wcg, Wcp)

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                 SYSTEM HEALTH REPORT\n');
    fprintf('====================================================\n');

    %% ====================================================
    % 1. POLE-BASED STABILITY
    % =====================================================

    if all(real(p) < 0)

        pole_status = "STABLE";

    elseif any(real(p) > 0)

        pole_status = "UNSTABLE";

    else

        pole_status = "MARGINALLY STABLE";

    end

    fprintf('\nSTABILITY ANALYSIS\n');
    fprintf('----------------------------------------------------\n');

    fprintf('Pole-Based Stability : %s\n', pole_status);

    if routh_stable
        fprintf('Routh-Hurwitz        : STABLE\n');
    else
        fprintf('Routh-Hurwitz        : UNSTABLE\n');
    end

    fprintf('RHP Pole Count       : %d\n', sign_changes);


    %% ====================================================
    % 2. TIME DOMAIN
    % ====================================================

    fprintf('\n');
    fprintf('TIME-DOMAIN PERFORMANCE\n');
    fprintf('----------------------------------------------------\n');

    fprintf('Rise Time            : %.4f s\n', info.RiseTime);
    fprintf('Settling Time        : %.4f s\n', info.SettlingTime);
    fprintf('Peak Time            : %.4f s\n', info.PeakTime);
    fprintf('Overshoot            : %.2f %%\n', info.Overshoot);
    fprintf('Peak Value           : %.4f\n', info.Peak);


    %% ====================================================
    % 3. FREQUENCY DOMAIN
    % ====================================================

    fprintf('\n');
    fprintf('FREQUENCY-DOMAIN PERFORMANCE\n');
    fprintf('----------------------------------------------------\n');

    if isinf(GM_dB)
        fprintf('Gain Margin          : Infinite\n');
    else
        fprintf('Gain Margin          : %.4f dB\n', GM_dB);
    end

    fprintf('Phase Margin         : %.4f degrees\n', PM);
    fprintf('Gain Crossover       : %.4f rad/s\n', Wcg);
fprintf('Phase Crossover      : %.4f rad/s\n', Wcp);

    %% ====================================================
    % 4. DOMINANT POLE
    % ====================================================

    fprintf('\n');
    fprintf('POLE CHARACTERISTICS\n');
    fprintf('----------------------------------------------------\n');

    [~, index] = max(real(p));

    dominant_pole = p(index);

    fprintf('Dominant Pole        : %.4f %+ .4fj\n', ...
        real(dominant_pole), imag(dominant_pole));


    %% ====================================================
    % 5. ENGINEERING INTERPRETATION
    % ====================================================

    fprintf('\n');
    fprintf('ENGINEERING INTERPRETATION\n');
    fprintf('----------------------------------------------------\n');

    if pole_status == "STABLE"

        fprintf('✓ All system poles are located in the left-half s-plane.\n');
        fprintf('✓ Pole-based analysis indicates asymptotic stability.\n');

    elseif pole_status == "UNSTABLE"

        fprintf('✗ At least one pole lies in the right-half s-plane.\n');
        fprintf('✗ The system is unstable.\n');

    else

        fprintf('! One or more poles lie on the imaginary axis.\n');
        fprintf('! Further stability analysis is required.\n');

    end


    %% Phase Margin Interpretation

    if PM > 0

        fprintf('✓ Phase margin is positive.\n');

    elseif PM < 0

        fprintf('✗ Phase margin is negative.\n');

    else

        fprintf('! Phase margin is approximately zero.\n');

    end


    %% Overshoot Interpretation

    if info.Overshoot < 10

        fprintf('✓ Low transient overshoot observed.\n');

    elseif info.Overshoot < 25

        fprintf('• Moderate transient overshoot observed.\n');

    else

        fprintf('! High transient overshoot observed.\n');

    end


    %% ====================================================
    % 6. FINAL STATUS
    % ====================================================

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                    FINAL STATUS\n');
    fprintf('====================================================\n');

    if pole_status == "STABLE" && routh_stable && PM > 0

        fprintf('OVERALL SYSTEM STATUS : STABLE\n');

    elseif pole_status == "UNSTABLE" || ~routh_stable || PM < 0

        fprintf('OVERALL SYSTEM STATUS : UNSTABLE / REQUIRES DESIGN\n');

    else

        fprintf('OVERALL SYSTEM STATUS : REQUIRES FURTHER ANALYSIS\n');

    end

    fprintf('====================================================\n');

end