#!/bin/sh

set -e

DARKLUA_CONFIG=".darklua-tests.json"

if [ ! -d node_modules ]; then
    rm -rf roblox
    yarn install
fi

if [ -d "roblox" ]; then
    ls -d roblox/* | grep -v node_modules | xargs rm -rf
fi

rojo sourcemap test-place.project.json -o sourcemap.json

darklua process --config $DARKLUA_CONFIG scripts/roblox-test.server.lua roblox/scripts/roblox-test.server.lua
darklua process --config $DARKLUA_CONFIG node_modules roblox/node_modules

cp test-place.project.json roblox/

rojo build roblox/test-place.project.json -o roblox/test-place.rbxl

run-in-roblox --place roblox/test-place.rbxl --script roblox/scripts/roblox-test.server.lua
