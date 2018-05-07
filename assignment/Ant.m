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
                    a.carrying = varargin{3};% Current amount of food that you're carrying
                    a.pos      = varargin{4};% Current position
                    a.speed    = varargin{5};% Current speed
                    a.strength = varargin{6};% Strength of the ant
                    a.colony   = varargin{7};% Colony that the any belongs to 
                    a.type     = varargin{8};% type
                    a.id       = varargin{9};% type
            end
        end
        
        function flag = step(self, env)
            if (isempty(self.pos))
                return;
            end
            % Increase the age
            self.ageStep();
            
            self.energyStep(env);
            
            [x1, y1] = convert_pos(self.pos(1), self.pos(2));
            
            
            if(self.carrying == 0)
                if (env.checkForFood([x1,y1]))
                    if (env.environment(x1,y1).food < self.strength)
                        self.carrying = env.environment(x1,y1).food;
                        env.environment(x1,y1).food = 0;
                    else
                        self.carrying = self.strength;
                        env.environment(x1,y1).food = env.environment(x1,y1).food - self.strength;
                    end
%                 else
%                     p = Pheromone(self.pheromone_span, PheromoneType.Exploratory);
%                     env.environment(x1, y1).updatePheromone(p, self.colony);
                end
            else
                [c_x, c_y] = convert_pos(env.colonies(self.colony).pos(1), ...
                                         env.colonies(self.colony).pos(2));
                                  
                [ant_x, ant_y] = convert_pos(self.pos(1), self.pos(2));
                if ( c_x == ant_x && c_y == ant_y )
                    % dump food in the colony
                    env.colonies(self.colony).energy = env.colonies(self.colony).energy + self.carrying;
                    self.carrying = 0;
                    self.energy = 150;
                else
                    % lay food carrying pheremone
                    p = Pheromone(self.pheromone_span, PheromoneType.Food);
                    env.environment(x1, y1).updatePheromone(p, self.colony);
                end
                
            end
            
            self.moveStep(env.size, env.colonies(self.colony).pos, env);
            
            flag = false;
        end
        
        function ageStep(self)
            self.age = self.age + 1;
        end
        
        function moveStep(self, size, colony_pos, env)
            if (self.carrying == 0)
                [flag, x, y] = self.detectFoodPheromone(env);
                if (flag)
                    self.followFood(size, colony_pos, x, y, env);
                else
                    self.randomMove(size);
                end
            else     
                self.moveToColony(size, colony_pos);
            end  
        end
        
        function randomMove(self, size) 
            theta = rand() * 2*pi;
            
            self.doMove(theta, size);
        end
        
        function moveToColony(self, size, pos)
                        
            theta = theta_between_points( self.pos(1), self.pos(2), ...
                                          pos(1), pos(2));
  
            self.doMove(theta, size);

        end
        
        function followFood(self, size, pos, x , y, env)
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
                    self.randomMove(size);
                end
   
            else  
               
                theta = theta_between_points( self.pos(1), self.pos(2),...
                                              x, y);
               
                if self.hasAntVisitedPheromone(env, x, y)
                    self.randomMove(size);
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
        
        function [flag, x, y] = detectFoodPheromone(self, env)
            flag = false;
            x    = [];
            y    = [];
            
            [int_x, int_y] = convert_pos(self.pos(1), self.pos(2));
            
            x_corner = int_x - 1;
            y_corner = int_y - 1;
            
            for i = 0:1:2
                for j = 0:1:2
                    if ( (x_corner + i > 0 && x_corner + i < 51) && ...
                            ( y_corner + j > 0 && y_corner + j < 51) )
                        
                        % assign the pheromone to a variable 
                        ph = env.environment(x_corner + i, y_corner + j) ...
                        .getPheromone(PheromoneType.Food);
                    
                        if ( ph.level > 0 && ismember(self.colony, ph.colony) )
                            x(length(x) + 1) = x_corner + i;
                            y(length(y) + 1) = y_corner + j;
                            flag = true;
                        end
                        
                    end
                    
                end
            end
            % detect if there is food pheromone around
        end
        
       
        function energyStep(self, env)
            % Decrease the energy if not in colony
%             if (mean (self.pos == env.colonies(self.colony).pos) ~= 1)
                % decrease energy
                % maybe based on how much its carrying???
            self.energy = self.energy - 1;% does what they are carrying effect this????
%             end
        end
        
        function flag = hasAntVisitedPheromone(self, env, x, y)
            flag = env.environment(x,y).pheromone(2).ants(self.id) ~= 0;
        end
       
    end
end