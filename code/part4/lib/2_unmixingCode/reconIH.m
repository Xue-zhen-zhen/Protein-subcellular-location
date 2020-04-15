function [J,ma] = reconIH( I,H,IDX,sc)
% J = RECONIH( I, H) reconstruct an NMF unmixed image
%   Takes as input I, the image to be unmixed, and H, the sorted pixel-weight channels.
%   Returns J, the unmixed image. Should be called after findWH.m
% 
% Justin Newberg

% Copyright (C) 2006  Murphy Lab
% Carnegie Mellon University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published
% by the Free Software Foundation; either version 2 of the License,
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA.
%
% For additional information visit http://murphylab.web.cmu.edu or
% send email to murphy@cmu.edu

if ~exist( 'IDX','var')
    IDX = [];
end
if ~exist( 'sc','var')
    sc = 0;
end

ma = [];

s = size(I);

if ~length(IDX)
    [u i IDX] = unique( 255-reshape( I, [s(1)*s(2) s(3)]), 'rows');
end

J = H(IDX,:);
if sc
    ma = zeros(size(H,2),1);
    for i=1:size(H,2)
        [c b] = imhist(J(:,i));
        [a ind] = max(c);
        J(:,i) = J(:,i)-b(ind);
        ma(i) = max(J(:,i));
    end
    J = (255/max(J(:)))*J;
end

J = reshape( J, [s(1) s(2) size(H,2)]);

if size(H,2)<3
    J(:,:,3) = 0;
end

