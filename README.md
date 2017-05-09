InSAR Velocities
================

Author: Ryan Cassotto

## Velocity magnitudes

Velocities (m / day) are provided as magnitudes in GeoTIFF format with WGS84 UTM Zone 6N coordinates. Files have names like:

`./GeoTIFFs/Columbia_speed_YYYYMMDD_HHMM_VtrueFilt.tif`

where the date and time, in format `YYYYMMDD_HHMM` is the median (in UTC) of the measurement interval. Although radar images were collected every 3 minutes, they were stacked in ~15 minute intervals to reduce noise.

The GeoTIFFs have 10 m post spacing (tri-scattered interpolated from the raw data). However, the radar used had a range resolution of 75 cm and azimuth resolution of 8 m per 1 km (so ~40 m on the glacier).

## Velocity directions

`./Alpha_TrueFlowAngles.mat`
Matlab data file containing the average velocity directions over the observation period (used to convert the original line-of-sight velocities to horizontal velocities). `AlphaCorr.angles` are degrees counterclockwise from east (+x UTM axis) and referenced to the lower left hand corner of the image. These were measured by speckle tracking of the radar intensity images.

`./Alpha_TrueFlowAngles.png`
Velocity directions superimposed on a radar intensity image.

Velocity components are calculated from the flow direction `alpha` and velocity magnitude `V` as follows:

```
Vx = V * cos(alpha)
Vy = V * sin(alpha)
```

## Radar metadata

Radar position (WGS84), from the radar raw image parameter file:

| Latitude (°) | Longitude (°) | Ellipsoidal height (m) |
| --- | --- | --- | --- | --- |
| 61.11993000 | -147.04345667 | 398.90000 |
