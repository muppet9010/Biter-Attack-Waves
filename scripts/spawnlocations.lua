SpawnLocations = {

	StandardiseNamedLocationsTable = function(spawnLocations)
		local errorMessage = nil
		local cleanSpawnLocations = {}
		for name, data in pairs(spawnLocations) do
			if name == nil or name == "" then
				return false, nil, "blank location name supplied"
			end
			local newName = tostring(name)
			
			if type(data) ~= "table" then
				return false, nil, "non table format provided as data for name: " .. newName
			end
			
			local newPositionX = nil
			local newPositionY = nil
			if data.position == nil then
				return false, nil, "no position provided for name: " .. newName
			end
			if type(data.position) ~= "table" then
				return false, nil, "non table format provided as position for name: " .. newName
			end
			for locKey, locVal in pairs(data.position) do
				if locKey == 1 or locKey == "x" then
					newPositionX = tonumber(locVal)
				elseif locKey == 2 or locKey == "y" then
					newPositionY = tonumber(locVal)
				end
			end
			if newPositionX == nil then
				return false, nil, "invalid X position supplied for name: " .. newName
			end
			if newPositionY == nil then
				return false, nil, "invalid Y position supplied for name: " .. newName
			end
			
			local newFacing = nil
			if data.facing == nil then
				return false, nil, "no facing provided for name: " .. newName
			end
			newFacing = Constants.BiterWaveFacingDict[tostring(data.facing)]
			if newFacing == nil then
				return false, nil, "invalid facing supplied for name: " .. newName
			end
			
			cleanSpawnLocations[newName] = {
				position = {x = newPositionX, y = newPositionY},
				facing = newFacing
			}
		end
		return true, cleanSpawnLocations
	end,

	GetLocationNameFromText = function(locationText)
		local location = nil
		if locationText == nil or locationText == "" then
			game.print("WARNING - No biter spawn supplied in newly queued biters")
		elseif ModSettingsDict.biterWaveSpawnLocationsDict[locationText] == nil then
			game.print("WARNING - Biters targeting non existent location in newly queued biters")
		end
		return locationText
	end

}