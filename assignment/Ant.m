% Ant class
% author - Harry Howarth
% date - 26/04/18
classdef Ant < handle
    properties
        id;
        age; 
        energy;
        carrying; 
        pos;
        speed; 
        strength;
        colony;
        type;
        pheromone_span = 25;
        worry;
    end
    methods
        function a=Ant(varargin)% Constructor
            switch nargin                  
                case 0
                    a.age      = []; a.energy   = [];
                    a.carrying = []; a.pos      = [];
                    a.speed    = []; a.colony   = [];
                    a.type     = []; a.strength = [];
                    a.id       = [];
                case 9 % Create a new Ant
                    a.age      = varargin{1};% Age of Ant
                    a.energy   = varargin{2};% Current energy 
                    a.worry    = a.energy/ 2;% When ant cares about its health
                    a.carrying = varargin{3};% Current amount of food that you're carrying
                    a.pos      = varargin{4};% Current position
                    a.speed    = varargin{5};% Current speed
                    a.strength = varargin{6};% Strength of the ant
                    a.colony   = varargin{7};% Colony that the any belongs to 
                    a.type     = varargin{8};% type
                    a.id       = varargin{9};% type
            end
        end
        
        function step(self, env)
            if (isempty(self.pos))
                return;
            end
            
            self.ageStep();
            
            self.energyStep();
            
            self.findFood(env);
            
            self.colonyActions(env);
            
            self.layPheromones(env);
            
            self.moveStep(env.size, env.colonies(self.colony).pos, env);
            
        end
        
        function ageStep(self)
            self.age = self.age + 1;
        end
        
        function moveStep(self, size, colony_pos, env)
            if (self.carrying == 0)
                if self.energy < self.worry 
                    self.moveToColony(size, colony_pos);
                else
                    [flag, x, y] = env.detectFoodPheromone(self.pos, self.colony);
                    
                    if (flag)
                        self.followFood(size, colony_pos, x, y, env);
                    else
                        self.randomMove(size, colony_pos);
                    end
                    
                end
            else
                self.moveToColony(size, colony_pos);
            end  
        end
        
        function randomMove(self, size, colony_pos)
            if (self.age < 5)
                theta = rand() * 2*pi;
%             elseif (self.age < 15)
%                 mid = theta_between_points(self.pos(1), self.pos(2), ...
%                     colony_pos(1), colony_pos(2));
%                 
%                 lower = (-mid) - (pi/2);
%                 
%                 if (lower < 0)
%                     lower = (2*pi) + lower;
%                 end
%                 
%                 upper = (-mid) + (pi/2);
%                 
%                 if (upper > (2*pi))
%                     upper = upper - (2*pi);
%                 end
%                 
%                 theta = (rand*(upper-lower)) + lower;
            else
                theta = rand() * 2*pi;
            end
            
            self.doMove(theta, size);
        end
        
        function moveToColony(self, size, pos)
                        
            theta = theta_between_points( self.pos(1), self.pos(2), ...
                                          pos(1), pos(2));
  
            self.doMove(theta, size);

        end
        
        function followFood(self, size, colony_pos, x , y, env)
            % follow the food trail, likely have to move away from the
            % colony
            if length(x) ~= 1
                
                xs = [];
                ys = [];
                thetas = [];
                
                for i = 1:1:length(x)
                    if ( ~self.hasAntVisitedPheromone(env, x(i), y(i)) )
                        theta = theta_between_points( self.pos(1), self.pos(2),...
                                              x(i), y(i));
                        thetas(length(thetas)+1) = theta;
                        xs(length(xs)+1) = x(i);
                        ys(length(ys)+1) = y(i);
                    end
                end
                
                if (~isempty(thetas))
                    index = randi([1, length(thetas)],1,1);
                    env.environment(xs(index),ys(index)).pheromone(2) ...
                                            .ants(self.id) = self.id;
                    self.doMove(thetas(index), size);
                else
                    self.randomMove(size, colony_pos);
                end
   
            else  
               
                theta = theta_between_points( self.pos(1), self.pos(2),...
                                              x, y);
                if self.hasAntVisitedPheromone(env, x, y)
                    self.randomMove(size, colony_pos);
                else
                    env.environment(x,y).pheromone(2) ...
                                                .ants(self.id) = self.id;
                    self.doMove(theta, size);
                end
                  
            end
            
        end
        
        function doMove(self, theta, size)
            x = self.pos(1) + (self.speed * sin(theta));
            y = self.pos(2) + (self.speed * cos(theta));
            
            [x1, y1] = bound_xy(size, x, y);
            self.pos = [x1, y1];
        end
        
        function findFood(self, env)
            [x1, y1] = convert_pos(self.pos(1), self.pos(2));
            
            if(self.carrying == 0)
                [flag, x, y] = env.checkForFood([x1,y1]);
                if (flag)
                    if (env.environment(x,y).food < self.strength)
                        self.carrying = env.environment(x,y).food;
                        env.environment(x,y).food = 0;
                    else
                        self.carrying = self.strength;
                        env.environment(x,y).food = env.environment(x,y).food - self.strength;
                    end
                end
            end
        end
        
        function colonyActions(self, env)
            % Colony position
            [c_x, c_y] = convert_pos(env.colonies(self.colony).pos(1), ...
                                         env.colonies(self.colony).pos(2));
            % Ant position                         
            [ant_x, ant_y] = convert_pos(self.pos(1), self.pos(2));
            if ( c_x == ant_x && c_y == ant_y )
                % dump food in the colony
                env.colonies(self.colony).energy = ...
                        env.colonies(self.colony).energy + self.carrying;
                self.carrying = 0;
                if (env.colonies(self.colony).energy > self.worry * 2)
                    difference = (self.worry*2 - self.energy);
                    env.colonies(self.colony).energy = ...
                        env.colonies(self.colony).energy - difference;
                    self.energy = self.worry * 2;
                end
                
            end
        end
        
        function layPheromones(self, env)
            [x1, y1] = convert_pos(self.pos(1), self.pos(2));
            
            if (self.carrying ~= 0)
                p = Pheromone(self.pheromone_span, PheromoneType.Exploratory);
                env.environment(x1, y1).updatePheromone(p, self.colony);
            else
                p = Pheromone(self.pheromone_span, PheromoneType.Food);
                env.environment(x1, y1).updatePheromone(p, self.colony);
            end
            
        end
       
        function energyStep(self)
            self.energy = self.energy - 1;% does what they are carrying effect this????
        end
        
        function flag = hasAntVisitedPheromone(self, env, x, y)
            flag = env.environment(x,y).pheromone(2).ants(self.id) ~= 0;
        end
       
    end
end