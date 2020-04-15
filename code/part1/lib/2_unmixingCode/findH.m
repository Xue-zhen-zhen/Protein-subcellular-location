function H = findH( V, W)
% H = FINDH( V, W) linearly unmixes a set of N m-dimensional samples (Nxm matrix) %线性分离N个m维样本集
%   inputs: V, the original samples   %V原始样本
%           W the color basis matrix, m-dimensioanl, r=rank (mxr)
%
%   outputs: H, the unmixed weight channels %H分离重量通道
% 


% H = pinv(single(W))*single(V');
H = single(V)*pinv(single(W))';%pinv为产生一个相同维数的矩阵，这个矩阵与W为共轭
H = H - min(H(:));
H = H / max(H(:))*255;
H = uint8(round(H));
