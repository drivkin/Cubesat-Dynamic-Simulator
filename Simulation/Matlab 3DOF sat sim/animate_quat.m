function [ output_args ] = animate_quat(q, Tsample, TimeStep, wIF)
% q is rotation quaternion
% T sample is sample time
% TimeStep is time step for plotting

xvec = [1 0 0];
yvec = [0 1 0];
zvec = [0 0 1];

jump = TimeStep/Tsample;
%haxes = axes('XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1]);
for i=1:jump:size(q,2)
    xIF = quatrotate(q(:,i)',xvec);
    yIF = quatrotate(q(:,i)',yvec);
    zIF = quatrotate(q(:,i)',zvec);
    hold off;
    quiver3(0,0,0,xIF(1),xIF(2),xIF(3))
    hold on;
    quiver3(0,0,0,yIF(1),yIF(2),yIF(3))
    quiver3(0,0,0,zIF(1),zIF(2),zIF(3))
    quiver3(0,0,0,wIF(1,i),wIF(2,i),wIF(3,i));
    axis([-1 1 -1 1 -1 1]);
    shg
    pause(TimeStep);
end

