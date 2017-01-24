#!/bin/bash

# Installer for JetBrains Toolbox
# This will allow the installation, upgrade and management of other JetBrains tools
# Running the tool itself will automatically add an icon to the launcher

TMPDIR=~/tools/tmp
OUTDIR=~/tools/eclipse
CHECKSUM="7cd7c5a020bb4a8644fdaa1b4e3b1b9daab34edd17677e28b2cdd7934f2a6432320fbba241e4fb91349ae056405721522e4bfe29970a3934d49a3e8385558691"
ICONFILE=~/.local/share/applications/eclipse.desktop

mkdir -p $OUTDIR
mkdir -p $TMPDIR

curl -L http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz -o $TMPDIR/eclipse.tar.gz
if [ "`sha512sum $TMPDIR/eclipse.tar.gz`" == "$CHECKSUM  $TMPDIR/eclipse.tar.gz" ]; then
    cd $OUTDIR
    tar xvzf $TMPDIR/eclipse.tar.gz
    rm -rf $OUTDIR/java-neon
    rm -f $OUTDIR/current
    mv $OUTDIR/eclipse $OUTDIR/java-neon
    ln -s $OUTDIR/java-neon $OUTDIR/current

    rm -f $ICONFILE
    echo "[Desktop Entry]" > $ICONFILE
    echo "Type=Application" >> $ICONFILE
    echo "Name=Eclipse Neon" >> $ICONFILE
    echo "Exec=$HOME/tools/eclipse/current/eclipse %u" >> $ICONFILE
    echo "Icon=$HOME/tools/eclipse/current/icon.xpm" >> $ICONFILE
    echo "StartupNotify=false" >> $ICONFILE
    echo "Categories=Development;IDE;" >> $ICONFILE
    echo "Terminal=false" >> $ICONFILE
else
    echo "Unexpected checksum in tarball"
fi

rm -r $TMPDIR
