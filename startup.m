addpath(genpath(pwd));

user = getenv('username');

if (isempty(user))
    user = getenv('USER');
end

disp("*******************************************");
disp("* Welcome to this Ant Colony ABM");
disp("* User is: "+ user);
disp("* Date today: "+ datetime('today'));
disp("*******************************************");

clear user; clear days;
