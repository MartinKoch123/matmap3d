% Test run a scalar self-test of the Matlab/ Octave 3-D coordinate conversion functions

if matmap3d.isoctave()
  pkg('load', 'tablicious')
end
% reference inputs
az = 33; el=70;
lat = 42; lon= -82;
t0 = datetime(2014,4,6,8,0,0);
% reference outputs
lat1 = 42.0026; lon1 = -81.9978;

alt1 = 1.1397e3; % aer2geodetic
alt = 200; srange = 1e3;
er = 186.277521; nr = 286.84222; ur = 939.69262; % aer2enu
xl = 6.609301927610815e+5; yl = -4.701424222957011e6; zl = 4.246579604632881e+06; % aer2ecef
x0 = 660.6752518e3; y0 = -4700.9486832e3; z0 = 4245.7376622e3; % geodetic2ecef, ecef2geodetic

atol_dist = 1e-3;  % 1 mm

E = matmap3d.wgs84Ellipsoid();
ea = E.SemimajorAxis;
eb = E.SemiminorAxis;

angleUnit='d';
a90 = 90;

%% geodetic2ecef
[x,y,z] = matmap3d.geodetic2ecef(E,lat,lon,alt, angleUnit);
matmap3d.tests.assert_allclose([x,y,z],[x0,y0,z0])

[x,y,z] = matmap3d.geodetic2ecef(lat,lon,alt, angleUnit); % simple input
matmap3d.tests.assert_allclose([x,y,z],[x0,y0,z0])

[x,y,z] = matmap3d.geodetic2ecef(0,0,-1);
matmap3d.tests.assert_allclose([x,y,z], [ea-1,0,0])

[x,y,z] = matmap3d.geodetic2ecef(0,90,-1);
matmap3d.tests.assert_allclose([x,y,z], [0,ea-1,0])

[x,y,z] = matmap3d.geodetic2ecef(0,-90,-1);
matmap3d.tests.assert_allclose([x,y,z], [0,-ea+1,0])

[x,y,z] = matmap3d.geodetic2ecef(90,0,-1);
matmap3d.tests.assert_allclose([x,y,z], [0,0,eb-1])

[x,y,z] = matmap3d.geodetic2ecef(90,15,-1);
matmap3d.tests.assert_allclose([x,y,z], [0,0,eb-1])

[x,y,z] = matmap3d.geodetic2ecef(-90,0,-1);
matmap3d.tests.assert_allclose([x,y,z], [0,0,-eb+1])

%% ecef2geodetic
[lt, ln, at] = matmap3d.ecef2geodetic(E, x0, y0, z0, angleUnit);
matmap3d.tests.assert_allclose([lt, ln, at], [lat, lon, alt])

[lt, ln, at] = matmap3d.ecef2geodetic(x0, y0, z0, angleUnit); % simple input
matmap3d.tests.assert_allclose([lt, ln, at], [lat, lon, alt])

[lt, ln, at] = matmap3d.ecef2geodetic(ea-1, 0, 0);
matmap3d.tests.assert_allclose([lt, ln, at], [0, 0, -1])

[lt, ln, at] = matmap3d.ecef2geodetic(0, ea-1, 0);
matmap3d.tests.assert_allclose([lt, ln, at], [0, 90, -1])

[lt, ln, at] = matmap3d.ecef2geodetic(0, 0, eb-1);
matmap3d.tests.assert_allclose([lt, ln, at], [90, 0, -1])

[lt, ln, at] = matmap3d.ecef2geodetic(0, 0, -eb+1);
matmap3d.tests.assert_allclose([lt, ln, at], [-90, 0, -1])

[lt, ln, at] = matmap3d.ecef2geodetic(-ea+1, 0, 0);
matmap3d.tests.assert_allclose([lt, ln, at], [0, 180, -1])

[lt, ln, at] = matmap3d.ecef2geodetic((ea-1000)/sqrt(2), (ea-1000)/sqrt(2), 0);
matmap3d.tests.assert_allclose([lt,ln,at], [0,45,-1000])

%% enu2aer, aer2ecef
[a, e, r] = matmap3d.enu2aer(er, nr, ur, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [az,el,srange])

[a, e, r] = matmap3d.enu2aer(1, 0, 0, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [a90, 0, 1])

[e,n,u] = matmap3d.aer2enu(az, el, srange, angleUnit);
matmap3d.tests.assert_allclose([e,n,u], [er,nr,ur])

[a,e,r] = matmap3d.enu2aer(e,n,u, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [az,el,srange])

%% ecef2aer
[a, e, r] = matmap3d.ecef2aer(xl,yl,zl, lat,lon,alt, E, angleUnit); % round-trip
matmap3d.tests.assert_allclose([a,e,r], [az,el,srange])

% singularity check
[a, e, r] = matmap3d.ecef2aer(ea-1, 0, 0, 0,0,0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer(-ea+1, 0, 0, 0, 2*a90,0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer(0, ea-1, 0,0, a90,0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer(0, -ea+1, 0,0, -a90,0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer(0, 0, eb-1, a90, 0, 0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer(0,  0, -eb+1,-a90,0,0, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [0, -a90, 1])

[a, e, r] = matmap3d.ecef2aer((ea-1000)/sqrt(2), (ea-1000)/sqrt(2), 0, 0, 45, 0);
matmap3d.tests.assert_allclose([a,e,r],[0,-90,1000])

[x,y,z] = matmap3d.aer2ecef(az,el,srange,lat,lon,alt,E, angleUnit);
matmap3d.tests.assert_allclose([x,y,z], [xl,yl,zl])

[a,e,r] = matmap3d.ecef2aer(x,y,z, lat, lon, alt, E, angleUnit);
matmap3d.tests.assert_allclose([a,e,r], [az,el,srange])

%% geodetic2aer, aer2geodetic
[lt,ln,at] = matmap3d.aer2geodetic(az,el,srange,lat,lon,alt, E, angleUnit);
matmap3d.tests.assert_allclose([lt,ln,at], [lat1, lon1, alt1],[], 2*atol_dist)

[a, e, r] = matmap3d.geodetic2aer(lt,ln,at,lat,lon,alt, E, angleUnit); % round-trip
matmap3d.tests.assert_allclose([a,e,r], [az,el,srange])

%% geodetic2enu, enu2geodetic
[e, n, u] = matmap3d.geodetic2enu(lat, lon, alt-1, lat, lon, alt, E, angleUnit);
matmap3d.tests.assert_allclose([e,n,u], [0,0,-1])

[lt, ln, at] = matmap3d.enu2geodetic(e,n,u,lat,lon,alt, E, angleUnit); % round-trip
matmap3d.tests.assert_allclose([lt, ln, at],[lat, lon, alt-1])


%% enu2ecef, ecef2enu

[x, y, z] = matmap3d.enu2ecef(er,nr,ur, lat,lon,alt, E, angleUnit);
matmap3d.tests.assert_allclose([x,y,z],[xl,yl,zl])

[e,n,u] = matmap3d.ecef2enu(x,y,z,lat,lon,alt, E, angleUnit); % round-trip
matmap3d.tests.assert_allclose([e,n,u],[er,nr,ur])

%% lookAtSpheroid
az5 = [0., 10., 125.];
tilt = [30, 45, 90];

[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(lat, lon, alt, az5, 0.);
matmap3d.tests.assert_allclose(lat5, lat)
matmap3d.tests.assert_allclose(lon5, lon)
matmap3d.tests.assert_allclose(rng5, alt)


[lat5, lon5, rng5] = matmap3d.lookAtSpheroid(lat, lon, alt, az5, tilt);

truth = [42.00103959, lon, 230.9413173;
         42.00177328, -81.9995808, 282.84715651;
         nan, nan, nan];

matmap3d.tests.assert_allclose([lat5, lon5, rng5], truth, [], [],true)

%% test_time
matmap3d.tests.assert_allclose(matmap3d.juliantime(t0), 2.45675383333e6)

% test values from Matlab docs
%% eci2ecef
utc = datetime(2019, 1, 4, 12,0,0);
eci = [-2981784, 5207055, 3161595];
[x, y, z] = matmap3d.eci2ecef(utc, eci(1), eci(2), eci(3));
matmap3d.tests.assert_allclose([x,y,z], [-5.7627e6, -1.6827e6, 3.1560e6], 0.02)
%% eci2ecef multiple
utc = datetime(2019, 1, 4, 12,0,0);
utc = [utc;utc];
eci = [-2981784, 5207055, 3161595]; eci = [eci; eci];
[x, y, z] = matmap3d.eci2ecef(utc, eci(:,1), eci(:,2), eci(:,3));
matmap3d.tests.assert_allclose([x(1,1), y(1,1), z(1,1)], [-5.7627e6, -1.6827e6, 3.1560e6], 0.02)
matmap3d.tests.assert_allclose([x(2,1), y(2,1), z(2,1)], [-5.7627e6, -1.6827e6, 3.1560e6], 0.02)
%% ecef2eci
ecef = [-5762640, -1682738, 3156028];
utc = datetime(2019, 1, 4, 12,0,0);
[x,y,z] = matmap3d.ecef2eci(utc, ecef(1), ecef(2), ecef(3));
matmap3d.tests.assert_allclose([x,y,z], [-2.9818e6, 5.2070e6, 3.1616e6], 0.01)

%% ecef2eci multiple
ecef = [-5762640, -1682738, 3156028]; ecef = [ecef; ecef];
utc = datetime(2019, 1, 4, 12, 0, 0);
utc = [utc; utc];
[x,y,z] = matmap3d.ecef2eci(utc, ecef(:,1), ecef(:,2), ecef(:,3));
matmap3d.tests.assert_allclose([x(1,1), y(1,1) , z(1,1)], [-2.9818e6, 5.2070e6, 3.1616e6], 0.01)
matmap3d.tests.assert_allclose([x(2,1), y(2,1) , z(2,1)], [-2.9818e6, 5.2070e6, 3.1616e6], 0.01)
%% eci2aer
eci = [-3.8454e8, -0.5099e8, -0.3255e8];
utc = datetime(1969, 7, 20, 21, 17, 40);
lla = [28.4, -80.5, 2.7];
[a, e, r] = matmap3d.eci2aer(utc, eci(1), eci(2), eci(3), lla(1), lla(2), lla(3));
matmap3d.tests.assert_allclose([a, e, r], [162.55, 55.12, 384013940.9], 0.01)

%% aer2eci
aer = [162.55, 55.12, 384013940.9];
lla = [28.4, -80.5, 2.7];
utc = datetime(1969, 7, 20, 21, 17, 40);
[x,y,z] = matmap3d.aer2eci(utc, aer(1), aer(2), aer(3), lla(1), lla(2), lla(3));
matmap3d.tests.assert_allclose([x, y, z], [-3.8454e8, -0.5099e8, -0.3255e8], 0.06)
