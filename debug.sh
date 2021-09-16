#!/bin/bash

set -e

elm-test
elm make src/Main.elm --output=static/main.js
