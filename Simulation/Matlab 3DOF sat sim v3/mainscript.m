%sample period
Tsample =.001;

%sample period of control system
csysTsample =.02;

%simulation time in seconds
tsim = 30;

t = 0:Tsample:tsim;

%Motor constants

%18.1 mNm/A
Kt=18.1 / 1000;

%1.895 mv/rpm convert to v/(rad/s)
Ke=1.895*(1/1000)*(60)*(1/(2*pi));
R=28.2;


%the sum of all the moments of inertia (all the different pieces plus the body
%overall) we calculate this here because it is constant on every iteration

%gives MOI matrices
%threeUSatSetup;
oneUSatSetup;
  
% initial w of wheels wrt body in body coordinates
ww_b = zeros(3);

%initial angular acceleration of wheels wrt. body in body coordintaes
aw_b=zeros(3);

%initialize DCM of base wrt inertial frame. Initially both are aligned
yawinit = 0;
pitchinit = 0;
rollinit = 0;

Tb_i = angle2dcm(yawinit, pitchinit, rollinit);
[y p r] = dcm2angle(Tb_i)

%initialize angular rotation of frame b wrt frame i in the b coordinate
%system
wb_i = [1 1 3]'; 
 
%initialize angular acceration of frame b wrt frame i in the b coordinate
%system
ab_i =[0 0 0]';

%init motor voltage
VM=[0 0 0]';

%external torque vector in inertial frame
Text = [0 .00001 -0.00001]';

%create desired set point
yaw = -pi/3; 
pitch = pi/5; 
roll = pi/1;
DCMd = angle2dcm( yaw, pitch, roll )


%get the unit normal vector of the YZ plane
a = cross([0 1 0]',[0 0 1]');
b = norm(a);
c = a/b;

% the matrix which projects a vector onto the YZ plane
projYZ = eye(3) - c*c';

%get the unit normal vector of the ZX plane
a = cross([0 0 1]',[1 0 0]');
b = norm(a);
c = a/b;

% the matrix which projects a vector onto the YZ plane
projZX = eye(3) - c*c';

%get the unit normal vector of the XY plane
a = cross([1 0 0]',[0 1 0]');
b = norm(a);
c = a/b;

% the matrix which projects a vector onto the XY plane
projXY = eye(3) - c*c';


%compute the feedback gains using lqr
[kxw kyw kzw] = computeGainsLQR(Isat,csysTsample);



%create memory matrices
Tb_i_m = zeros(3,3,length(t));
wb_i_m = zeros(3,length(t));
ww_b_m = zeros(3,3,length(t));
V_m = zeros(3,length(t));
err_m = zeros(3,3,length(t));

for i=1:length(t)
   Tb_i_m(:,:,i)=Tb_i;
   wb_i_m(:,i)=wb_i;
   ww_b_m(:,:,i) = ww_b;
   V_m(:,i)=VM;
   err_m(:,:,i)=DCMd*Tb_i';
   if(mod(t(i),csysTsample)<=Tsample)
    %VM = oneStepControl2(Tsample,DCMd,Tb_i,wb_i,ww_b,Iw_b,sumMOI,Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3,projYZ,projZX,projXY,kxw,kyw,kzw);
    VM = quatErrControl(Tsample,DCMd,Tb_i,wb_i,ww_b,Iw_b,sumMOI,Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3,projYZ,projZX,projXY,kxw,kyw,kzw);
   end
   %VM(2:3)=0;
   %VM = oneStepControl(Tsample,DCMd,Tb_i,wb_i,ww_b,Iw_b,sumMOI,Tb_i*Text,Kt,Ke,R,Tb_w1,Tb_w2,Tb_w3);
   [ww_b aw_b] = oneStepWheels(Tsample,Iwheel,ww_b,aw_b,Kt,Ke,R,VM,Tb_w1,Tb_w2,Tb_w3);
   [Tb_i wb_i] = oneStepDyn(Tsample,sumMOI, Iw_b,ww_b,aw_b,Tb_i,wb_i,Tb_i*Text);
   if(isnan(Tb_i))
       break;
   end
end
close all;
figure
plot(t,V_m');
title('Input Voltages (volts)')
shg

figure
hold off
plot(t,squeeze(ww_b_m(1,1,:)),'b')
hold on
plot(t,squeeze(ww_b_m(2,2,:)),'g')
plot(t,squeeze(ww_b_m(3,3,:)),'r')
title('wheel speeds (rad/s)')
shg


figure
[yerr perr rerr]=dcm2angle(err_m);
hold off
plot(t,yerr,'b');
hold on
plot(t,perr,'g');
plot(t,rerr,'r');

ylabel('error (rad)');
xlabel('time (s)');

legend('yaw error','pitch error','roll error');



