function [C,U,D,W] = conmatrix( truelabels,predlabels)
% [CMAT ACC WCMAT WACC] = CONFMAT( TRUELABELS, PREDLABELS)
%    calculates the confusion matrix. CMAT is the matrix, 
%    ACC is the classification accuracy, WCMAT is the 
%    weighted confusion matrix, and WACC is the weighted 
%    classification accuracy.
% 
% Last modified Justin Newberg 23 October 2007

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

MI = 1;
MA = max(truelabels);
C = zeros(MA,MA);
for i=1:MA
	idx = find( truelabels==i);
	[c b] = hist( predlabels( idx), [MI:1:MA]);
	C(i,:) = c;
end

U = sum( reshape( (eye(MA,MA).*C), [MA*MA 1])) / sum(C(:));

D = C./repmat( sum(C,2), [1 MA]);

D(isnan(D))=0;
W = sum(sum(eye(MA).*D)) / (MA-sum(isnan(sum(D,2))));
