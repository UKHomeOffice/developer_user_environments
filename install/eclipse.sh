#!/bin/bash
set -euo pipefail

# Installer for JetBrains Toolbox
# This will allow the installation, upgrade and management of other JetBrains tools
# Running the tool itself will automatically add an icon to the launcher

TMPDIR=$HOME/tools/tmp
OUTDIR=$HOME/tools/eclipse
CHECKSUM="7cd7c5a020bb4a8644fdaa1b4e3b1b9daab34edd17677e28b2cdd7934f2a6432320fbba241e4fb91349ae056405721522e4bfe29970a3934d49a3e8385558691"
ICONFILE=$HOME/.local/share/applications/eclipse.desktop

if [ ! -x "$OUTDIR/java-neon" ]; then

    mkdir -p $OUTDIR
    mkdir -p $TMPDIR

    curl -L http://www.mirrorservice.org/sites/download.eclipse.org/eclipseMirror/technology/epp/downloads/release/neon/2/eclipse-java-neon-2-linux-gtk-x86_64.tar.gz -o $TMPDIR/eclipse.tar.gz
    if [ "$(sha512sum $TMPDIR/eclipse.tar.gz)" == "$CHECKSUM  $TMPDIR/eclipse.tar.gz" ]; then
        cd $OUTDIR
        rm -rf $OUTDIR/eclipse
        tar xvzf $TMPDIR/eclipse.tar.gz
        rm -f $OUTDIR/current
        mv $OUTDIR/eclipse $OUTDIR/java-neon
        ln -s $OUTDIR/java-neon $OUTDIR/current

        rm -f $ICONFILE
        echo "[Desktop Entry]" > $ICONFILE
        echo "Type=Application" >> $ICONFILE
        echo "Name=Eclipse Neon" >> $ICONFILE
        echo "Exec=$OUTDIR/current/eclipse %u" >> $ICONFILE
        echo "Icon=$OUTDIR/current/icon.xpm" >> $ICONFILE
        echo "StartupNotify=false" >> $ICONFILE
        echo "Categories=Development;IDE;" >> $ICONFILE
        echo "Terminal=false" >> $ICONFILE
    else
        echo "Invalid checksum for tarball.  Aborting."
    fi

    rm -r $TMPDIR
else
    echo "Eclipse Neon is already installed"
    echo "To remove it and re-install run rm -rf $OUTDIR/java-neon"
fi

