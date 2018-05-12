% TerrainTile class
% author - Harry Howarth
% date - 26/04/18
classdef Colony < handle
    properties          
        pos;
        ants;
        id;
        energy;
    end
    methods     
        function c=Colony(varargin)
            switch nargin                  
                case 0
                    c.pos    = [];
                    c.ants   = [];
                    c.energy = [];
                    c.id     = [];
                case 4 % create a new colony
                    c.pos    = varargin{1};% position of the colony
                    c.ants   = varargin{2};% anty anty ants
                    c.energy = varargin{3};% energy level of the colony
                    c.id     = varargin{4};% id of the colony
                otherwise
                    error('Invalid no. of input arguments for colony')
            end
        end
        
        function generateAnts(self, ratio, size)
            scouts = int32(size * (1-ratio));
            self.ants = Ant.empty(0,0);
            
            ant_lifespan = 150;
            
            scout_speed = 0.36;
            scout_strength = 30;
           
            worker_speed = 0.36;
            worker_strength = 120;
            
            for i = 1:1:scouts
                self.ants(int32(i)) = Ant(0, ant_lifespan, 0, self.pos, scout_speed, scout_strength, self.id, AntType.Scout, i);
            end
            
            if scouts == 0
                scouts = 1;
            end
            
            for i = scouts:1:size
                self.ants(i) = Ant(0, ant_lifespan, 0, self.pos, worker_speed, worker_strength, self.id, AntType.Worker, i);
            end
            
        end
        
        function step(self, env)
            
            for i = 1:1:length(self.ants)
                self.ants(i).step(env);
                
                % check to see if we need to kill ants 
                if(self.ants(i).energy == 0)
                    self.ants(i) = Ant();
                end
            end
            
        end
            
       
    end
end