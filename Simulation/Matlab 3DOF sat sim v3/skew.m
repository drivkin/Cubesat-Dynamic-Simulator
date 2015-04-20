function [ mat ] = skew( vec )
%compute the skew symmetric form of a vector as defined in the Zipfel book

mat = [ 0 -vec(3) vec(2);
        vec(3) 0 -vec(1);
        -vec(2) vec(1) 0];

end

