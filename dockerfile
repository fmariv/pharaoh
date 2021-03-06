FROM osgeo/gdal:ubuntu-small-latest
ENTRYPOINT [ "/bin/bash", "-l", "-c" ]
## install rio and a working rio-rgbify build that fixes the issue https://github.com/mapbox/rio-rgbify/issues/14
RUN apt-get -y update && apt-get install -y python3-pip && apt-get install -y git \
    && pip3 install rasterio \
    && pip3 install rio-mbtiles \
    && pip3 install https://github.com/mapbox/rio-rgbify/archive/sgillies-patch-1.zip \
    && apt-get clean
