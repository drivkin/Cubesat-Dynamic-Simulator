function [attIF wIF LExt] = oneStepSatDyn(Iwheels,Isat,attIF,wIF,TExt,LExt,wM,Tsample)
%calculates one time step of satellite dynamics
%   Detailed explanation goes here




%generate reaction wheel angular momentum vector
LWheels = Iwheels .* wM;
%convert to inertial frame
LWheelsIF = quatrotate(attIF,LWheels);

%update external moment added
LExt = LExt + TExt*Tsample;

%the external moment transformed to the satellite frame
LExtSF = quatrotate (quatconj(attIF),LExt);


% moment of inertia of the satellite is equal to the amount it's 
%been given by external torque minus what is being taken up by the wheels
Lsat = LExtSF - LWheels; 

%divide by Isat to get w i sat frame
wSF = Lsat./Isat;

%convert Isat to inertial frame
ISatIF = quatrotate(attIF, Isat);

%divide Lsat by ISatIF to get rotation speed

%wIF = Lsat./ISatIF; commented out for testing

wIF = quatrotate(attIF,wSF);

%now, assume that the rotation is constant during a time step, so that the
%amount of rotation equals magnitude(wIF)*Tsample, about the vector wIF
% this allows us to generate a rotation quaternion
rot = [norm(wIF)*Tsample wIF];

%make sure it's not all zeros. If it is, make it [0 0 0 1];
if(sum(rot==0)==4)
    rot = [0 0 0 1];
end

%a rotation (qvq^-1) of vector v by unit quaternion q is equal to a rotation 
% of 2*theta, where the real part of the quaternion equals cos(theta). We
% want our rotation to be represented as such

rot(1) = cos(rot(1)/2); %make appropriate rotation

vectorSize = sqrt(1 - (rot(1))^2); % magnitude of vector part to create unit quaternion 
magVec = sqrt(rot(2)^2+rot(3)^2+rot(4)^2);

rot(2:4) = rot(2:4).*vectorSize./magVec;

% sqrt(sum(rot.*rot)) %make sure we're really making unit vectors


%now multiply this increncremental rotation with the current orientation,
%and get the new current orientation

attIF = quatmultiply(rot, attIF);



end

