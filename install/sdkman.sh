#!/bin/bash
set -euo pipefail

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
sdk install groovy 2.4.7
sdk install gradle 3.3
sdk install maven 3.3.9
sdk flush candidates
set -eu

echo Please open a new terminal, or run the following in the existing one:
echo source "$HOME/.sdkman/bin/sdkman-init.sh"

exit 0