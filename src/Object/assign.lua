--!strict
local None = require(script.Parent.None)

--[[
	Merges values from zero or more tables onto a target table. If a value is
	set to None, it will instead be removed from the table.

	This function is identical in functionality to JavaScript's Object.assign.
]]
-- Luau TODO: no way to strongly type this, it can't do intersections of type packs: <T, ...U>(T, ...: ...U): T & ...U
local function assign(target: { [any]: any }, ...): any
	for index = 1, select("#", ...) do
		local source = select(index, ...)

		if source ~= nil and typeof(source) == "table" then
			for key, value in pairs(source) do
				if value == None then
					target[key] = nil
				else
					target[key] = value
				end
			end
		end
	end

	return target
end

return assign
