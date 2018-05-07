% Environment class
% author - Harry Howarth
% date - 26/04/18
classdef Environment < handle
    properties          
        size; 
        colonies;
        colony_count; 
        environment;
    end
    methods
        
        function a=Environment(varargin)% Constructor
            switch nargin                  
                case 4 % Create a new Ant
                    a.colony_count = varargin{2};
                    a.colonies = Colony.empty(0,0);
                    a.size=varargin{1};
                    
                    for i = 1:1:a.colony_count
%                       Randomly place the colonies
                        a.colonies(i) = Colony([randi([0.3*a.size,0.7*a.size],1,1), ...
                                        randi([0.3*a.size,0.7*a.size],1,1)],0,0,i);
                        
                        a.colonies(i).generateAnts(varargin{3}(i), varargin{4});
                    end

                    a.environment = TerrainTile.empty(0,0);
                    for i = 1:1:a.size
                        for j = 1:1:a.size
                            a.environment(i,j) = TerrainTile(0);
                        end
                    end 
                    
                    a.generateFood();
            end
        end
        
        function step(self, iter)
            
            if ( mod(iter, 50) == 0)
                self.generateFood();
            end
            
            for i = 1:1:length(self.colonies)
                self.colonies(i).step(self);
            end
            
            for i = 1:1:self.size
                for j = 1:1:self.size
                    self.environment(i,j).step();
                end
            end
            
        end
        
        function [flag, x, y] = checkForFood(self, pos)
            flag = false;
            x    = 0;
            y    = 0;
            
            x_corner = pos(1) - 1;
            y_corner = pos(2) - 1;
            
            for i = 0:1:2
                for j = 0:1:2
                    if ( self.withinBounds(x_corner + i, y_corner + j))
                        
                        if ( self.environment(x_corner + i, y_corner + j).food > 0 )
                            x   = x_corner + i;
                            y   = y_corner + j;
                            flag = true;
                        end
                        
                    end
                    
                end
            end
            
        end
        
        function [flag, x, y] = detectFoodPheromone(self, pos, id)
            flag = false;
            x    = [];
            y    = [];
            
            [int_x, int_y] = convert_pos(pos(1), pos(2));
            
            x_corner = int_x - 1;
            y_corner = int_y - 1;
            
            for i = 0:1:2
                for j = 0:1:2
                    if ( self.withinBounds(x_corner + i, y_corner + j))
                        
                        % assign the pheromone to a variable 
                        ph = self.environment(x_corner + i, y_corner + j) ...
                        .getPheromone(PheromoneType.Food);
                    
                        if ( ph.level > 0 && ismember(id, ph.colony) )
                            x(length(x) + 1) = x_corner + i;
                            y(length(y) + 1) = y_corner + j;
                            flag = true;
                        end
                        
                    end
                    
                end
            end
            % detect if there is food pheromone around
        end
        
        function generateFood(self)
            
            len = self.size;
            
            for i = 1:1:len
                [x,y] = bound_xy(self.size, int16(rand()*self.size), ...
                                 int16(rand()*self.size));
                
                self.environment(x,y).food = rand() * 200;
            end
            
        end
        
        function flag = withinBounds(self, x, y)
            flag =  (x > 0 && x < 51) && ...
                            ( y > 0 && y < 51);
        end
        
        
    end
end

