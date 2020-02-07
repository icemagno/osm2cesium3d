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

# java -jar /opt/gazetteer/gazetteer.jar --data-dir /opt/data split /opt/data/map.osm

# OU

# osmconvert /opt/data/sudeste-latest.osm.pbf -o=/opt/data/map2.osm
# java -jar /opt/gazetteer/gazetteer.jar --data-dir /opt/data split /opt/data/map2.osm

# usage: gazetter tile-buildings [-h] [--drop [DROP [DROP ...]]] [--disk-index] [--out-dir OUT_DIR] [--level LEVEL]
# java -jar /opt/gazetteer/gazetteer.jar tile-buildings --data-dir /opt/data --out-dir /opt/data/osm-tiles --level 12


# python /opt/scripts/convert_parallel.py /opt/data/osm-tiles
# python /opt/scripts/tileset_of_tilesets.py /opt/data/obj-tiles/



# cd /opt/OSM2World
# ./osm2world.sh -i /opt/data/osm-tiles/12/1553/2314.osm -o /opt/data/obj-tiles/dummy.obj

