%% referenceEllipsoid   Select available ellipsoid
%
%%% inputs
% * name: string of model name. Default: 'wgs84'
%%% outputs
% * E: referenceEllipsoid

classdef referenceEllipsoid
properties
  Code
  Name
  LengthUnit
  SemimajorAxis
  Flattening
  SemiminorAxis
  Eccentricity
  MeanRadius
  Volume
end

methods
function e = referenceEllipsoid(name, lengthUnit)
arguments
  name (1,1) string = "wgs84"
  lengthUnit (1,1) string = "m"
end

mustBeMember(lengthUnit, ["m", "meters"])

switch name
case 'wgs84'
%% WGS-84 ellipsoid parameters.
% <http://earth-info.nga.mil/GandG/tr8350_2.html>
% <ftp://164.214.2.65/pub/gig/tr8350.2/wgs84fin.pdf>
  e.Code = 7030;
  e.Name = 'World Geodetic System 1984';
  e.LengthUnit = 'meter';
  e.SemimajorAxis = 6378137.0;
  e.Flattening = 1/298.2572235630;
  e.SemiminorAxis = e.SemimajorAxis * (1 - e.Flattening);
  e.Eccentricity = get_eccentricity(e);
  e.MeanRadius = meanradius(e);
  e.Volume = spheroidvolume(e);
case 'grs80'
%% GRS-80 ellipsoid parameters
% <http://itrf.ensg.ign.fr/faq.php?type=answer> (accessed 2018-01-22)
  e.Code = 7019;
  e.Name = 'Geodetic Reference System 1980';
  e.LengthUnit = 'meter';
  e.SemimajorAxis = 6378137.0;
  e.Flattening = 1/298.257222100882711243;
  e.SemiminorAxis = e.SemimajorAxis * (1 - e.Flattening);
  e.Eccentricity  = get_eccentricity(e);
  e.MeanRadius = meanradius(e);
  e.Volume = spheroidvolume(e);
otherwise, error(name + " not yet implemented")
end
end

function v = spheroidvolume(E)
v = 4*pi/3 * E.SemimajorAxis^2 * E.SemiminorAxis;

assert(v>=0)
end

function r = meanradius(E)
r = (2*E.SemimajorAxis + E.SemiminorAxis) / 3;

assert(r>=0)
end

function ecc = get_eccentricity(E)
ecc = sqrt ( (E.SemimajorAxis^2 - E.SemiminorAxis^2) / (E.SemimajorAxis^2));
end

end
end



%%
% Copyright (c) 2014-2018 SciVision, Inc.
% Copyright (c) 2013, Felipe Geremia Nievinski
%
% Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
