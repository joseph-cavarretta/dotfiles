#!/bin/bash

# remove unused containers, volumes, images, builds, etc..
docker system prune -a --volumes
  
# remove machine build images
rm -rf ~/.docker/desktop/vms
