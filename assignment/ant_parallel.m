%create parallel pool of workers on the local node
%Ensure that this is the same number as what you requested from the scheduler
addpath(genpath(pwd));

ex = 12;
cpu = 8;

pool = parpool('local', cpu);

environment_size   = 50;
colony_count       = 1;
% Percentage of energy of colony that is distributed to be worker ants
worker_percentage  = [0.35, 0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
% Each worker/scout ant costs a varying amount of energy
% the total energy here is split by the the worker_percentage and then
% distributed to set the number of worker/scout ants in the simulation
colony_ants_energy_total = 6000;

simulation_length  = 1500;
number_experiments = 50;

results = zeros(1,ex);
results_two = zeros(1,simulation_length, ex);

parfor simu = 1:1:ex
    
    for i = 1:1:number_experiments
        
        rng(i);
        
        tmp = zeros(1,simulation_length);
        
        env = Environment(environment_size, colony_count, worker_percentage(simu), colony_ants_energy_total);
    
        for step = 1:1:simulation_length
            env.step(step);
            tmp(step) = env.colonies(1).energy;
        end
        
        results_two(:, :, simu) = results_two(:, :, simu) + tmp;
        results(simu) = results(simu) + env.colonies(1).energy;
    end
     
end

fig = figure;
set(fig, 'Visible', 'off');
hold on;
bar((worker_percentage*100),results/number_experiments);
title('Average Colony Energy for each % of workers');
xlabel('% of Energy Distributed to Major Workers');
ylabel('Colony Energy');
saveas(fig,'results/colony_energy_vs_percentage_final_day.png');

clf;

set(fig, 'Visible', 'off');
hold on;
cols = distinguishable_colors(ex);
for i = 1:1:ex
    plot(results_two(:,:,i)/number_experiments,'Color',cols(i,:));
end

legend({'35% Workers', '0% Workers','10% Workers','20% Workers','30% Workers','40% Workers', '50% Workers',...
    '60% Workers','70% Workers','80% Workers','90% Workers','100% Workers'}, 'Location','northwest');
title('Colony Energy vs Iteration for various percentages of Energy Distributed to Major Worker Ants');
xlabel('Iteration');
ylabel('Colony Energy');
saveas(fig,'results/colony_energy_vs_iteration_final_day.png');

delete(pool)

save('results/sharc_env');
