function [ theta ] = theta_between_points( x, y, a ,b )
%THETA_BETWEEN_POINTS Summary of this function goes here
%   Detailed explanation goes here
    theta = atan2(double(a - x), double(b - y));
end

