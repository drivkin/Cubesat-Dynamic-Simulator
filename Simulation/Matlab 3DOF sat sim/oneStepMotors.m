function wM = oneStepMotors(Kt, R, Ke, IWheels, VM,wM,Tsample)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

BEMF = Ke.*wM;

T = (VM - BEMF)*Kt/R;

wM = wM + T./IWheels*Tsample;


end

