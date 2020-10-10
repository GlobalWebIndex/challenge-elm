#!/usr/bin/env bash


JS="./built/app.js"
ELM_MAIN="./src/Main.elm"


if [[ ! -d ./built ]]; then
    mkdir ./built
fi
cp ./prebuilt/index.html ./built/index.html

if [[ "$1" = "--optimize" ]]; then
    elm make $ELM_MAIN --optimize --output="$JS"
else
    elm make $ELM_MAIN --output="$JS"
fi
