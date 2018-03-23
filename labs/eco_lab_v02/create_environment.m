function create_environment(size)

%function that populates the global data structure representing
%environmental information

%ENV_DATA is a data structure containing information about the model
   %environment
   %    ENV_DATA.shape - shape of environment - FIXED AS SQUARE
   %    ENV_DATA.units - FIXED AS KM
   %    ENV_DATA.bm_size - length of environment edge in km
   %    ENV_DATA.food is  a bm_size x bm_size array containing distribution
   %    of food

global ENV_DATA

ENV_DATA.shape='square';
ENV_DATA.units='kilometres';
ENV_DATA.bm_size=size;
ENV_DATA.food=floor(50*ones(size,size));        %distribute food in km x km squares 
ENV_DATA.food(round(0.6*size):round(0.8*size),round(0.6*size):round(0.8*size))=0;   %generate patch where there is no food
