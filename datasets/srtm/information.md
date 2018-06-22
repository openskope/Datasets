The following was provided in the readme.txt.

## PROCESSED SRTM DATA VERSION 4.1

The data  distributed here  are in  ARC GRID,  ARC ASCII  and Geotiff format, in
decimal degrees and datum WGS84.  They are derived from the USGS/NASA SRTM data.
CIAT  have  processed  this  data  to  provide  seamless  continuous  topography
surfaces.  Areas with  regions of no  data in the  original SRTM data  have been
filled using interpolation methods described by Reuter et al. (2007).

Version 4.1 has the following enhancements over V4.0:
- Improved ocean mask used, which includes some small islands  previously  being 
  lost in the cut data.
- Single no-data line of pixels along meridians fixed.
- All GeoTiffs with 6000 x 6000 pixels.
- For ASCII format files the projection definition is included in .prj files.
- For GeoTiff format files the projection definition is in the .tfw  (ESRI TIFF 
  World) and a .hdr file that reports PROJ.4 equivelent projection definitions.

## NO WARRANTY OR LIABILITY

CIAT provides  these data  without any  warranty of  any kind whatsoever, either
express or implied,  including warranties of  merchantability and fitness  for a
particular purpose. CIAT shall not  be liable for incidental, consequential,  or
special damages arising out of the use of any data.

## ACKNOWLEDGMENT AND CITATION

Jarvis A., H.I. Reuter, A.  Nelson, E. Guevara, 2008, Hole-filled  seamless SRTM
data V4, International  Centre for Tropical  Agriculture (CIAT), available  from
http://srtm.csi.cgiar.org.

## REFERENCES

Reuter  H.I,  A.  Nelson,  A.  Jarvis,  2007,  An  evaluation  of  void  filling
interpolation  methods  for  SRTM  data,  International  Journal  of  Geographic
Information Science, 21:9, 983-1008.
