#
# First section - common variable initialization
#

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Make all .env variables available for make targets
include .env

# Docker image and container names
CONTAINER     = contextmaps_terrain_rgb
IMAGE         = ctx-terrain-rgb
export CONTAINER
export IMAGE


define HELP_MESSAGE
==============================================================================
 ContextMaps terrain RGB  https://github.com/fmariv/contextmaps-terrain-rgb

Hints for tile pyramid generation:
  make generate-pyramid                # build the tile pyramid

Hints for Docker management:
  make build-docker                    # build the docker container from the dockerfile
  make run-docker-shell                # execute the shell bash inside the container
  make remove-docker-images            # remove docker images
  make list-docker-images              # show a list of available docker images
==============================================================================
endef
export HELP_MESSAGE

#
#  TARGETS
#

.PHONY: help
help:
	@echo "$$HELP_MESSAGE" | less

.PHONY: build-docker
build-docker:
	@echo "Building the docker image from the dockerfile..."
	docker build -t $(IMAGE) .
	@echo "Image builded"

.PHONY: run-docker-shell
run-docker-shell:
	docker run --rm -it --name $(CONTAINER) -v $(DOCKER_MOUNT):/opt/dem $(IMAGE) bash

.PHONY: generate-pyramid
generate-pyramid:
	@echo "Generating the tile pyramid..."
	docker run --rm -it --name $(CONTAINER) -v $(DOCKER_MOUNT):/opt/dem $(IMAGE) \
	 "rio rgbify --min-z $(MIN_ZOOM) --max-z $(MAX_ZOOM) opt/dem/$(INPUT_FILE) opt/dem/$(OUTPUT_FILE)"
	@echo "Tile pyramid generated"

.PHONY: list-docker-images
list-docker-images:
	docker images | grep ctx-terrain-rgb

.PHONY: remove-docker-images
remove-docker-images:
	@echo "Deleting all related docker image(s)..."