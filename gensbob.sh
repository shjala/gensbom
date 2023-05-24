SYFT_VERSION=v0.82.0 #v0.78.0
SYFT_IMAGE=docker.io/anchore/syft:${SYFT_VERSION}

if [ $# -lt 2 ] ; then
    echo 'gensbom.sh [path-to-rootfs.img] [sbom name]'
    exit 1
fi

mkdir /tmp/rootfs-sbom || exit 1
echo "[*] mount needs root access..."
sudo mount -o loop "$1" /tmp/rootfs-sbom

docker run -v /tmp/rootfs-sbom:/rootdir:ro -v ./.syft.yaml:/syft.yaml:ro ${SYFT_IMAGE} -c /syft.yaml /rootdir > "$2"

sudo umount /tmp/rootfs-sbom
rm -rf /tmp/rootfs-sbom