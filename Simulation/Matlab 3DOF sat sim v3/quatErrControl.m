function VM = quatErrControl(Tsample,DCMd,DCMc,wb_i,ww_b,Iw_b,sumMOI,Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3,projYZ,projZX,projXY,kxw,kyw,kzw)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

dquat = dcm2quat(DCMd);
cquat = dcm2quat(DCMc);

equat = quatmultiply(quatconj(cquat),dquat);
equat = [1 0 0 0] - equat;
%create the state vectors for each wheel
% 
% stateX = [equat(2) wb_i(1)]';
% stateY = [equat(3) wb_i(2)]';
% stateZ = [equat(4) wb_i(3)]';

% stateX = [wb_i(1) equat(2)]';
% stateY = [wb_i(2) equat(3)]';
% stateZ = [wb_i(3) equat(4)]';

stateX = [agwn(wb_i(1),20) equat(2)]';
stateY = [agwn(wb_i(2),20) equat(3)]';
stateZ = [agwn(wb_i(3),20) equat(4)]';


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
VM=(T*R/Kt+awgn(BEMF,20)); % gaussian noise to simulate noisy velocity estimate



end

