% ScoutAnt class
% author - Harry Howarth
% date - 26/04/18
classdef ScoutAnt < Ant
    properties          
        type;
    end
    methods
        function obj=ScoutAnt(pos, colony)% Constructor   
            obj = obj@Ant(0,100,0,pos,100,30,colony);
            obj.type = "Scout";
        end
       
    end
end