#!/bin/bash

: ${OSM_DUMP:=/opt/data/map.osm}
: ${GAZETTEER_JAR:=/opt/gazetteer/gazetteer.jar}
: ${GAZETTEER_DATA_DIR:=/opt/data/}

: ${OSM_TILES:="/opt/data/osm-tiles"}
: ${OBJ_TILES:="/opt/data/obj-tiles"}

: ${OBJGLTF_BIN:="/opt/obj2gltf/bin/obj2gltf.js"}
: ${GLB_BIN:="/opt/3d-tiles-tools/tools/bin/3d-tiles-tools.js"}
: ${OSMW_BIN:="/opt/OSM2World/osm2world.sh"}
: ${OSMW_CONF:="/opt/scripts/prop.properties"}

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OPTIONS="OBJ_TILES=${OBJ_TILES} GLB_BIN=${GLB_BIN} OSMW_BIN=${OSMW_BIN} OSMW_CONF=${OSMW_CONF} OBJGLTF_BIN=${OBJGLTF_BIN}"
TILE_SCRIPT="${OPTIONS} ${DIR}/convert_tile.sh"

cd /opt/data/

TILES_C=$(find ${OSM_TILES} -iname '*.osm' | wc -l)
if [ "$TILES_C" == "0" ]; then
    echo "Generate osm tiles"
    filename=$(basename "$OSM_DUMP")
    extension="${filename##*.}"
    if [ "$extension" == "bz2" ]; then
        bzcat ${OSM_DUMP} | java -Xmx4G -Djava.io.tmpdir=/opt/tmp -jar ${GAZETTEER_JAR} split
    elif [ "$extension" == "osm" ]; then
        java -Xmx4G -Djava.io.tmpdir=/opt/tmp -jar ${GAZETTEER_JAR} split ${OSM_DUMP}
    elif [ "$extension" == "pbf" ]; then
        osmconvert ${OSM_DUMP} | java -Xmx4G -Djava.io.tmpdir=/opt/tmp -jar ${GAZETTEER_JAR} split
    else 
        echo "Unrecognized osm dump file extension $extension"
    fi
	
	
    java -Xmx4G -Djava.io.tmpdir=/opt/tmp -jar ${GAZETTEER_JAR} tile-buildings --out-dir ${OSM_TILES}
	
fi

python ${DIR}/convert_parallel.py ${OSM_TILES}
python ${DIR}/tileset_of_tilesets.py ${OBJ_TILES}

find $OBJ_TILES -type f -iname '*.obj' -delete
find $OBJ_TILES -type f -iname '*.mtl' -delete
find $OBJ_TILES -type f -iname '*.glb' -delete
find $OBJ_TILES -type f -iname '*.properties' -delete


