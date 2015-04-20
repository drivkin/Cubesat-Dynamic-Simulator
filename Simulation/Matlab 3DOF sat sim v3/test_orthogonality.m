function [ result ] = test_orthogonality( input )
%takes a mxmxn matrix, ie a bunch of mxm matrices. Multiplies each mxm
%matrix with its transpose to test orthogonality

result=zeros(size(input));

for i=1:size(input,3)
   result(:,:,i)=input(:,:,i)'*input(:,:,i);
    
end




end

