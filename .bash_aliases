#!/bin/bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias josm='java -jar /home/jon/workspace/josm/josm-tested.jar'
pyQuickPlot() {
  python3 <<EOF
from skimage.io import imread
import matplotlib.pyplot as plt
im = imread('$1')
print('Image shape: %s' % repr(im.shape))
if im.ndim == 3 and im.shape[2] == 2:
    if len('$2'):
        c = int('$2')
    else:
        c = 0
    print(f'Taking channel {c:d} only...')
    im = im[:, :, c]
plt.imshow(im)
plt.show()
EOF
}

grne() {
  grep -rn . -e "$@" --include "*.py"
}

postgis() {
  YML_FILE=/home/jon/git/public/PostgreSQL-PostGIS-TimescaleDB/docker-compose.yml
  if [ "$1" = "up" ]
  then
    docker-compose -f $YML_FILE up --detach
  elif [ "$1" = "down" ]
  then
    docker-compose -f $YML_FILE down
  else
    echo "Unknown command: '$1'"
  fi
}

qgis() {
  # Determine if there's a PostGIS network to connect to
  POSTGIS_NETWORK="postgresql-postgis-timescaledb_overlay"
  NETWORK=''
  if [ ! -z "$(docker network ls | grep $POSTGIS_NETWORK)" ]
  then
    echo "Found network '$POSTGIS_NETWORK'. Adding to container."
    NETWORK="--network $POSTGIS_NETWORK"
  fi

  # Run QGis!
  xhost +SI:localuser:root
  docker run --rm -it --name qgis \
      -e DISPLAY \
      -v $HOME:$HOME \
      -v /data:/data \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      $NETWORK \
      qgis/qgis:latest qgis
}

alias whoops='sudo $(history -p \!\!$)'

idea() {
  cd /opt/idea-IC-222.4167.29/bin && ./idea.sh
}

reset_permissions(){
  find . -type d -exec chmod 755 {} \;
  find . -type f -exec chmod 644 {} \;
}
