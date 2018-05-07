%create parallel pool of workers on the local node
%Ensure that this is the same number as what you requested from the scheduler

cpu = 8;

pool = parpool('local',cpu);

environment_size   = 50;
colony_count       = 1;
worker_percentage  = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8];
colony_size        = 20;
simulation_length  = 1000;

number_experiments = 100;

results = zeros(1,cpu);

parfor simu = 1:1:cpu
    
    for i = 1:1:100
        env = Environment(environment_size, colony_count, worker_percentage(simu), colony_size);
    
        for step = 1:1:simulation_length
            env.step(step);
        end
        results(simu) = (results(simu) + env.colonies(1).energy) / i;
    end
     
end

fig = figure;
set(fig, 'Visible', 'off');
hold on;
bar((worker_percentage*100),results);
title('Average Colony Energy for each % of workers');
xlabel('% of workers');
ylabel('Colony Energy');
saveas(fig,'colony_energy_vs_percentage.png');

delete(pool)
