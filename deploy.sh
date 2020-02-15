#! /bin/sh


docker ps -a | awk '{ print $1,$2 }' | grep magnoabreu/osmtiles:1.0 | awk '{print $1 }' | xargs -I {} docker rm -f {}
docker rmi magnoabreu/osmtiles:1.0

docker build --tag=magnoabreu/osmtiles:1.0 --rm=true .

mkdir /srv/osmtiles/
cp map.osm /srv/osmtiles/

docker run --name osmtiles --hostname=osmtiles \
-v /etc/localtime:/etc/localtime:ro \
-v /srv/osmtiles/:/opt/data/ \
-v /srv/srtm/:/srtm/ \
-it magnoabreu/osmtiles:1.0 /bin/bash

# https://github.com/kiselev-dv/osm-cesium-3d-tiles

# java -Xmx1G -jar /opt/gazetteer/gazetteer.jar --threads 4 --data-dir /opt/data split /opt/data/map.osm

# OU

# osmconvert /opt/data/sudeste-latest.osm.pbf -o=/opt/data/map2.osm
# java -Xmx4G -jar /opt/gazetteer/gazetteer.jar --threads 2 --data-dir /opt/data split /opt/data/map2.osm

# usage: gazetter tile-buildings [-h] [--drop [DROP [DROP ...]]] [--disk-index] [--out-dir OUT_DIR] [--level LEVEL]
# java -Xmx1024m -XX:+UseParallelGC -jar /opt/gazetteer/gazetteer.jar --threads 2 tile-buildings --out-dir /opt/data/osm-tiles --level 14java -Xmx300m -XX:+UseParallelGC -jar /opt/gazetteer/gazetteer.jar --threads 4 tile-buildings --out-dir /opt/data/osm-tiles --level 14


# python /opt/scripts/convert_parallel.py /opt/data/osm-tiles
# python /opt/scripts/tileset_of_tilesets.py /opt/data/obj-tiles/



# cd /opt/OSM2World
# ./osm2world.sh -i /opt/data/osm-tiles/12/1553/2314.osm -o /opt/data/obj-tiles/dummy.obj

#  find . -size 0 -print | wc -l
#  du -shc osm-tiles/*