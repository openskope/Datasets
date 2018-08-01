#!/bin/bash
# usage: bash xxx_convert.sh file [file [file]]
#
# use 'ncks <filename>' to inspect the netcdf file. The time dimension is
# not uniformly named in paleocar datasets, use "Year" for GDD 
# and PPT and "Year AD" for niche.

dst=/projects/skope/datasets/paleocar_2/growing_degree_days/geoserver2
var="GDD"

for y in {0..1999}; do
  year=`printf '%04d' $((y+1))`

  rm data/*${var}_????.nc4 > /dev/null
  for f in $@; do
    ncks -d Year,$y ${f} ${f/.nc4/_${year}.nc4}
    echo ${f/.nc4/_${year}.nc4}
  done

  gdal_merge.py -init -32768 -a_nodata -32768 -o ${dst}/${var}_${year}.tif data/*${var}_????.nc4
  echo ${year}   `date`
done
rm data/*${var}_????.nc4
