function create_control ()
%Data to enable fast mode and to allow pausing during opperation to zoom
%and pan on the current plotted figure

global CONTROL_DATA

CONTROL_DATA.fmode_display_every = 3;
CONTROL_DATA.fmode_control =[500 1000 2000 4000 8000 ; 4 8 15 30 60];
CONTROL_DATA.pause = false;

end

