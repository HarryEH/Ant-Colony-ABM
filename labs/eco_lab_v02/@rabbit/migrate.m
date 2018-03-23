function [agt]=migrate(agt,cn)

%migration functions for class RABBIT
%agt=rabbit object
%cn - current agent number

%SUMMARY OF RABBIT MIGRATE RULE
%Rabbits will migrate only if they have not eaten
%Rabbits will always try to migrate towards the nearest food source
%The rabbit will extract the distibution of food in its LOCAL environment (at
%distances < its daily migration limit)
%It will identify the location of the nearest food and migrate into it.
%It's new position will be randomly placed within this square
%If no food is detected within its search radius it will move randomly (up
%to 8 atempts without leaving the model edge)

global ENV_DATA IT_STATS N_IT 
%N_IT is current iteration number
%IT_STATS is data structure containing statistics on model at each
%iteration (no. agents etc)
%interpolated to each grid point
%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food

mig=0;                               %indicates whether rabbit has successfully migrated
pos=agt.pos;                         %extract current position 
cpos=round(pos);                     %round up position to nearest grid point   
spd=agt.speed;                       %rabbit migration speed in units per iteration - this is equal to the food search radius

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function reduces the computational overhead. Only LOCAL area
%is searched for food, as opposed to entire environment
%loc_food is food distribution in local search area
%xmin in minimum x co-ord of this area
%ymin is minimum y co-ord of this area
[loc_food,xmin,ymin]=extract_local_food(cpos,spd);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
mig=0;                          %flag will be reset to one if rabbit migrates
[xf,yf]=find(loc_food);        %extract all rows (=x) and columns (=y) of food matrix where food is present
if ~isempty(xf)      
    xa=xmin+xf-1;                  %x co-ordiantes of all squares containing food
    ya=ymin+yf-1;                  %y co-ordiantes of all squares containing food
    csep=sqrt((xa-pos(:,1)).^2+(ya-pos(:,2)).^2);   %calculate distance to all food
    [d,nrst]=min(csep);     %d is distance to closest food, nrst is index of that food
    if d<=spd       %if there is at least one lot of food within the search radius        
        if length(nrst)>1       %if more lot of food located at same distance then randomly pick one to head towards
            s=round(rand*(length(nrst)-1))+1;
            nrst=nrst(s);
        end
        nx=xa(nrst)+rand-0.5;
        ny=ya(nrst)+rand-0.5;
        npos=[nx ny];
        %if agent has left edge of model, then adjust slightly
        shft=find(npos>=ENV_DATA.bm_size);
        npos(shft)=ENV_DATA.bm_size-rand;
        shft=find(npos<=1);
        npos(shft)=1+rand;
        mig=1;
    end
end
    
if mig==0                                   %rabbit has been unable to find food, so chooses a random direction to move in      
    cnt=1;
    dir=rand*2*pi;              
    while mig==0&cnt<=8                     
        npos(1)=pos(1)+spd*cos(dir);        %new x co-ordinate
        npos(2)=pos(2)+spd*sin(dir);        %new y co-ordinate
        if npos(1)<ENV_DATA.bm_size&npos(2)<ENV_DATA.bm_size&npos(1)>=1&npos(2)>=1   %check that fox has not left edge of model - correct if so.
           mig=1;
        end
        cnt=cnt+1;
        dir=dir+(pi/4);         %if migration not successful, then increment direction by 45 degrees and try again
    end
end

if mig==1
    agt.pos=npos;                                   %update agent memory
    IT_STATS.mig(N_IT+1)=IT_STATS.mig(N_IT+1)+1;    %update model statistics
end