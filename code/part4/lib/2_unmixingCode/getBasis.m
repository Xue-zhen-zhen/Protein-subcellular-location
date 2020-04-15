function W = getBasis( idx, datadir)
% W = GETBASIS( IDX)
% inputs:   IDX is the antibody id for a particular protein (default 1873)
% outputs:  W is the color basis matrix
% 
% Saves W to ./lib/2_imageProcessCode.
% 
% Created by Justin Newberg
% Last modified on 23 October 2007 by Justin Newberg

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

if ~exist('datadir','var')
	datadir = './data/1_images';
end

tissuedir = [datadir '/' num2str(idx) '/'];

if ~exist( tissuedir,'dir')
    error('no antibody id');
end

d2 = dir(tissuedir);
d2(1:2) = [];

count = 1;
for j=1:length(d2)
    disp(j);
    imgdir = [tissuedir '/' d2(j).name];

    d3 = dir(imgdir);
    d3(1:2) = [];

    for k=1:length(d3)
        infile = [imgdir '/' d3(k).name];
        I = imread( infile);
        counter = 1;
        eval('[W] = colorbasis( I);','counter = 0;');
        if counter
            Wbasis{count} = W;
            count = count + 1;
        end
    end
end


W = zeros(size(Wbasis{1}));
for i=1:length(Wbasis)
    W = W + Wbasis{i};
end

return



function W = colorbasis( I, STOPCONN, A_THR, S_THR)
%% Methods for getting W are slightly more clearly defined in decomptissue.m.

rank = 2;  ITER = 5000;

tic;

if ~exist('STOPCONN','var')
    STOPCONN = 40;
end
if ~exist('A_THR','var')
    A_THR = 1000;
end
if ~exist('S_THR','var')
    S_THR = 1000;
end

I = 255 - I;
IMGSIZE = size(I);

% ....tissue size check!
if (IMGSIZE(1)<S_THR) || (IMGSIZE(2)<S_THR)
	error('Not enough useable tissue staining');
end


% ********** SEED COLORS ************
S = size(I);
V = reshape( I, S(1)*S(2),S(3));
[V ind VIDX] = unique(V,'rows');
VIDX = single(VIDX);

HSV = rgb2hsv( V);
hue = HSV(:,1);
[c b] = hist( hue(hue<0.3), [0:0.01:1]);
[A i] = max(c);
P = b(i);
hae = mean(V(P-.01<hue & hue<P+0.01,:),1)';

[c b] = hist( hue(hue>=0.3), [0:0.01:1]);
[A i] = max(c);
P = b(i);
dab = mean(V(P-.01<hue & hue<P+0.01,:),1)';

W = single( [hae dab] / 255);

