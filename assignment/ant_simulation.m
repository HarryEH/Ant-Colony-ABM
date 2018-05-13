seed = 18;
rng(seed);
% Values
environment_size = 50;
colony_count = 1;

% Percentage of energy of colony that is distributed to be worker ants
worker_percentage = [0.35];
[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1];

% Each worker/scout ant costs a varying amount of energy
% the total energy here is split by the the worker_percentage and then
% distributed to set the number of worker/scout ants in the simulation
colony_ants_energy_total = 30;

% Number of steps to run the simulation for
simulation_length  = 1000;

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
    env = Environment(environment_size, colony_count, [worker_percentage(simu)], colony_ants_energy_total);
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


fig = figure;
set(fig, 'Visible', 'on');
hold on;
cols = distinguishable_colors(11);
for i = 1:1:number_simulations
    plot(results(:,:,i),'Color',cols(i,:));
end

legend({'0% Workers', '10% Workers','20% Workers','30% Workers','40% Workers', '50% Workers',...
    '60% Workers','70% Workers','80% Workers','90% Workers', '100% Workers'}, 'Location','northwest');
title('Colony Energy vs Iteration for various percentages of Worker Ant');
xlabel('Iteration');
ylabel('Colony Energy');
% saveas(fig,'colony_energy_vs_iteration.png');


if RECORD
    close(v);
end

% Clear smelly stuff
clear environment_size colony_count colony_ratios colony_size ...
simulation_length step RECORD v frame test;
