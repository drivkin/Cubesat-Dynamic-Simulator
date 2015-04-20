function [kxw kyw kzw] = computeGainsLQR(Isat,Tsample)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%A matrix for all directions
A=[0 1; 0 0];


%Q is chosen as 1/(ximax)^2
%R is chose as 1/(umax)^2
Q = [10 0; 0 10];

%for the given motors, the maximum torque is about 3mNm
R = [1/(.003^2)];

x = [1 0 0]';
y = [0 1 0]';
z = [0 0 1]';

IsatX = x'*Isat*x;
IsatY = y'*Isat*y;
IsatZ = z'*Isat*z;

% the negative sign because the torque on the wheels (which is the input)
% is the opposite of what is applied on the satellite
xsys = ss(A,[0 -1/IsatX]',[],[]);
ysys = ss(A,[0 -1/IsatY]',[],[]);
zsys = ss(A,[0 -1/IsatZ]',[],[]);

dxsys = c2d(xsys,Tsample);
dysys = c2d(ysys,Tsample);
dzsys = c2d(zsys,Tsample);

[kxw s e] = dlqr(dxsys.a,dxsys.b,Q,R);
[kyw s e] = dlqr(dysys.a,dysys.b,Q,R);
[kzw s e] = dlqr(dzsys.a,dzsys.b,Q,R);


end

