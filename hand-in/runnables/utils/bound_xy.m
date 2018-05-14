function [ x1, y1 ] = bound_xy( size, x, y )
%BOUND_XY Summary of this function goes here
%   Detailed explanation goes here
    x1 = x;
    y1 = y;
    
    if( x > size)
        x1 = size;
    end

    if( y > size)
        y1 = size;
    end

    if( x < 1)
        x1 = 1;
    end

    if( y < 1)
        y1 = 1;
    end

end

