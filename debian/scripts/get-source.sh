#!/bin/sh
set -e

VERSION=$(dpkg-parsechangelog -SVersion | sed 's/-[0-9]*$//')
COMMIT_ID=$(echo "$VERSION" | sed -n 's/.*\.//p')

echo "Version: $VERSION"
echo "Commit ID: $COMMIT_ID"

REPO="https://github.com/xmm7360/xmm7360-pci.git"
PREFIX="xmm7360-pci-${VERSION}/"
TARBALL="xmm7360-pci_${VERSION}.orig.tar.xz"

if [ ! -d xmm7360-pci.git ]; then
  git clone --mirror "$REPO" xmm7360-pci.git
else
  git --git-dir=xmm7360-pci.git fetch
fi

git --git-dir=xmm7360-pci.git archive --format=tar --prefix="$PREFIX" "$COMMIT_ID" | xz > "../$TARBALL"
rm -rf xmm7360-pci.git
