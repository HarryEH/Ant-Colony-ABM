% Pheromone class
% author - Harry Howarth
% date - xx/xx/18
classdef Pheromone < handle
    properties
        level;
        type;
        colony;
        decay_rate = 1;
        ants;
        number_ants = 500;% MAGIC NUMBER ALERT
    end
    methods     
        function p=Pheromone(varargin) 

            switch nargin                  
                case 0
                    p.level  = [];
                    p.type   = [];
                    p.colony = [];
                    p.ants   = [];
                    
                case 2 % create a new pheromone
                    p.level  = varargin{1};% pheromone level
                    p.type   = varargin{2};% pheromone type
                    p.colony = [];% pheromone type
                    p.ants   = zeros(1,p.number_ants);
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
            
            if (self.level == 0 && max(self.ants) ~= 0) 
                self.ants = zeros(1,self.number_ants);
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