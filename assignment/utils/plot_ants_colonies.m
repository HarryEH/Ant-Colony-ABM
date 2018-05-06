function [  ] = plot_ants_colonies( colonies, colony_size, colony_ratios, size, newFig )
%PLOT_ANTS_COLONIES Summary of this function goes here
%   Detailed explanation goes here
    %colonies
    % plot
if newFig
    figure;
    hold on;
end
colonies_x = [];
colonies_y = [];

c = ['r', 'b'];

for i = 1:1:length(colonies)
    
    colonies_x(i) = colonies(i).pos(1);
    colonies_y(i) = colonies(i).pos(2);

    % split the plot into workers and scouts
    scout_x  = [];
    scout_y  = [];
    worker_x = [];
    worker_y = [];
    
    worker_index = 1;
    scout_index  = 1;
    
    for j = 1:1:length(colonies(i).ants)
        if (~isempty(colonies(i).ants(j).pos))  
            switch(colonies(i).ants(j).type)
                case AntType.Scout
                    scout_x(scout_index) = colonies(i).ants(j).pos(1);
                    scout_y(scout_index) = colonies(i).ants(j).pos(2);
                    scout_index = scout_index + 1;
                case AntType.Worker
                    worker_x(worker_index) = colonies(i).ants(j).pos(1);
                    worker_y(worker_index) = colonies(i).ants(j).pos(2);
                    worker_index = worker_index + 1;
            end   
        end
    end
        
    xlim([0 size])
    ylim([0 size])
    scatter(scout_x, scout_y, [], c(i), 'x');
    scatter(worker_x, worker_y, [], c(i), 'o');
end

scatter(colonies_x, colonies_y, [], 'c*');

end

