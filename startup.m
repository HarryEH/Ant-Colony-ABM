addpath(genpath(pwd));

user = getenv('username');

if (isempty(user))
    user = getenv('USER');
end

disp("*******************************************");
disp("* Welcome to your M&S Assignment Directory");
disp("* User is: "+ user);
days = daysact(datetime('today'),'05/14/2018');
disp("* Days till assignment due: "+ days);
disp("*******************************************");

clear user; clear days;
