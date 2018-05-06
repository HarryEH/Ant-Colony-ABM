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
                        a.colonies(i) = Colony([rand*a.size, rand*a.size],0,0,i);
                        
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
        
        function flag = checkForFood(self, pos)
            flag = self.environment(pos(1), pos(2)).food > 0;
        end
        
        function generateFood(self)
            
            len = self.size;
            
            for i = 1:1:len
                [x,y] = bound_xy(self.size, int16(rand()*self.size), ...
                                 int16(rand()*self.size));
                
                self.environment(x,y).food = rand() * 200;
            end
            
        end
        
        
    end
end

