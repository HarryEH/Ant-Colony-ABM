% Example One
tic;
environment_size = 100;
colony_count = 2;
colony_ratios = [0.77, 0.33]; % scout / worker
colony_size = 20;
env = Environment(environment_size, colony_count, colony_ratios, colony_size);
clear environment_size colony_count colony_ratios colony_size;
toc;

% Example Two
tic;
environment_size = 500;
colony_count = 2;
colony_ratios = [0.75, 0.5]; % scout / worker
colony_size = 40;
env2 = Environment(environment_size, colony_count, colony_ratios, colony_size);
clear environment_size colony_count colony_ratios colony_size;
toc;

% Example Three
tic;
environment_size = 1000;
colony_count = 2;
colony_ratios = [0.8, 0.2]; % scout / worker
colony_size = 50;
env3 = Environment(environment_size, colony_count, colony_ratios, colony_size);
clear environment_size colony_count colony_ratios colony_size;
toc;

% simulation_length = 10000;
% % Simulation
% for step = 1:1:simulation_length
%     
% end
    