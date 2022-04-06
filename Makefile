#
# First section - common variable initialization
#

# Ensure that errors don't hide inside pipes
SHELL         = /bin/bash
.SHELLFLAGS   = -o pipefail -c

# Make all .env variables available for make targets
include .env


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
    echo "Building the docker container from the dockerfile..."
	docker build -t ctx-terrain-rgb .
	echo "Container builded"

.PHONY: run-docker-shell
run-docker-shell:
	docker run --rm -it -v $(DOCKER_MOUNT):/opt/dem ctx-terrain-rgb bash

.PHONY: generate-pyramid
generate-pyramid:
    echo "Generating the tile pyramid..."
	docker run --rm -it -v $(DOCKER_MOUNT):/opt/dem ctx-terrain-rgb bash
	rio rgbify --min-z $(MIN_ZOOM) --max-z $(MAX_ZOOM) $(INPUT_FILE) $(OUTPUT_FILE)  
	exit
	echo "Tile pyramid generated"

.PHONY: list-docker-images
list-docker-images:
	docker images | grep ctx-terrain-rgb

.PHONY: remove-docker-images
remove-docker-images:
	@echo "Deleting all related docker image(s)..."