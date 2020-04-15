function H = findH( V, W)
% H = FINDH( V, W) linearly unmixes a set of N m-dimensional samples (Nxm matrix) %���Է���N��mά������
%   inputs: V, the original samples   %Vԭʼ����
%           W the color basis matrix, m-dimensioanl, r=rank (mxr)
%
%   outputs: H, the unmixed weight channels %H��������ͨ��
% 


% H = pinv(single(W))*single(V');
H = single(V)*pinv(single(W))';%pinvΪ����һ����ͬά���ľ������������WΪ����
H = H - min(H(:));
H = H / max(H(:))*255;
H = uint8(round(H));
