alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias qgis='source $HOME/workspace/run_qgis.sh'
alias josm='java -jar /home/jon/workspace/josm/josm-tested.jar'
pyQuickPlot() {
  python3 <<EOF
from skimage.io import imread
import matplotlib.pyplot as plt
im = imread('$1')
print('Image shape: %s' % repr(im.shape))
if im.ndim == 3 and im.shape[2] == 2:
  print('Taking first channel only...')
  im = im[:, :, 0]
plt.imshow(im)
plt.show()
EOF
}

grne() {
  grep -rn . -e "$@" --include "*.py"
}
