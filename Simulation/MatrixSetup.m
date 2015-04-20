% this script is used to set up the state space matrices (and other
% variables) for the the simulink cubesat simulation
%%
%this section sets up the matrices for the attitude dynamics of the
%satellite, ie how it spins about its axes of rotation as 3 inputs, U1,U2,
%and U3, are applied. The C matrix is 6 by 6, however, to allow us to
%implement the nonlinear nature of Co, so it needs to be included as an
%input

%moments of inertia of cube sat around x, y, and z axes
Ix=1;
Iy=1;
Iz=1;

%moments of inertia of reaction wheels 1,2,3 corresponds to x,y,z axes
%respectively
I1=.01;
I2=.01;
I3=.01;

%motor constants, wrt to rad/s
ke1=1;
ke2=1;
ke3=1;

km1=1;
km2=1;
km3=1;

%motor inductances (henries)
L1=1;
L2=1;
L3=1;

%motor resistances (ohms)
R1=1;
R2=1;
R3=1;

%motor dynamic friction 
Cv1=1;
Cv2=1;
Cv3=1;

%motor static friction
Co1=1;
Co2=1;
Co3=1;

aa1=(-km1*ke1/R1-Cv1)/(I1+km1*L1/(R1^2));
aa2=(-km2*ke2/R2-Cv2)/(I2+km2*L2/(R2^2));
aa3=(-km3*ke3/R3-Cv3)/(I3+km3*L3/(R3^2));


A_attitude_dynamics=[ 0 0 0 I1/Ix 0 0;
                        0 0 0 0 I2/Iy 0;
                        0 0 0 0 0 I3/Iz;
                        0 0 0 aa1 0 0;
                        0 0 0 0 aa2 0;
                        0 0 0 0 0 aa3;];
 

bb1=I1+km1*L1/(R1^2);
bb2=I2+km2*L2/(R2^2);
bb3=I3+km3*L3/(R3^2);
                    
                    
B_attitude_dynamics=[0 0 0 0 0 0;
                    0 0 0 0 0 0;
                    0 0 0 0 0 0;
                    km1/(R1*bb1) 0 0 -1/bb1 0 0;
                    0 km2/(R2*bb2) 0 0 -1/bb2 0;
                    0 0 km2/(R3*bb2) 0 0 -1/bb3;];
                
C_attitude_dynamics=eye(6);
D_attitude_dynamics=zeros(6);

%%

                    
                        



