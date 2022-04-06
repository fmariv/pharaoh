# ContextMaps terrain RGB

Tool that converts a geo-tiff file containing Digital Elevation Model (DEM) data into a pyramid of png files with RGB data.

## Usage

##### Set up 

First of all, there are some environment variables that need to be established in the ```.env``` file, which are the following:

```
DOCKER_MOUNT       # local folder where the docker container is mounted
MIN_ZOOM           # min zoom to generate
MAX_ZOOM           # max zoom to generate
INPUT_FILE         # name of the input raster file
OUTPUT_FILE        # name of the output mbtiles file
```

##### Build

Then, you can build the container

```shell
make build-docker
```

##### Generate pyramid

And simply generate the tile pyramid, transforming the greyscale data into RGB data

```shell
make generate-pyramid
```

##### Extras

You can run a bash shell inside the docker container if you want to

```shell
make run-docker-shell
```

