function [ ortho ] = orthogonalize( mat )
% clean up a matrix that should be orthogonal but isn't due to
% computational imperfections

ortho = mat + .5*(eye(3)-mat*mat')*mat;


end

