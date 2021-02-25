#!/bin/bash

set -ex

echo "Build project"
rojo build test-model.project.json --output model.rbxmx
echo "Remove .robloxrc from jest-roblox"
rm -f Packages/_Index/roblox_jest-roblox/jest-roblox/.robloxrc
echo "Run static analysis"
roblox-cli analyze test-model.project.json
echo "Run tests in DEV"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua --fastFlags.overrides "UseDateTimeType3=true" --lua.globals=__DEV__=true
echo "Run tests in release"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua --fastFlags.overrides "UseDateTimeType3=true"


