function [directionality_index, directionality_index_Z] = rayleigh(rate,...
    binnedAngle, angledim)
% 
% sarel.index.goal computes rayleigh vector
%

if nargin < 3
    angledim = 2;
end
if angledim == -1
    angledim = ndims(rate);
end
n = size(rate, angledim);

% Reshape the angle bins
binnedAngle    = shiftdim(binnedAngle(:), -(angledim-1));
assert(n == size(binnedAngle, angledim));

% Calculate rayleigh score
correction_for_binning = pi/sin(pi/n);
numerator              = abs(sum(rate .* exp(1i .* 2*pi .* binnedAngle), angledim));
denominator            = sum(rate, angledim);
directionality_index   = correction_for_binning * (numerator./denominator);
directionality_index_Z = directionality_index.^2 / n; % TODO is this CORRECT?

szOuterDims = setdiff(1:ndims(rate), angledim);
szOuterDims = [size(rate, szOuterDims), 1]; % 1 at the end to guarentee at least 2d for reshape

unravel  = @(x) reshape(x, szOuterDims);
directionality_index   = unravel(directionality_index(:));
directionality_index_Z = unravel(directionality_index_Z(:));

