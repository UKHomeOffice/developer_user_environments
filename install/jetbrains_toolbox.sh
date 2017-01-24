#!/bin/bash

# Installer for JetBrains Toolbox
# This will allow the installation, upgrade and management of other JetBrains tools
# Running the tool itself will automatically add an icon to the launcher

VERSION=1.1.2143
TMPDIR=~/tools/tmp
OUTDIR=~/tools/jetbrains
CHECKSUM="74ca89a1b97367e909075e53c67ee093ca316ecb8124bb39e7318750634552a3"

if [ ! -x "$OUTDIR/jetbrains-toolbox-$VERSION" ]; then
    mkdir -p $TMPDIR

    curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-${VERSION}.tar.gz -o $TMPDIR/jetbrains-toolbox.tar.gz

    if [ "`sha256sum $TMPDIR/jetbrains-toolbox.tar.gz`" == "$CHECKSUM  $TMPDIR/jetbrains-toolbox.tar.gz" ]; then
        mkdir -p $OUTDIR
        cd $OUTDIR
        tar xvzf $TMPDIR/jetbrains-toolbox.tar.gz
        rm -f $OUTDIR/latest
        ln -s $OUTDIR/jetbrains-toolbox-$VERSION $OUTDIR/latest
    else
        echo "Invalid checksum for tarball.  Aborting."
    fi

    rm -r $TMPDIR

    $OUTDIR/latest/jetbrains-toolbox &
else
    echo "JetBrains Toolbox $VERSION is already installed"
    echo "To remove it and re-install run rm -rf $OUTDIR/jetbrains-toolbox-$VERSION"
fi
