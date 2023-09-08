set -ex

copies=$(lddtree.sh -l build/Release/canvas.node | sed -r -e '/^\/lib/d' -e '/canvas.node$/d');

# Fix the apt repository if the debian version is stretch
if [ "$(cat /etc/debian_version | cut -f1 -d.)" = "9" ]; then
  echo "deb http://archive.debian.org/debian stretch main contrib non-free" > /etc/apt/sources.list
  apt update
fi

apt install -y patchelf

for so in $copies; do
  cp $so build/Release
  # Set the run_path for all dependencies.
  patchelf --set-rpath '$ORIGIN' build/Release/$(basename $so)
done;
