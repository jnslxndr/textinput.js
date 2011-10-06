#!/usr/bin/env bash

NAME="dropperpasterfiler.all.min.js"
FILES="TextFileReader.js paster.js dropper.js filer.js"

if [[ -d "./build" ]]; then
	rm -rdf ./build
fi

mkdir -p ./build
NAME=./../build/$NAME

# compile again:
coffee -c src/*.js

# Options see: https://github.com/mishoo/UglifyJS
cd src && cat $FILES | uglifyjs -mt > $NAME && cd ..

