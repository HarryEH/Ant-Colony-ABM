addpath(genpath(pwd));% Make sure everything is on the path.
% Not an issue for us because of our startup.m that I gave you all but
% for the hand-in.

% Set the seed for repeatability.
seed = 2;
rng(seed);

environment_size = 50;% number of tiles. this is squared.
colony_count = 1;% Number of colonies in the environment

% Percentage of energy of colony that is distributed to be worker ants
worker_percentage = 0.5;

% Each worker/scout ant costs a varying amount of energy
% the total energy here is split by the the worker_percentage and then
% distributed to set the number of worker/scout ants in the simulation
colony_ants_total = 30;

% Number of steps to run the simulation for
simulation_length  = 1200;

% Simulation setup 
tic;
env = Environment(environment_size, colony_count, [worker_percentage], colony_ants_total);
toc;

tic;
for step = 1:1:simulation_length
    env.step(step);
end
toc;
    
disp('*************************');
disp('**Colony Energy**********');
disp(env.colonies(1).energy);
disp('*************************');

% Clear vars
clear environment_size colony_count colony_ratios colony_size ...
simulation_length step RECORD v frame test;
