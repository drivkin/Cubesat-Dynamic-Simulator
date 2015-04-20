
%set up constants

%sample time for fixed step size solver
Tsample = .001;
simTime = 5; %simulation time in seconds

%Motor torque constant
Kt = 1;

%motor electrical constant
Ke = 1;

%armature resistance
R = 1; 
%moment of inertia of reaction wheel (and rotor)
IWheels = [1 1 1];

ISat = [1 1 1]; %moment of inertia of satellite in satellite frame

t = 0:Tsample:simTime; % the time steps of the simulation

%state variables
attIF = [0 0 1 0]; %unit quaternion representing attitude in inertial frame
wIF = [0 0 0]; %vector representing angular velocity in inertial frame
attIFest = [0 0 0 1]; %unit quaternion representing attitude estimate in inertial frame
wIFest = [0 0 0]; %vector representing angular velocity estimate in inertial frame
TExt = [0 0 1]; %vector representing external torque in inertial frame

wM = [10 0 0]; %motor angular velocity in sat frame
VM = [0 0 0]; %motor voltage command (in V) 

LExt = compute_LExt_init(wIF,attIF,wM,IWheels,ISat)%angular momentum added by external torque

%memory
attIF_m = zeros(4,length(t));
wIF_m = zeros(3,length(t));
attIFest_m = zeros(4,length(t));
wIFest_m = zeros(3,length(t));
TExt_m = zeros(3,length(t));
wM_m = zeros(3,length(t));
VM_m = zeros(3,length(t));



%this loop runs the simulation step by step
for tStep = 1:length(t)
    [attIF wIF LExt] = oneStepSatDyn(IWheels,ISat,attIF,wIF,TExt,LExt,wM,Tsample);
    [attIFest wIFest] = oneStepEstimator(attIF, wIF, Tsample);
    VM = oneStepController(attIFest, wIFest,wM, Tsample);
    wM = oneStepMotors(Kt, R, Ke, IWheels, VM,wM,Tsample);
    wM = [10 0 0];
    attIF_m(:,tStep) = attIF;
    wIF_m(:,tStep) = wIF;
    attIFest_m(:,tStep) = attIFest;
    wIFest_m(:,tStep) = wIFest;
    TExt_m(:,tStep) = TExt;
    wM_m(:,tStep) = wM;
    VM_m(:,tStep) = VM;
end

[r1 r2 r3] = quat2angle(attIF_m','XYZ');
figure
subplot(1,3,1)
plot(t,r1)
subplot(1,3,2)
plot(t,r2)
subplot(1,3,3)
plot(t,r3)
shg


