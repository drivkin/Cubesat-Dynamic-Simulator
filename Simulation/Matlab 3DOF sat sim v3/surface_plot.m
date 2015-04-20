function [ ] = surface_plot(Tsample,Tplot,dcms,DCMd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x=[1 0 0]';
y=[0 1 0]';
z=[0 0 1]';

circleSize=10;

jump = Tplot/Tsample;
hfig=figure
%set(hfig,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
j=0;
    xdIF = DCMd'*x;
    ydIF = DCMd'*y;
    zdIF = DCMd'*z;
    
    scatter3(xdIF(1),xdIF(2),xdIF(3),100,[0 0 1],'fill')
    hold on
    scatter3(ydIF(1),ydIF(2),ydIF(3),100,[0 1 0],'fill')
    scatter3(zdIF(1),zdIF(2),zdIF(3),100,[1 0 0],'fill')
    
for i =1:jump:size(dcms,3)
    j=j+1;
    xIF = dcms(:,:,i)'*x;
    yIF = dcms(:,:,i)'*y;
    zIF = dcms(:,:,i)'*z;
    scatter3(xIF(1),xIF(2),xIF(3),circleSize,[0 0 .5],'+')
    scatter3(yIF(1),yIF(2),yIF(3),circleSize,[0 .5 0],'+')
    scatter3(zIF(1),zIF(2),zIF(3),circleSize,[.5 0 0],'+')
    %quiver3(0,0,0,wIF(1,i),wIF(2,i),wIF(3,i));
    axis([-1 1 -1 1 -1 1]);
    
    %pause(TimeStep);
    
end 
[a b c]=sphere(100);
surf(a,b,c,'FaceAlpha',.1,'EdgeAlpha',0);
%shading interp
axis('equal');
legend('x axis endpoint','y axis endpoint','z axis endpoint','x axis', 'y axis', 'z axis');

end



