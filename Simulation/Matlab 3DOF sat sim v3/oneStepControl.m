function VM = oneStepControl(Tsample,DCMd,DCMc,wb_i,ww_b,Iw_b,sumMOI,Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3)
%

%Tsample: sample time

%DCMd: desired DCM between body and inertial (ie desired
%orientation for body frame)

%DCMc: current DCM between body and inertial

%wb_i: current angular velocity of the satellite relative to the inertial
%frame expressed in body coordinates

%ww_b: angular velocities of the wheels wrt to the body expressed in body
%coordinates

%Iw_b: MOI of wheels about their own center of mass, expressed in body
%coordinates

%sumMOI: The moment of inertia arising from all of the different pieces
%having centers of mass away from the common CM

%Text: external torques about CM in body coordinates

zeroRoundingThresh = 0;


%get the dcm of rotation needed
DCMrot = DCMd*DCMc';

%express the necessary rotation as quaternion in inertial coordinates
q=dcm2quat(DCMrot);

%take the vector part of the quaternion, the desired w is in the same
%direction
wdes = q(2:4)';

%rotation angle 2*arccos(q(1)
thetaRot=2*acos(q(1));


%now, we arbitrarily choose the magnitude of wdes to be such that the
%satellite would rotate through thetaRot in 1 second
wdes=wdes*thetaRot/norm(wdes);

%now transform wdes to body coordinates
wdes = DCMc*wdes;

%now choose a desired acceleration will move us from the current angular
%velocity to wdes in 1 second (again arbitrary)
ades = (wdes-wb_i);

%solve for desired wheel momentum changes
term1 = sumMOI*ades;

term2 = skew(wb_i)*Iw_b(:,:,1)*ww_b(:,1)+Iw_b(:,:,2)*ww_b(:,2)+Iw_b(:,:,3)*ww_b(:,3);

term3 = skew(wb_i)*sumMOI*wb_i;

x = Text - term1 - term2 -term3;

toRound = find(abs(x)<zeroRoundingThresh);
x(toRound)=0;

%once x is solved for, it tells us the torque we need to put on each wheel
%once we know desired torque, we compute the desired voltage outputs

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
VM=x*R/Kt+BEMF;

end

 