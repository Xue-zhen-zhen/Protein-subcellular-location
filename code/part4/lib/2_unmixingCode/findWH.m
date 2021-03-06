function [W,H] = findWH( V, inputs)
% OUTPUT = FINDWH(V,OPTIONS)
% inputs:   V is the sample matrix (nsamples x 3 original channels, R G B)
%           OPTIONS is a structure containins the following attributes:
%                  .INIT: the color-bases matrix for linear unmixing
%                  ('none','truncated','hue')
%
% outputs:  OUTPUT is a structure containing the processed data
%           OUTPUT.W is color bases matrix
%           OUTPUT.Hl is the linearly unmixed weightings
%           OUTPUT.Hn is the NMF unmixed weightings
%
% NMF code uses connectivity, modified from NMF code by the Broad Institute:
%   http://www.broad.mit.edu/mpr/publications/projects/NMF/nmf.m
%
% The NMF algorithm is defined in:
%   Learning the parts of objects with nonnegative matrix factorization. D. D. Lee and H. S. Seung, Nature 401, 788 (1999).
%
% The linear unmixing is described at:
%   http://home.planet.nl/~ber03728/4N6site/improc/decoplugin/decoexpl/p01.htm
%
% This code was created by Justin Newberg
% Last modified 24 October 2007 by Justin Newberg

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

S = size(V);

options.ITER = 5000;             % Number of nmf iterations
options.INIT = 'truncated';      % Pseudo-random W initialization
options.RANK = 2;                % Number of stains to be unmixed. FIX FOR LIN UNMIX
options.STOPCONN = 40;           % Another termination criteria for nmf
options.VERBOSE = 1;             % Verbose mode
options.RSEED = 13;

rand('seed',options.RSEED);

checker.options = fieldnames(options);
if exist('inputs','var')
    checker.inputs = fieldnames(inputs);
    for i=1:length(checker.inputs)
        checker.type = checker.inputs{i};
        checker.value = getfield( inputs,checker.inputs{i});
        options = setfield( options, checker.type, checker.value);
    end
end

if options.VERBOSE
    tic;
end

if strcmp( options.INIT,'hue')
    HSV = rgb2hsv( V);
    hue = smooth(HSV(:,1),30);
    [c b] = hist( hue(hue<0.3), [0:0.01:1]);
    [A i] = max(c);
    P = b(i);
    hae = mean(V(P-.01<hue & hue<P+0.01,:),1)';

    [c b] = hist( hue(hue>=0.3), [0:0.01:1]);
    [A i] = max(c);
    P = b(i);
    dab = mean(V(P-.01<hue & hue<P+0.01,:),1)';

    W = single( [hae dab] / 255);
else
    W = single( rand(S(2),options.RANK));
end
if strcmp( options.INIT,'truncated')
    W = W / 2 + .25;
end

% Continuing image transform
V = single(V')/255;
V(V==0) = 1e-9;
[r,c] = size(V);

% Blind umixing
H = single( rand( options.RANK,c));

conn = zeros(r,r);
connold = conn;
inc=0;

for k=1:options.ITER
    W = W / norm(W);

    WH = W*H;

    % Minimizing L2 distance
    %Hn = H.*((W'*V) ./ (W'*WH));
    H = H.*((W'*V) ./ (W'*WH));
    WH = W*H;
    W  = (W.*((V*H') ./ (WH*H')));

    % % Minimizing divergence
    % VWH = V./WH;
    % Hn = H.*(W'*VWH) ./ repmat( sum(W,1)',[1 c]);
    % W  = W.*(VWH*H') ./ repmat( sum(H,2)', [r 1]);

    %H = Hn;

    % Below is the Broad connectivity criterion
    if mod( k,10)==0
        [y,i] = max(W,[],2);
        mat1 = repmat( i,1,r);
        mat2 = repmat( i',r,1);
        conn=(mat1==mat2);

        if sum(conn(:)~=connold(:))
            inc=0;
        else
            inc=inc+1;
        end
        connold=conn;

        if inc>options.STOPCONN
            break;
        end

        Err = sum((V(:) - WH(:)).^2)/(r*c);
        if options.VERBOSE
            disp( num2str([toc k inc Err max(W(:)) max(H(:))]));
        end
    end
end

H=H-min(H(:));
H=H/max(H(:));
hsv = rgb2hsv(uint8(W'));
H=uint8(round(H*255));
W=uint8(round(W*255));

if options.RANK==2
    if hsv(1,1)>hsv(2,1)
        W = W(:, [2 1]);
        H = H([2 1],:);
    end
end

H = H';

if options.VERBOSE
    t = toc;
    t = num2str(t);
    disp([ 'Finished NMF: ' t]);
    tic;
end

