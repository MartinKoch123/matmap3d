function [u, v, w] = enu2ecefv(east, north, up, lat0, lon0, angleUnit)
%% enu2ecef  convert from ENU to ECEF coordinates
%
%%% Inputs
% * e,n,u:  East, North, Up coordinates of point(s) (meters)
% * lat0,lon0: geodetic coordinates of observer/reference point (degrees)
% * angleUnit: string for angular units. Default 'd': degrees
%
%%% outputs
% * u,v,w:   coordinates of test point(s) (meters)
arguments
  east {mustBeNumeric,mustBeReal}
  north {mustBeNumeric,mustBeReal}
  up {mustBeNumeric,mustBeReal}
  lat0 {mustBeNumeric,mustBeReal}
  lon0 {mustBeNumeric,mustBeReal}
  angleUnit (1,1) string = "d"
end


if startsWith(angleUnit,'d')
  lat0 = deg2rad(lat0);
  lon0 = deg2rad(lon0);
end

t = cos(lat0) .* up - sin(lat0) .* north;
w = sin(lat0) .* up + cos(lat0) .* north;

u = cos(lon0) .* t - sin(lon0) .* east;
v = sin(lon0) .* t + cos(lon0) .* east;

end
%%
% Copyright (c) 2014-2018 Michael Hirsch, Ph.D.
% Copyright (c) 2013, Felipe Geremia Nievinski
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
