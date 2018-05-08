%create parallel pool of workers on the local node
%Ensure that this is the same number as what you requested from the scheduler
addpath(genpath(pwd));

cpu = 11;

pool = parpool('local',cpu);

environment_size   = 50;
colony_count       = 1;
worker_percentage  = [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];
colony_size        = 20;
simulation_length  = 1000;

number_experiments = 100;

results = zeros(1,cpu);
results_two = zeros(1,simulation_length, cpu);

parfor simu = 1:1:cpu
    
    for i = 1:1:number_experiments
        
        rng(i);
        
        env = Environment(environment_size, colony_count, worker_percentage(simu), colony_size);
    
        for step = 1:1:simulation_length
            env.step(step);
            results_two(1, step, simu) = results_two(1, step, simu) + env.colonies(1).energy;
        end
        
        results(simu) = results(simu) + env.colonies(1).energy;
    end
     
end

fig = figure;
set(fig, 'Visible', 'off');
hold on;
bar((worker_percentage*100),results/number_experiments);
title('Average Colony Energy for each % of workers');
xlabel('% of workers');
ylabel('Colony Energy');
saveas(fig,'results/colony_energy_vs_percentage.png');

clf;

set(fig, 'Visible', 'off');
hold on;
cols = distinguishable_colors(11);
for i = 1:1:11
    plot(results_two(:,:,i)/number_experiments,'Color',cols(i,:));
end

legend({'0% Workers', '10% Workers','20% Workers','30% Workers','40% Workers', '50% Workers',...
    '60% Workers','70% Workers','80% Workers','90% Workers', '100% Workers'}, 'Location','northwest');
title('Colony Energy vs Iteration for various percentages of Worker Ant');
xlabel('Iteration');
ylabel('Colony Energy');
saveas(fig,'results/colony_energy_vs_iteration.png');


delete(pool)

save('results/sharc_env');
