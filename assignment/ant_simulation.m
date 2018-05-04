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
simulation_length = 1000;
% Simulation
for step = 1:1:simulation_length
    
    env.step(step);
    
end
toc;

plot_ants_colonies(env.colonies, colony_count, colony_ratios, env.size);
plot_pheromones(env);

% carrying 
for i = 1:1:length(env.colonies(1).ants)
    disp(env.colonies(1).ants(i).carrying);
end

% Clear smelly stuff
clear environment_size colony_count colony_ratios colony_size;
