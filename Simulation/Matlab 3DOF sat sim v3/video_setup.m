xmax = size(full_canvas,2)
ymax = size(full_canvas,1)

%home to about me

%initially, point at home
yawinit = (1100*2*pi/xmax)-pi
pitchinit = (1450*2*pi/ymax)/2 - pi/2
rollinit = 0;

%finally, point to about me
yaw = wrapToPi(760*2*pi/xmax) - pi
pitch = wrapToPi(460*2*pi/ymax)/2 -pi/2
roll=0;
%%
% dcm = angle2dcm(1.7279,-2.8256,.1);
% [yaw pitch roll] = dcm2angle(dcm)