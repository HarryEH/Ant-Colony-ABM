function [] = plot_pheromones( env )
%PLOT_PHEROMONES Summary of this function goes here
%   Detailed explanation goes here
figure; 
hold on;

ex_x = [];
ex_y = [];

food_x = [];
food_y = [];

ex_index   = 1;
food_index = 1;

for i = 1:1:env.size
    for j = 1:1:env.size
        if(env.environment(i,j).pheromone(1).level ~= 0)
            ex_x(ex_index) = i;
            ex_y(ex_index) = j;
            ex_index = ex_index + 1;
        end
        
        if(env.environment(i,j).pheromone(2).level ~= 0)
            food_x(food_index) = i;
            food_y(food_index) = j;
            food_index = food_index + 1;
        end
    end
end

% scatter(ex_x, ex_y, [], 'r.');
xlim([0 env.size])
ylim([0 env.size])
scatter(food_x, food_y, [], 'b.');


end

