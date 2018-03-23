function create_params

%set up breeding, migration and starvation threshold parameters. These
%are all completely made up!

%PARAM - structure containing values of all parameters governing agent
%behaviour for the current simulation

global PARAM

    PARAM.R_SPD=2;         %speed of movement - units per itn (rabbit)
    PARAM.F_SPD=5;         %speed of movement - units per itn (fox)
    PARAM.R_BRDFQ=10;      %breeding frequency - iterations
    PARAM.F_BRDFQ=20;
    PARAM.R_MINFOOD=0;      %minimum food threshold before agent dies 
    PARAM.F_MINFOOD=0;
    PARAM.R_FOODBRD=10;     %minimum food threshold for breeding
    PARAM.F_FOODBRD=10;
    PARAM.R_MAXAGE=50;      %maximum age allowed 
    PARAM.F_MAXAGE=50;
    
    