function [ fb ] = first_below( curr,n1,n2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%start at curr on the number line and go down. fb is the first of n1 or n2
%that you hit

if(n1>n2)
    if(n1<curr)
        fb=n1;
    else
        fb=n2;
    end
else
    if(n2<curr)
        fb=n2;
    else
        fb=n1;
    end
end


end

