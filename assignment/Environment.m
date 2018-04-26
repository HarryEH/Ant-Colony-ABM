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
                    
                    for i = 1:1:a.colony_count
%                         Randomly place the colonies
                        a.colonies(i) = Colony([rand*1000, rand*1000],0,0,i);
                        
                        a.colonies(i).generateAnts(varargin{3}(i), varargin{4});
                    end

                    a.size=varargin{1};

                    a.environment = TerrainTile.empty(0,0);
                    for i = 1:1:a.size
                        for j = 1:1:a.size
                            a.environment(i,j) = TerrainTile(0);
                        end
                    end    
            end
        end
        
        function flag=step(obj, iter)
            flag = false;
        end
        
    end
end

