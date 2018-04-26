% WorkerAnt class
% author - Harry Howarth
% date - 26/04/18
classdef WorkerAnt < Ant
    properties          
        type;
    end
    methods
        function obj = WorkerAnt(pos, colony)% Constructor   
            obj = obj@Ant(0,100,0,pos,30,100,colony);
            obj.type = "Worker";
        end   
    end
end