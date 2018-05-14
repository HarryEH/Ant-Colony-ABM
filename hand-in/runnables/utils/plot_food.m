function [] = plot_food( env )
%PLOT_FOOD Summary of this function goes here
%   Detailed explanation goes here

food_x = [];
food_y = [];

food_index = 1;

for i = 1:1:env.size
    for j = 1:1:env.size
        if(env.environment(i,j).food ~= 0)
            food_x(food_index) = i;
            food_y(food_index) = j;
            food_index = food_index + 1;
        end
    end
end

scatter(food_x, food_y, [], 'dk');
legend('food')

end

