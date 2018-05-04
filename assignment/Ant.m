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
        type;
        pheromone_span = 25;
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
                    a.type     = [];
                case 8 % Create a new Ant
                    a.age      = varargin{1};% Age of Ant
                    a.energy   = varargin{2};% Current energy 
                    a.carrying = varargin{3};% Current amount of food that you're carrying
                    a.pos      = varargin{4};% Current position
                    a.speed    = varargin{5};% Current speed
                    a.strength = varargin{6};% Strength of the ant
                    a.colony   = varargin{7};% Colony that the any belongs to 
                    a.type     = varargin{8};% type
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
                        
                else
                    p = Pheromone(self.pheromone_span, PheromoneType.Exploratory);
                    env.environment(x1, y1).updatePheromone(p);
                end
            else
                [c_x, c_y] = convert_pos(env.colonies(self.colony).pos(1), ...
                                         env.colonies(self.colony).pos(2));
                                  
                [ant_x, ant_y] = convert_pos(self.pos(1), self.pos(2));
                if ( c_x == ant_x && c_y == ant_y )
                    % dump food in the colony
                    env.colonies(self.colony).energy = env.colonies(self.colony).energy + self.carrying;
                    self.carrying = 0;
                    disp('reached the colony');
                else
                    % lay food carrying pheremone
                    p = Pheromone(self.pheromone_span, PheromoneType.Food);
                    env.environment(x1, y1).updatePheromone(p);
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
                self.randomMove(size);
            elseif (self.detectFoodPheromone(env))
                self.followFood(size, colony_pos);
            else
                self.moveToColony(size, colony_pos);
            end
          
            
        end
        
        function randomMove(self, size) 
            theta = rand() * 2*pi;
            
            self.doMove(theta, size);
        end
        
        function moveToColony(self, size, pos)
                        
            direc_x = pos(1);
            direc_y = pos(2);
            
            current_x = self.pos(1);
            current_y = self.pos(2);
            
            theta = atan2((direc_x - current_x) , (direc_y - current_y));
  
            self.doMove(theta, size);

        end
        
        function followFood(self, size, pos, env)
            % follow the food trail, likely have to move away from the
            % colony
        end
        
        function doMove(self, theta, size)
            x = self.pos(1) + (self.speed * sin(theta));
            y = self.pos(2) + (self.speed * cos(theta));
            
            [x1, y1] = bound_xy(size, x, y);
            self.pos = [x1, y1];
        end
        
        function flag = detectFoodPheromone(self, env)
            flag = false;
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
       
    end
end