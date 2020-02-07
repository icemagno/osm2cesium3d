FROM library/ubuntu:16.04
MAINTAINER Dmitry Kiselev <dmitry@endpoint.com>

ENV LANG C.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    tar \
    ant \
    vim \
    nano \
    parallel \
	openjdk-8-jdk \
    osmctools && \
  rm -rf /var/lib/apt/lists/*


# Install Node js
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - ;\
    apt-get install -y nodejs

WORKDIR /opt

RUN wget https://github.com/AnalyticalGraphicsInc/3d-tiles-tools/archive/master.zip && \
    unzip master.zip && \
    mv 3d-tiles-tools-master 3d-tiles-tools && \
    cd 3d-tiles-tools/tools && \
    npm install && \
    rm /opt/master.zip && \
    cd /opt

RUN wget https://github.com/AnalyticalGraphicsInc/obj2gltf/archive/master.zip && \
    unzip master.zip && \
    mv obj2gltf-master obj2gltf && \
    cd obj2gltf && \
    npm install && \
    rm /opt/master.zip && \
    cd /opt

	
# Install OSM2World
RUN mkdir /opt/OSM2World && mkdir /opt/OSM2World-release && \
    wget https://github.com/kiselev-dv/OSM2World/archive/tiled_out.zip && \
    unzip tiled_out.zip && \
    mv OSM2World-tiled_out/* OSM2World/ && \
    rm tiled_out.zip && \
    cd /opt/OSM2World && \
    ant release && \
    unzip /opt/OSM2World/build/OSM2World-noversion-bin.zip -d /opt/OSM2World-release && \
    cd /opt && \
    rm -rf /opt/OSM2World/ && \
    rm -rf OSM2World-tiled_out && \
    mv /opt/OSM2World-release /opt/OSM2World

RUN mkdir /opt/gazetteer && \
    mkdir /opt/data && \
	mkdir /opt/tmp && \
	mkdir /opt/data/obj-tiles && \
	mkdir /opt/data/osm-tiles && \
    wget https://github.com/kiselev-dv/gazetteer/releases/download/Gazetteer-1.9rc4/gazetteer.jar -O /opt/gazetteer/gazetteer.jar

RUN cd /opt/3d-tiles-tools/tools/ && \
    npm install --save sqlite3 && \
    npm install --save cesium && \
	npm install --save bluebird && \
	npm update --save/--save-dev
	
	
COPY scripts /opt/scripts

WORKDIR /opt/OSM2World

CMD [/bin/bash]

 