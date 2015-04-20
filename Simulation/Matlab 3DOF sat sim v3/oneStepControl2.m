function VM = oneStepControl2(Tsample,DCMd,DCMc,wb_i,ww_b,Iw_b,sumMOI,Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3,projYZ,projZX,projXY,kxw,kyw,kzw)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



%desired DCM in body coordinates, also known as the error between the
%current orientation and the desired orientation
err =  DCMd*(DCMc');

%the z axis of the desired orientation projected onto the YZ plane
dzProjYZ = projYZ*err(:,3);

%the x axis of the desired orientation projected onto the ZX plane
dxProjZX = projZX*err(:,1);

%the y axis of the desired orientation projected onto the XY plane
dyProjXY = projXY*err(:,2);


%the angle between the projection of the desired z axis onto the YZ plane and the current z axis, also
%known as the quantity controlled by the x wheel, or thetaX. 

thetaX  = atan2(norm(cross([0 0 1]',dzProjYZ)), dot([0 0 1]',dzProjYZ));
%this gives us the magnitude of theta. Now we need the sign. To do this,
%get the cross product
c = cross([0 0 1]',dzProjYZ);
%now, if the current z axis is clockwise of the projection, then the x
%component of the cross product is positive. If x component is negative,
%then z axis is counterclockwise of the projection
if(c(1)<=0)
    thetaX=-thetaX;
end


%similar for Y and Z wheels
thetaY  = atan2(norm(cross([1 0 0]',dxProjZX)), dot([1 0 0]',dxProjZX));
c = cross([1 0 0]',dxProjZX);
if(c(2)<=0)
    thetaY = -thetaY;
end

thetaZ  = atan2(norm(cross([0 1 0]',dyProjXY)), dot([0 1 0]',dyProjXY));
c = cross([0 1 0]',dyProjXY);
if(c(3)<=0)
    thetaZ = -thetaZ;
end


%create the state vectors for each wheel
stateX = [thetaX wb_i(1)]';
stateY = [thetaY wb_i(2)]';
stateZ = [thetaZ wb_i(3)]';

T=zeros(3,1);
%compute control torques
T(1) = -kxw*stateX;
T(2)= -kyw*stateY;
T(3)= -kzw*stateZ;

T(find(T>.003))=.003;
T(find(T<-.003))=-.003;


%compute control voltages from control torques
%extract the wheel speeds from matrix which expresses them in body
%coordinates
temp=Tb_w1'*ww_b(:,1);
ww(1) = temp(3);

temp = Tb_w2'*ww_b(:,2);
ww(2) = temp(3);

temp = Tb_w3'*ww_b(:,3);
ww(3) = temp(3);

ww=ww';
%back EMF
BEMF = Ke.*ww;

%solve for voltage output
VM=T*R/Kt+BEMF;






end

