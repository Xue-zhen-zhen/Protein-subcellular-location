function calculateFeatures(readpath, writepath, dbtype, NLEVELS,feattype)
% CALCULATEFEATURES( READPATH, WRITEPATH, DBTYPE, NLEVELS)

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
if strcmp(feattype,'SLFs_LBPs')
   if exist( writepath,'file')
       load(writepath);
       if length(features)==1097
          return
       end
   end
  prp = writepath;
  prp((prp == '/') | (prp == '.')|(prp==':') | (prp =='\')) = '_';
  pr = ['tmp/calculating_' prp '.txt'];
  if ~exist( pr,'file')
      fr = fopen( pr, 'w');
  else
      return
  end

 I = imfinfo( readpath);

 H = imread( readpath);
 J = reconIH( imread(I.Comment), H);

 features = tissueFeatures( J(:,:,2), J(:,:,1), dbtype, NLEVELS,feattype);

 save( writepath, 'features');

 fclose(fr);
 delete(pr);
end

if strcmp(feattype,'SLFs')
   if exist( writepath,'file')
       load(writepath);
       if length(features)==841
           return
       end
   end
  prp = writepath;
  prp((prp == '/') | (prp == '.')|(prp==':') | (prp =='\')) = '_';
  pr = ['tmp/calculating_' prp '.txt'];
  if ~exist( pr,'file')
     fr = fopen( pr, 'w');
  else
     return
  end

  I = imfinfo( readpath);

  H = imread( readpath);
  J = reconIH( imread(I.Comment), H);

  features = tissueFeatures( J(:,:,2), J(:,:,1), dbtype, NLEVELS,feattype);

  save( writepath, 'features');

  fclose(fr);
  delete(pr);
end
           

