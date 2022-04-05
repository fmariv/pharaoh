# docker image containing all tools in order to transform a GeoTIFF into a PNG terrain tileset
FROM osgeo/gdal:ubuntu-small-latest

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
## install pip3 and Mapbox's RasterIO (rio)
## install rio and a working rio-rgbify build that fixes the issue https://github.com/mapbox/rio-rgbify/issues/14
RUN apt-get -y update && apt-get install -y python3-pip && apt-get install -y git \
    && pip3 install rasterio \
    && pip3 install https://github.com/mapbox/rio-rgbify/archive/sgillies-patch-1.zip \
    && apt-get clean
