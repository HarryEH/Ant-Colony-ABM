% Ant class
% author - Harry Howarth
% date - 26/04/18
classdef Ant < handle
    properties          
        age; 
        energy;
        carrying; 
        pos;
        speed; 
        strength;
        colony;
    end
    methods
        function a=Ant(varargin)% Constructor
            switch nargin                  
                case 0
                    a.age      = []; 
                    a.energy   = [];
                    a.carrying = [];
                    a.pos      = [];
                    a.speed    = [];
                    a.colony   = [];
                case 7 % Create a new Ant
                    a.age      = varargin{1};% Age of Ant
                    a.energy   = varargin{2};% Current energy 
                    a.carrying = varargin{3};% Current amount of food that you're carrying
                    a.pos      = varargin{4};% Current position
                    a.speed    = varargin{5};% Current speed
                    a.strength = varargin{6};% Strength of the ant
                    a.colony   = varargin{7};% Colony that the any belongs to 
            end
        end
       
    end
end