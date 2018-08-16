function [ food_x, food_y, level ] = generate_food_pheromones(env)
%GENERATE_FOOD_PHEROMONES Summary of this function goes here
%   Detailed explanation goes here

    food_index = 1;
    food_x = [];
    food_y = [];
    level  = [];

    for i = 1:1:env.size
        for j = 1:1:env.size 
            if(env.environment(i,j).pheromone(2).level ~= 0)
                food_x(food_index) = i;
                food_y(food_index) = j;
                level(food_index) = env.environment(i,j).pheromone(2).level;
                food_index = food_index + 1;
            end
        end
    end

end

