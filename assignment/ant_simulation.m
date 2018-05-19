addpath(genpath(pwd));% Make sure everything is on the path.
% Not an issue for us because of our startup.m that I gave you all but
% for the hand-in.

seed = 2;
rng(seed);

environment_size = 50;% number of tiles. this is squared.
colony_count = 1;% Number of colonies in the environment

% Percentage of energy of colony that is distributed to be worker ants
worker_percentage = [0.32];

% Each worker/scout ant costs a varying amount of energy
% the total energy here is split by the the worker_percentage and then
% distributed to set the number of worker/scout ants in the simulation
colony_ants_energy_total = 30;

% Number of steps to run the simulation for
simulation_length  = 1200;

number_simulations = 1;

RECORD = number_simulations == 1 && true;

if RECORD
    test = figure;
    set(test, 'Visible', 'on');
    v = VideoWriter('assignment/video/food_pheromones.avi', 'Motion JPEG AVI');
    open(v);
end

results = zeros(1,simulation_length, number_simulations);

for simu = 1:1:number_simulations
    
    % Simulation setup 
    tic;
    env = Environment(environment_size, colony_count, worker_percentage(simu), colony_ants_energy_total);
    toc;
    
    disp('********************************');
    
    tic;
    
    for step = 1:1:simulation_length

        env.step(step);
        
        results(1, step, simu) = env.colonies(1).energy;

        if RECORD
            hold on;
            plot_food(env);
            plot_food_pheromones(env);
            plot_ants_colonies(env.colonies, colony_count, worker_percentage(simu), env.size, false);
            hold off;
            frame  = getframe( test );
            writeVideo(v,frame);
            clf;
            xlim([0 env.size]);
            ylim([0 env.size]);
        end

    end
    
    toc;
end

if RECORD
    close(v);
end

% Clear smelly stuff
clear environment_size colony_count colony_ratios colony_size ...
simulation_length step RECORD v frame test;
