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
        
        function generateAnts(self, ratio, energyTotal)
            self.ants = Ant.empty(0,0);
            
            scout_speed = 1.0;%0.36;
            scout_strength = 30;
            scout_energy_max = 150;
            scout_energy_usage = 1;
           
            worker_speed = 1.0;%0.36;
            worker_strength = 120;
            worker_energy_max = 600;
            worker_energy_usage = 4;
            
            number_of_scouts = floor(energyTotal*(1-ratio));
            number_of_workers = floor(energyTotal * (ratio));
            
            for i = 1:1:(number_of_scouts + 1)
                self.ants(int32(i)) = Ant(0, scout_energy_max, 0, self.pos, scout_speed, scout_strength, self.id, AntType.Scout, i);
            end
            
            for i = i:1:(number_of_scouts + number_of_workers)
                self.ants(i) = Ant(0, worker_energy_max, 0, self.pos, worker_speed, worker_strength, self.id, AntType.Worker, i);
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