#!/bin/bash
set -euo pipefail

GROOVY_VERSION=2.4.7
GRADLE_VERSION=3.3
MAVEN_VERSION=3.3.9

if [ -x "$HOME/.sdkman" ]; then
    # SDKMAN doesn't play well in strict mode
    set +eu
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk selfupdate
    set -eu
else
    curl -s "https://get.sdkman.io" | bash
    set +u
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    set -u
fi

# SDKMAN doesn't play well in strict mode
set +eu
sdk install groovy ${GROOVY_VERSION}
sdk install gradle ${GRADLE_VERSION}
sdk install maven ${MAVEN_VERSION}
sdk flush candidates
set -eu

echo Please open a new terminal, or run the following in the existing one:
echo source "$HOME/.sdkman/bin/sdkman-init.sh"

exit 0
