function H = findH( V, W)
% H = FINDH( V, W) linearly unmixes a set of N m-dimensional samples (Nxm matrix) %���Է���N��mά������
%   inputs: V, the original samples   %Vԭʼ����
%           W the color basis matrix, m-dimensioanl, r=rank (mxr)
%
%   outputs: H, the unmixed weight channels %H��������ͨ��
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

% H = pinv(single(W))*single(V');
H = single(V)*pinv(single(W))';%pinvΪ����һ����ͬά���ľ������������WΪ����
H = H - min(H(:));
H = H / max(H(:))*255;
H = uint8(round(H));
