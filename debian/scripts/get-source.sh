#!/bin/sh
set -e

usage() {
  echo "Usage: $0 <save directory>" >&2
  exit 1
}

if [ -z "$1" ]; then
  usage
  exit 1
fi
OUTPUT="$1"
if [ ! -d "$OUTPUT" ]; then
  usage
  exit 1
fi
OUTPUT=$(readlink -f "$OUTPUT")

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
ROOT_DIR=$(dirname "$(dirname "$SCRIPT_DIR")")
cd "$ROOT_DIR"

VERSION=$(dpkg-parsechangelog -SVersion | sed 's/-[0-9]*$//')
COMMIT_ID=$(echo "$VERSION" | sed -n 's/.*\.//p')

echo "Version: $VERSION"
echo "Commit ID: $COMMIT_ID"

REPO="https://github.com/xmm7360/xmm7360-pci.git"
PREFIX="xmm7360-pci-${VERSION}/"
TARBALL="$OUTPUT/xmm7360-pci_${VERSION}.orig.tar.xz"

if [ ! -d xmm7360-pci.git ]; then
  git clone --mirror "$REPO" xmm7360-pci.git
else
  git --git-dir=xmm7360-pci.git fetch
fi

git --git-dir=xmm7360-pci.git archive --format=tar --prefix="$PREFIX" "$COMMIT_ID" | xz > "$TARBALL"
rm -rf xmm7360-pci.git
