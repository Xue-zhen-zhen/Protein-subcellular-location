function processImage( readpath, writepath, Wpath, params)
% PROCESSIMAGE( READPATH, WRITEPATH, PARAMS)

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


if exist( writepath, 'file')
    if exist( Wpath, 'file')
    return
    end
end

prp = writepath;
prp((prp == '/') | (prp == '.') | (prp ==':')|(prp =='\')) = '_';
pr = ['tmp/processing_' prp '.txt'];
if ~exist( pr,'file')
    fr = fopen( pr, 'w');
else
    return
end

% Always perform linear unmixing...
I = imread( readpath);
W = params.W;

s = size(I);
[V i j] = unique( 255-reshape( I, [s(1)*s(2) s(3)]), 'rows');
V = unique(V,'rows');

% LIN
H = findH( V, W);

% ...Note images without enough staining
% J = reconIH( I, H, j);
% [c b] = imhist(J(:,:,1));
% [a ind] = max(c);
% J(:,:,1) = J(:,:,1) - b(ind);
% [c b2] = imhist(J(:,:,2));
% [a ind2] = max(c);
% J(:,:,2) = J(:,:,2) - b2(ind2);
% ratio = sum(sum(J(:,:,2))) / sum(sum(J(:,:,1)));
% 
% if ratio<.5
%     imwrite( 0, writepath, 'comment', readpath);
%     fclose(fr);
%     delete(pr);
%     return
% end

if strcmp( params.UMETHOD,'nmf')
    [W,H] = findWH( V, params);
    J = reconIH( I, H, j);    %È¥µôÁË%
end

imwrite( H, writepath, 'comment', readpath);
save(Wpath,'W');

fclose(fr);
delete(pr);

return
