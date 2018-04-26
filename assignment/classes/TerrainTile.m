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
        
        function flag=updatePheromone(obj, pheromone)
            switch pheromone.type                  
                case PheromoneType.Exploratory
                    obj.pheromone(1) = pheromone;
                    flag = true;
                case PheromoneType.Food
                    obj.pheromone(2) = pheromone;
                    flag = true;
                otherwise
                    flag = false;
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