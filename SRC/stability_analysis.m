function stability_analysis(G)

    p = pole(G);

    fprintf('\n');
    fprintf('====================================================\n');
    fprintf('                 STABILITY ANALYSIS\n');
    fprintf('====================================================\n');

    fprintf('\nSystem Poles:\n');
    disp(p);

    %% Stability condition

    if all(real(p) < 0)

        fprintf('\nStability Status : STABLE\n');
        fprintf('All poles lie in the Left Half of the s-plane.\n');

    elseif any(real(p) > 0)

        fprintf('\nStability Status : UNSTABLE\n');
        fprintf('At least one pole lies in the Right Half of the s-plane.\n');

    else

        fprintf('\nStability Status : MARGINALLY STABLE / SPECIAL CASE\n');
        fprintf('One or more poles lie on the imaginary axis.\n');

    end

end