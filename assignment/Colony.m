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
            scouts = double(int16(size * (1-ratio)));
            self.ants = Ant.empty(0,0);
            for i = 1:1:scouts
                self.ants(i) = ScoutAnt(self.pos, self.id);
            end
            
            workers = double(int16(size * ratio));
                        
            for i = scouts:1:workers
                self.ants(i) = WorkerAnt(self.pos, self.id);
            end
            
        end
            
       
    end
end