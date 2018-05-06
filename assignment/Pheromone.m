% Pheromone class
% author - Harry Howarth
% date - xx/xx/18
classdef Pheromone < handle
    properties
        level;
        type;
        colony;
        decay_rate = 1;
    end
    methods     
        function p=Pheromone(varargin) 

            switch nargin                  
                case 0
                    p.level  = [];
                    p.type   = [];
                    p.colony = [];
                case 2 % create a new pheromone
                    p.level  = varargin{1};% pheromone level
                    p.type   = varargin{2};% pheromone type
                    p.colony = [];% pheromone type
            end
        end
        
        function step(self) 
            if (self.level ~= 0)
                self.level = self.level - self.decay_rate;
            elseif (isempty(self.colony))
                if max(self.colony) == 0
                  self.colony = [];
                end
            end
        end
        
        function addColony(self, id) 
            self.colony(id) = id;
        end
        
        function resetColony(self, id) 
            self.colony(id) = 0;
        end
       
    end
end