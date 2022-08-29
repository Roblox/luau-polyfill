--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
--!strict
local rshift = bit32.rshift
local log = math.log
local floor = math.floor
local LN2 = math.log(2)

return function(x: number): number
	if _G.__DEV__ then
		print("Luau now has a native bit32.countlz that is 20X faster than this function.")
	end
	-- convert to 32 bit integer
	local as32bit = rshift(x, 0)
	if as32bit == 0 then
		return 32
	end
	return 31 - floor(log(as32bit) / LN2)
end
