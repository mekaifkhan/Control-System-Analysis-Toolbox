function system_assessment(G, p, info)

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('              OVERALL SYSTEM ASSESSMENT\n');
    fprintf('====================================================\n');

    %% Stability

    if all(real(p) < 0)

        stability = "STABLE";

    elseif any(real(p) > 0)

        stability = "UNSTABLE";

    else

        stability = "MARGINALLY STABLE";

    end

    fprintf('\nStability Status : %s\n', stability);

    %% Dominant pole

    [~, index] = max(real(p));

    dominant_pole = p(index);

    fprintf('Dominant Pole    : %.4f + %.4fj\n', ...
        real(dominant_pole), imag(dominant_pole));

    %% Settling time

    fprintf('Settling Time    : %.4f s\n', info.SettlingTime);

    %% Overshoot

    fprintf('Overshoot        : %.2f %%\n', info.Overshoot);

    fprintf('\n');

    if stability == "STABLE"

        fprintf('Engineering Interpretation:\n');
        fprintf(['The system poles lie in the left-half s-plane, ' ...
                 'indicating asymptotic stability.\n']);

    elseif stability == "UNSTABLE"

        fprintf('Engineering Interpretation:\n');
        fprintf(['At least one pole lies in the right-half s-plane. ' ...
                 'The system is unstable.\n']);

    else

        fprintf('Engineering Interpretation:\n');
        fprintf(['The system contains poles on the imaginary axis ' ...
                 'and requires further stability analysis.\n']);

    end

end