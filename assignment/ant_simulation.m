% Example One
tic;
environment_size = 50;
colony_count = 1;
colony_ratios = [0.5]; % scout / worker
colony_size = 30;
env = Environment(environment_size, colony_count, colony_ratios, colony_size);
toc;

disp('********************************');

tic;
simulation_length = 300;
% Simulation
for step = 1:1:simulation_length
    
    env.step();
    
end
toc;

plot_ants_colonies(env.colonies, colony_count, colony_ratios);
plot_pheromones(env);

% Clear smelly stuff
clear environment_size colony_count colony_ratios colony_size;
