#!/bin/bash

set -ex

echo "Build project"
rojo build test-model.project.json --output model.rbxmx
echo "Run static analysis"
roblox-cli analyze test-model.project.json
echo "Run tests"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua
