%threeUSatSetup

%This script sets up a 3u cubesat with the control system on one end of it,
%not in the center. In fact it, it is composed of the 1u cubesat with
%control system attached to a 10*10*20 cm uniform mass distribution box
%with a mass of 2kg.

%displacement vectors of centers of mass of all the parts

%big box
Mbb = 2;
CMbb = [5 5 10]'*10^-2;
%small box
Msb=.7;
CMsb = [4.5 4.5 24.5]'*10^-2;
%X axis wheel
Mxw=.1;
CMxw = [9.1 4.5 24.5]'*10^-2;
%Y axis wheel
Myw=.1;
CMyw = [4.5 9.1 24.5]'*10^-2;
%Z axis wheel 
Mzw=.1;
CMzw = [4.5 4.5 29.1]'*10^-2;

Mtotal = 3;

CM = (Mbb*CMbb+Msb*CMsb+Mxw*CMxw+Myw*CMyw+Mzw*CMzw)/Mtotal;

Isat = Mbb*skew(CMbb-CM)'*skew(CMbb-CM)...
        + Msb*skew(CMsb-CM)'*skew(CMsb-CM)...
        + Mxw*skew(CMxw-CM)'*skew(CMxw-CM)...
        + Myw*skew(CMyw-CM)'*skew(CMyw-CM)...
        + Mzw*skew(CMzw-CM)'*skew(CMzw-CM);
    
   
    
    
    
% MOI tensor for reaction wheels about their own CM in reaction wheel coordinates
Iwheel = diag([5.07 5.07 10.1]*10^-5); %z is through the top, refer to http://en.wikipedia.org/wiki/List_of_moments_of_inertia#List_of_3D_inertia_tensors

%the wheels are aligned as follows: w1 z axis to body x axis, w2 z axis to
%body y axis, w3 z axis to body z axis. Right hand convention (curl fingers
%from x to y, thumb point to z) preserved

%transformation between w1 coordinates and body coordinates
Tb_w1 = [0 0 1; 
        1 0 0; 
        0 1 0];
    
Tb_w2 = [0 1 0; 
        0 0 1; 
        1 0 0];
    
Tb_w3 = eye(3);

% 3 by 3 by 3 matrix contating inertia tensors for the three wheels
% referred to the body frame
Iw_b = zeros(3,3,3);
Iw_b(:,:,1)=Tb_w1*Iwheel*Tb_w1';
Iw_b(:,:,2)=Tb_w2*Iwheel*Tb_w2';
Iw_b(:,:,3)=Tb_w3*Iwheel*Tb_w3';

%big box moment of inertia tensor expressed about CM of big box in body
%coordinates
Ibb = 1/12*Mbb*[.1^2+.2^2 0 0;
                0 .1^2+.2^2 0;
                0 0 .1^2+.1^2];
            
%small box MOI
Isb = 1/6*Msb*[.09^2 0 0;
                0 .09^2 0;
                0 0 .09^2];
            

%Sum of moments
sumMOI = sum(Iw_b,3)+Ibb+Isb+Isat;
          
                
