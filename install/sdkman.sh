#!/bin/bash
if [ -x "$HOME/.sdkman" ]; then
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk selfupdate
else
    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

sdk install groovy 2.4.7
sdk install grails 3.2.4
sdk install maven 3.3.9

sdk flush candidates

echo Please open a new terminal, or run the following in the existing one:
echo source "/home/krupag/.sdkman/bin/sdkman-init.sh"

