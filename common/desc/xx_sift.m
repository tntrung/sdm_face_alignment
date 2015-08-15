% Signature: 
%   X = xx_sift(im,lms,'nsb',nsb,'winsize',winsize)
%
% Dependence:
%   None
%
% Usage:
%   This function implements an approximation of SIFT descriptors. It
%   extracts descriptors on the local patches around each landmarks. This
%   is the fastest SIFT descriptor implementation available. 
%
% Params:
%   im - input image (must be in double grayscale)
%   lms(nx2) - input landmark (must be in double) 
%   nsb(option) - the number of spatial bins, default 4
%   winsize(option) - patch size, default 32 
%
% Return:
%   X - computed descriptors in single, default size: 128 x n
% 
% Authors: 
%   Xuehan Xiong, xiong828@gmail.com
%
% Citation: 
%   Xuehan Xiong, Fernando de la Torre, Supervised Descent Method and Its
%   Application to Face Alignment. CVPR, 2013
%
% Creation Date: 10/7/2013
%