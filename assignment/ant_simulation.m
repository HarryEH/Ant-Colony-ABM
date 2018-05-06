% Example One
tic;
environment_size = 50;
colony_count = 2;
colony_ratios = [0.2, 0.8]; % scout / worker
colony_size = 25;
env = Environment(environment_size, colony_count, colony_ratios, colony_size);
toc;

disp('********************************');

tic;
simulation_length = 1000;


test = figure;

RECORD = true;

if RECORD
    v = VideoWriter('assignment/video/food_pheromones.avi', 'Motion JPEG AVI');
    open(v);
end

% Simulation
for step = 1:1:simulation_length
    
    env.step(step);
    
    if RECORD
        hold on;
        plot_food_pheromones(env);
        plot_ants_colonies(env.colonies, colony_count, colony_ratios, env.size, false);
        hold off;
        frame  = getframe( test );
        writeVideo(v,frame);
        clf;
        xlim([0 env.size]);
        ylim([0 env.size]);
    end
    
end

if RECORD
    close(v);
end

toc;

plot_ants_colonies(env.colonies, colony_count, colony_ratios, env.size, true);
plot_pheromones(env);

% Clear smelly stuff
clear environment_size colony_count colony_ratios colony_size;
