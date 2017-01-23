#!/bin/bash

# Installer for JetBrains Toolbox
# This will allow the installation, upgrade and management of other JetBrains tools
# Running the tool itself will automatically add an icon to the launcher

VERSION=1.1.2143
TMPDIR=~/tools/tmp
OUTDIR=~/tools/jetbrains

mkdir -p $OUTDIR
mkdir -p $TMPDIR

curl -L https://download.jetbrains.com/toolbox/jetbrains-toolbox-${VERSION}.tar.gz -o $TMPDIR/jetbrains-toolbox.tar.gz
cd $OUTDIR
tar xvzf $TMPDIR/jetbrains-toolbox.tar.gz
rm -f $OUTDIR/latest
ln -s $OUTDIR/*$VERSION* $OUTDIR/latest

rm -r $TMPDIR

$OUTDIR/latest/jetbrains-toolbox &
