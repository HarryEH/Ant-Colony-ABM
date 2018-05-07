function [] = plot_food_pheromones( env )
%PLOT_FOOD_PHEROMONES Summary of this function goes here
%   Detailed explanation goes here

[food_x, food_y] = generate_food_pheromones(env);

scatter(food_x, food_y, [], 'b.');
legend('food pheromones')

xlim([0 env.size]);
ylim([0 env.size]);

end

