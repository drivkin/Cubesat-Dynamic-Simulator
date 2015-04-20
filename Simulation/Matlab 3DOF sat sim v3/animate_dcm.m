function [M] = animate_dcm(Tsample,TimeStep,dcms,DCMd)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

x=[1 0 0]';
y=[0 1 0]';
z=[0 0 1]';

jump = TimeStep/Tsample;
hfig=figure
%set(hfig,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
j=0;
for i =1:jump:size(dcms,3)
    j=j+1;
    xIF = dcms(:,:,i)'*x;
    yIF = dcms(:,:,i)'*y;
    zIF = dcms(:,:,i)'*z;
    xdIF = DCMd'*x;
    ydIF = DCMd'*y;
    zdIF = DCMd'*z;
    hold off;
    quiver3(0,0,0,xIF(1),xIF(2),xIF(3))
    hold on;
    quiver3(0,0,0,yIF(1),yIF(2),yIF(3))
    quiver3(0,0,0,zIF(1),zIF(2),zIF(3))
    quiver3(0,0,0,xdIF(1),xdIF(2),xdIF(3))
    quiver3(0,0,0,ydIF(1),ydIF(2),ydIF(3))
    quiver3(0,0,0,zdIF(1),zdIF(2),zdIF(3))
    %quiver3(0,0,0,wIF(1,i),wIF(2,i),wIF(3,i));
    axis([-1 1 -1 1 -1 1]);
    shg
    M(j)=getframe;
    %pause(TimeStep);
    
end 

end

