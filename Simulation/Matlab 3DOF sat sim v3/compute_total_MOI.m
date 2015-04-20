%location of overall center of mass wrt the center of mass of the cube
C = [.0046 .0046 .0046]';

%locations of the centers of mass of the wheels wrt the cube
w1 = [.046 0 0]';
w2 = [0 .046 0]';
w3 = [0 0 .046]';

w1c=w1-C;
w2c=w2-C;
w3c=w3-C;

%location of cm of the cube
cube = -C;

%.1(kg) is mass of each wheel, .7(kg) is mass of the cube
Isat = .1*(skew(w1c)'*skew(w1c)+skew(w2c)'*skew(w2c)+skew(w3c)'*skew(w3c))+.7*skew(cube)'*skew(cube);