function [msk1_final,msk2_final]  = makeVonMises(R0,theta0,dim1,dim2)
%this function makes the grouping filter derived from gestalt
%pyschophysics and the Von Mises distribution
%
%inputs:
%R0 - Center surround exictatory standard deviation
%theta0 - orientation of Edge mask
%dim1 - vector of pixels along first dimension
%dim2 - vector of pixels along second dimension
%num_orientations - number of edge mask orientations
%
%outputs:
%msk1 - gestalt mask with centre at theta0
%msk2 - gestalt mask with centre at theta0 + pi
%
%Original by Alexander Russell and Stefan Mihalas, Johns Hopkins University , 2010
%Modified by Brian Hu, Johns Hopkins University, 2017

% %initialize variables
B =  R0;
if dim2(1) == min(dim2)
    dim2 = fliplr(dim2);
end

%make grid
[X,Y] = meshgrid(dim1,dim2);

%convert to polar coordinates
R = sqrt(X.^2+Y.^2);
theta = atan2(Y,X);

%make masks
msk1 =exp(B.*cos(theta-(theta0)))./besseli(0,R-R0);
msk1(R==0) = 0; % added by bh
msk1 = msk1./max(max(msk1));

msk2 = exp(B.*cos(theta-(theta0+pi)))./besseli(0,R-R0);
msk2(R==0) = 0; % added by bh
msk2 = msk2./max(max(msk2));

% added by bh to avoid overlapping RFs
msk1_final = msk1.*((msk1 - msk2) > eps);
msk2_final = msk2.*((msk2 - msk1) > eps);

end