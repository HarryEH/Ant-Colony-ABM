% TerrainTile class
% author - Harry Howarth
% date - 26/04/18
classdef TerrainTile < handle
    properties          
        food; 
        pheromone;
    end
    methods     
        function t=TerrainTile(varargin) % Constructor
            switch nargin                  
                case 0
                    t.food      = []; 
                    t.pheromone = [];
                case 1 % create a new TerrainTile (currently the only constructor method used)
                    t.food      = varargin{1};% food in the tile
                    t.pheromone = [Pheromone(0, PheromoneType.Exploratory), Pheromone(0, PheromoneType.Food)];% pheromone in the tile
            end
        end
        
        function step(self)
            for i = 1:1:length(self.pheromone)
                self.pheromone(i).step();
            end
            
        end
        
        function updatePheromone(self, pheromone, id)
            switch pheromone.type                  
                case PheromoneType.Exploratory
                    self.pheromone(1).level = self.pheromone(1).level + pheromone.level;
                    self.pheromone(1).addColony(id);
                case PheromoneType.Food
                    self.pheromone(2).level = self.pheromone(2).level + pheromone.level;
                    self.pheromone(2).addColony(id);
                    
                    if (self.pheromone(2).level > 35) 
                       self.pheromone(2).level = 35; 
                    end
            end
        end
        
        
        function pheromone=getPheromone(self, enum)
            switch enum                  
                case PheromoneType.Exploratory
                    pheromone = self.pheromone(1);
                case PheromoneType.Food
                    pheromone = self.pheromone(2);
            end
        end
       
    end
end