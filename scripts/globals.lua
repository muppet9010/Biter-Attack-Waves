Globals = {}

Globals.CreateGlobals = function()
	if global.ModSettings == nil then global.ModSettings = {} end
end

Globals.ReferenceGlobals = function()
	ModSettings = global.ModSettings
end