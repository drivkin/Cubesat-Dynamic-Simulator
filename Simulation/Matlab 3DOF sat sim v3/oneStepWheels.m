function [ww_b aw_b] = oneStepWheels(Tsample,Iwheel,ww_b,aw_b,Kt,Ke,R,VM,Tb_w1,Tb_w2,Tb_w3)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%the moment of inertia of the wheel about the important axis
I = Iwheel(3,3);

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

%torque
T = (VM - BEMF)*Kt/R;

%acceleration
a = awgn(T/I,20); % gaussian noise to simulate not perfect motor control

%new speed
ww = ww +a*Tsample;

%convert speed to vectors
temp = [ 0 0 ww(1)]';
ww_b(:,1) = Tb_w1*temp;
temp = [ 0 0 ww(2)]';
ww_b(:,2) = Tb_w2*temp;
temp = [0 0 ww(3)]';
ww_b(:,3) = Tb_w3*temp;

%convert acceleration to vectors

temp = [ 0 0 a(1)]';
aw_b(:,1) = Tb_w1*temp;
temp = [ 0 0 a(2)]';
aw_b(:,2) = Tb_w2*temp;
temp = [0 0 a(3)]';
aw_b(:,3) = Tb_w3*temp;

end

