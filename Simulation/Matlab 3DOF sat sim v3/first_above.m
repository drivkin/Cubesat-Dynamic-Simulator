function [ fa ] = first_above(curr, n1,n2)
%curr - current position
%n1 - possible position 1
%n2 - possible position 2

%if you start at curr on the number line and then go up, which do you hit
%first, n1 or n2? Return the first one you hit.
if(n1 < n2)
    if(curr<n1)
        fa=n1;
    else
        fa=n2;
    end
else %n1>n2
    if(curr>n2)
        fa=n2;
    else
        fa=n1;
    end
end
end

