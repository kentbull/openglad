# Steps I followed

Mac OS on M1 mac

## Prerequisites

1. Install Homebrew if not already installed:
  - `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

2. Install Xcode from the App Store (or via command line): 
  - `xcode-select --install`
    - for tools only, but full Xcode is recommended for the IDE.

3. Install dependencies via Homebrew: 
  - `brew install sdl2 sdl2_mixer libpng pkg-config`

4. Install Premake 5 with homebrew using `brew install premake` or by downloading the source from the following URL and compiling and installing it manually:
  - `https://premake.github.io/download`


5. Change the Makefile generator script filename from `premake4.lua` to `premake5.lua`
  - TODO: push premake5.lua changes to repo for upgrade to Premake5

6. Build the project from the root directory using a makefile with `make config=release`