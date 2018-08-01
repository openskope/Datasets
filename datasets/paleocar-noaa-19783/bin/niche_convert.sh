#!/bin/bash
# usage: bash xxx_convert.sh file [file [file]]
#
# use 'ncks <filename>' to inspect the netcdf file. The time dimension is
# not uniformly named in paleocar datasets, use "Year" for GDD
# and PPT and "Year AD" for niche.

dst=/projects/skope/datasets/paleocar_2/maize_farming_niche/geoserver2
var="NICHE"

for y in {0..1999}; do
  year=`printf '%04d' $((y+1))`

  rm data/*${var}_????.nc > /dev/null
  for f in $@; do
    ncks -d "Year AD",$y ${f} ${f/.nc/_${year}.nc}
    echo ${f/.nc/_${year}.nc}
  done

  gdal_merge.py -init -32768 -a_nodata -32768 -a_srs EPSG:4326 -o ${dst}/${var}_${year}.tif data/*${var}_????.nc
  rm data/*${var}_????.nc
  echo ${year}   `date`
done
rm data/*${var}_????.nc
