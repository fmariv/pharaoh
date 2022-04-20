# ContextMaps terrain RGB

Tool that converts a geo-tiff file containing Digital Elevation Model (DEM) data into a pyramid of png files.

## Usage

##### Set up 

First of all, there are some environment variables that need to be established in the ```.env``` file, which are the following:

```
MIN_ZOOM           # min zoom to generate
MAX_ZOOM           # max zoom to generate
INPUT_FILE         # name of the input raster file
OUTPUT_FILE        # name of the output mbtiles file
```

##### Build

Init some necessary directories

```shell
make
```

Then, you can build the container pulling the image from the [Docker Hub](https://hub.docker.com/r/franmartin/ctx-terrain-rgb)

```shell
make build-docker
```

Or build it from the dockerfile

```shell
docker build -t ctx-terrain-rgb .
```

##### Generate pyramid

And simply generate the tile pyramid. By default, it is generated in the data directory. 

```shell
make generate-pyramid
```

You can also generate the tile pyramid transforming the greyscale data into RGB data

```shell
make generate-pyramid-rgb
```

##### Extras

You can run a bash shell inside the docker container if you want to

```shell
make run-docker-shell
```

