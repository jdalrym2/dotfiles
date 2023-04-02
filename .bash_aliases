#!/bin/bash
alias df='df -h'
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
  docker run --rm -it -u root --name qgis \
      -e DISPLAY \
      -v $HOME:$HOME \
      -v $HOME:/root \
      -v /data:/data \
      -v /nfs:/nfs \
      -v /tmp/.X11-unix:/tmp/.X11-unix \
      $NETWORK \
      qgis/qgis:release-3_28 qgis
}

alias whoops='sudo $(history -p \!\!$)'

idea() {
  cd /opt/idea-IC-222.4167.29/bin && ./idea.sh
}

reset_permissions(){
  find . -type d -exec chmod 755 {} \;
  find . -type f -exec chmod 644 {} \;
}

alias please='sudo apt'

csv() {
  column -s, -t < $1 | less -#2 -N -S
}

venv-create() {
  local VENV_DIR

  if [ -z "$1" ]
  then
    echo "No argument supplied, assuming current directory"
    VENV_DIR='.'
  else
    VENV_DIR=$1
  fi

  python3 -m venv $VENV_DIR/venv &&\
  . $VENV_DIR/venv/bin/activate &&\
  python3 -m pip install pip-tools
  if [ -f "$VENV_DIR/requirements.in" ]; then
    while true; do
      read -p "Found requirements.in! Run pip-compile? (y/n) " -r
      case $REPLY in
        [Nn]* ) return;;
        [Yy]* ) pip-compile -o $VENV_DIR/requirements.txt $VENV_DIR/requirements.in ;;
        * ) ;;
      esac
    done
  else
    echo "No requirements.in found."
  fi
  if [ -f "$VENV_DIR/requirements.txt" ]; then
    while true; do
      read -p "Found requirements.txt! Run pip-sync? (y/n) " -r
      case $REPLY in
        [Nn]* ) return;;
        [Yy]* ) pip-sync -o $VENV_DIR/requirements.txt ;;
        * ) ;;
      esac
    done
  else
    echo "No requirements.txt found."
  fi
}

venv-activate() {
  local VENV_DIR

  if [ -z "$1" ]
  then
    VENV_DIR='.'
  else
    VENV_DIR=$1
  fi
  source $VENV_DIR/venv/bin/activate
}
