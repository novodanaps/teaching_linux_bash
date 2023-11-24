#!/bin/bash

# Build latest version of Emacs, version management with stow
# OS: Ubuntu 14.04 LTS
# version: 24.5
# Toolkit: lucid

# Warning, use updated version of this script in: https://github.com/favadi/build-emacs

set -e

readonly version="29.1"


# install dependencies for building Emacs 29.1

sudo apt build-dep emacs -y
sudo apt install -y libgccjit0 libgccjit-10-dev libjansson4 libjansson-dev \
     gnutls-bin libtree-sitter-dev gcc-10 imagemagick libmagick++-dev \
     libwebp-dev webp libxft-dev libxft2 \
     stow \

 
# download source package
if [[ ! -d emacs-"$version" ]]; then
   wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
   tar xvf emacs-"$version".tar.xz
fi

export CC=/usr/bin/gcc-10
export CXX=/usr/bin/gcc-10

# buil and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./autogen.sh
./configure --with-native-compilation=aot --with-imagemagick --with-json \
            --with-tree-sitter --with-xft
make -j$(nproc)

# ./configure \
#     --with-xft \
#     --with-x-toolkit=lucid
# make
sudo make install prefix=/usr/local/stow/emacs-"$version"
cd /usr/local/stow
sudo stow emacs-"$version"
