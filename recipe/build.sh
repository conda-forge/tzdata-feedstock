#!/bin/bash
set -ex

# pull tzcode/* up one directory, except "calendars", as this already exists in tzdata
if [[ -d tzcode ]]; then
    # Move everything except "calendars"
    find tzcode -mindepth 1 -maxdepth 1 \
        -not -name calendars \
        -exec mv -t . {} +
fi

# by default the makefile does not install leap-seconds.list;
# however, some implementations (e.g. libc++) rely on it so
# we expand the default (TZDATA_TEXT=tzdata.zi leapseconds)

make -e \
  DESTDIR=./build \
  EXPIRES_LINE=1 \
  USRDIR='' \
  TZDATA_TEXT='tzdata.zi leapseconds leap-seconds.list' \
  install

mkdir -p "${PREFIX}/share"
mv ./build/share/zoneinfo "${PREFIX}/share/"
