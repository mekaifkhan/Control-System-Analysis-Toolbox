clc;
clear;
close all;

%% CONTROL SYSTEM ANALYSIS & STABILITY TOOLBOX
% Developed by Kaif Ahmad Khan
% Project 1
%
% Purpose:
% Comprehensive analysis of continuous-time LTI control systems.

%% Add source directory
addpath('SRC');

fprintf('\n');
fprintf('====================================================\n');
fprintf('       CONTROL SYSTEM ANALYSIS TOOLBOX\n');
fprintf('====================================================\n');
fprintf('Developed by Kaif Ahmad Khan\n');
fprintf('Project 1 - Control Systems\n');
fprintf('====================================================\n\n');

%% 1. System Input

disp('Enter the transfer function coefficients.');
disp('Example: G(s) = 10 / (s^2 + 3s + 10)');
fprintf('\n');

num = input('Enter numerator coefficients: ');
den = input('Enter denominator coefficients: ');

%% 2. Validate System

validate_system(num, den);

%% 3. Create Transfer Function

G = transfer_function(num, den);

%% 4. Pole-Zero Analysis

[p, z] = pole_zero_analysis(G);

%% 5. Time-Domain Analysis

info = time_response(G);

%% 6. Stability Analysis

stability_analysis(G);
%% 7. Routh-Hurwitz Analysis

[R, sign_changes, routh_stable] = routh_hurwitz(den);


%% 8. Root Locus

root_locus_analysis(G);


%% 9. Frequency-Domain Analysis

[GM_dB, PM, Wcg, Wcp] = frequency_analysis(G);


%% 10. Nyquist Analysis

nyquist_analysis(G);


%% 11. System Health Report

system_health(G, p, info, routh_stable, sign_changes, ...
              GM_dB, PM, Wcg, Wcp);
%% 12. OPTIONAL SYSTEM COMPARISON

fprintf('\n============================================\n');
fprintf('       OPTIONAL SYSTEM COMPARISON\n');
fprintf('============================================\n');


%% 13. AUTOMATIC REPORT GENERATION

report_file = generate_report(G, num, den, p, z, info, ...
    R, sign_changes, routh_stable, GM_dB, PM, Wcg, Wcp);

fprintf('\nProfessional report saved at:\n%s\n', report_file);
%% Analysis Complete

fprintf('\n');
fprintf('====================================================\n');
fprintf('              ANALYSIS COMPLETED\n');
fprintf('====================================================\n');