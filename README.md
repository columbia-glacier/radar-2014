Radar Velocities (2014)
=======================
*by Ryan Cassotto*

<span style="background-color: #FFFF00">This is a metadata-only repository. Data are available directly from the original author.</span>

## Speed

Glacier speeds (m / day) are provided in GeoTIFF format with WGS84 UTM Zone 6N coordinates:

`data/speed_YYYYMMDDHHMM.tif`

where the date and time, in format `YYYYMMDDHHMM`, is the median (in UTC) of the measurement interval. Although radar images were collected every 3 minutes, they were stacked in ~15 minute intervals to reduce noise.

The data have a 10 m post spacing (tri-scattered interpolated from the raw data). However, the radar used had a range resolution of 75 cm and azimuth resolution of 8 m per 1 km (so ~40 m on the glacier).

## Direction

The directions of motion are provided, in the same raster format, as radians counterclockwise from east (+x UTM axis):

`data/direction.tif`

These were determined by speckle tracking of the beginning and end radar intensity images, and thus represent an average over the observation period. Velocity components can be calculated as:

```
Vx = speed * cos(direction)
Vy = speed * sin(direction)
```

## Radar metadata

Radar position (WGS84), from the radar raw image parameter file:

| Latitude (°) | Longitude (°) | Ellipsoidal height (m) |
| --- | --- | --- | --- | --- |
| 61.11993000 | -147.04345667 | 398.90000 |
