#!/bin/bash
set -euo pipefail

if [ ! -x "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
fi

if [ "$(nvm --version)" == '' ]; then
    echo Loading config
    export NVM_DIR="$HOME/.nvm"
    set +eu
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    set -eu
fi

if [ "$(node --version)" != 'v6.9.4' ]; then
    echo Installing NodeJS
    set +u
    nvm install v6.9.4
    nvm use v6.9.4
    set -u
fi

if [ "$(bower --version)" != '1.8.0' ]; then
    echo Installing Bower
    npm install -g bower@1.8.0
fi

if [ "$(grunt --version)" != 'grunt-cli v1.2.0' ]; then
    echo Installing Grunt
    npm install -g grunt-cli@1.2.0
fi

echo Close and reopen your terminal to start using nvm or run the following to use it now:
echo export NVM_DIR="$HOME/.nvm"
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'

exit 0