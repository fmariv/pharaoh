#
# First section - common variable initialization
#

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Make all .env variables available for make targets
include .env

# Docker image and container names
CONTAINER     = pharaoh
IMAGE         = franmartin/pharaoh
export CONTAINER
export IMAGE


define HELP_MESSAGE
====================================================================================================
 ContextMaps terrain RGB  https://github.com/fmariv/contextmaps-terrain-rgb

Hints for tile pyramid generation:
  make generate-pyramid                # generate a tile pyramid
  make generate-pyramid-png            # generate a tile pyramid in PNG format
  make generate-pyramid-png-nodata     # generate a tile pyramid in PNG format with no data as 0
  make generate-pyramid-rgb            # generate the tile pyramid in RGB data

Hints for Docker management:
  make build-docker                    # build the docker container from the dockerfile
  make run-docker-shell                # execute the shell bash inside the container
  make remove-docker-images            # remove docker images
  make list-docker-images              # show a list of available docker images
====================================================================================================
endef
export HELP_MESSAGE

#
#  TARGETS
#

.PHONY: all
all: init-dirs

.PHONY: help
help:
	@echo "$$HELP_MESSAGE" | less
 
.PHONY: init-dirs
init-dirs:
	@mkdir -p data

.PHONY: build-docker
build-docker:
	@echo "Pulling and building the docker image..."
	@docker pull $(IMAGE)
	@echo "Image builded"

.PHONY: run-docker-shell
run-docker-shell:
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) bash

.PHONY: generate-pyramid
generate-pyramid:
	@echo "Generating the tile pyramid..."
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) \
	 "rio mbtiles --zoom-levels $(MIN_ZOOM)..$(MAX_ZOOM) opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile pyramid generated"

.PHONY: generate-pyramid-png
generate-pyramid-png:
	@echo "Generating the tile pyramid in PNG..."
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) \
	 "rio mbtiles -f PNG --co ZLEVEL=9 --tile-size 512 --zoom-levels $(MIN_ZOOM)..$(MAX_ZOOM) opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile PNG pyramid generated"

.PHONY: generate-pyramid-png-nodata
generate-pyramid-png-nodata:
	@echo "Generating the tile pyramid in PNG with no data values as 0..."
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) \
	 "rio mbtiles -f PNG --co ZLEVEL=9 --exclude-empty-tiles --dst-nodata 0.0 --tile-size 512 --zoom-levels $(MIN_ZOOM)..$(MAX_ZOOM) opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile PNG pyramid generated"

.PHONY: generate-pyramid-rgb
generate-pyramid-rgb:
	@echo "Generating the tile pyramid in RGB..."
	@docker run --rm -it --name $(CONTAINER) -v $$(pwd)/data:/opt/dem $(IMAGE) \
	 "rio rgbify -b -10000 -i 0.1 --min-z $(MIN_ZOOM) --max-z $(MAX_ZOOM) opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile RGB pyramid generated"

.PHONY: list-docker-images
list-docker-images:
	docker images | grep ctx-terrain-rgb

.PHONY: remove-docker-images
remove-docker-images:
	@echo "Deleting all related docker image(s)..."
	@docker image rm $(IMAGE)