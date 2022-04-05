# ContextMaps terrain RGB

Tool that converts a geo-tiff file containing Digital Elevation Model (DEM) data into a pyramid of png files.

## Usage

Build the container

```shell
docker build -t rio .
```

Start the docker container and mount a local folder ```/path/to/our/folder``` 
with the  GeoTIFF inside to the folder ```/opt/dem``` within the container's filesystem. ```rio``` is the
 name of the image and we want to execute the shell ```bash``` inside the container.

```shell
docker run --rm -it -v /path/to/our/folder:/opt/dem rio bash
```

Generate the tile pyramid within zooms 6 and 8

```shell
rio rgbify --min-z 6 --max-z 8 input.tif output.mbtiles
```