#!/bin/bash

set -ex

echo "Build project"
rojo build test-model.project.json --output model.rbxmx
echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f
echo "Run static analysis"
roblox-cli analyze test-model.project.json
selene src/util
stylua -c src/util
echo "Run tests in DEV"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua --fastFlags.overrides "UseDateTimeType3=true" --lua.globals=__DEV__=true
echo "Run tests in release"
roblox-cli run --load.model model.rbxmx --run bin/spec.lua --fastFlags.overrides "UseDateTimeType3=true"


