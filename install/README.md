# Scripts to install standard development tools
These are shell scripts to install up-to-date standard Java/JVM and JS development
tools and tool management systems.  All scripts are re-runnable and should not
re-install versions already present.

## Pre-Requisites

- Linux distribution (tested on Ubuntu 16.04 but should work on any distro)
- BASH shell
- CURL command-line tool
- Java Development Kit (JDK) 1.8.0 (tested with OpenJDK 1.8.0u111)

## Scripts

Scripts do not take any command-line parameters.  __Eclipse__ and __JetBrains__ tools
will be installed under ```$HOME/tools```.

### eclipse.sh
- Installs the Neon version of __Eclipse of Java developers__
- Creates a launcher icon for the above

### jetbrains_toolbox.sh
- Installs v1.1.2143 of the __JetBrains Toolbox__ that manages installation of
  __IntelliJ IDEA__ and related tools.
- Runs the tool and installs an icon in the launcher

### sdkman.sh
- Installs the latest version of the __sdkman__ (formerly Groovy Version Manager)
  installation tool for JVM build tools and libraries
  - Updates to the latest version of __sdkman__ if already installed
- Installs __Groovy__ v2.4.7
- Installs __Gradle__ 3.3
- Installs __Maven__ 3.3.9

### nvm.sh
- Installs the latest version of __NVM__ (Node Verison Manager) for managing
  installations of __Node.JS__ and __IO.JS__
- Installs __Node.JS__ v6.9.4 and tools related to that version:
  - Installs __Bower__ CLI v1.8.0
  - Installs __Grunt__ CLI v1.2.0