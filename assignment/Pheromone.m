% Pheromone class
% author - Harry Howarth
% date - 26/04/18
classdef Pheromone < handle
    properties
        level;
        type;
        decay_rate = 0;
    end
    methods     
        function p=Pheromone(varargin) 
            % Constructor for pheromone
            % author - Harry Howarth
            % date - 26/04/18

            switch nargin                  
                case 0
                    p.level = [];
                    p.type  = [];
                case 2 % create a new pheromone
                    p.level = varargin{1};% pheromone level
                    p.type  = varargin{2};% pheromone type                 
            end
        end
        
        function step(self) 
            if (self.level ~= 0)
                self.level = self.level - self.decay_rate;
            end
        end
       
    end
end