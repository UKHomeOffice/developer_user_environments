#!/bin/bash
set -euo pipefail

NVM_VERSION=v0.33.0
NODE_VERSION=v6.9.4
BOWER_VERSION=1.8.0
GRUNT_VERSION=1.2.0

if [ ! -x "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash
fi

if [ "$(nvm --version)" == '' ]; then
    echo Loading config
    export NVM_DIR="$HOME/.nvm"
    set +eu
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    set -eu
fi

if [ "$(node --version)" != "${NODE_VERSION}" ]; then
    echo Installing NodeJS
    set +u
    nvm install ${NODE_VERSION}
    nvm use ${NODE_VERSION}
    set -u
fi

if [ "$(bower --version)" != "${BOWER_VERSION}" ]; then
    echo Installing Bower
    npm install -g bower@${BOWER_VERSION}
fi

if [ "$(grunt --version)" != "grunt-cli v${GRUNT_VERSION}" ]; then
    echo Installing Grunt
    npm install -g grunt-cli@${GRUNT_VERSION}
fi

echo Close and reopen your terminal to start using nvm or run the following to use it now:
echo export NVM_DIR="$HOME/.nvm"
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'

exit 0
