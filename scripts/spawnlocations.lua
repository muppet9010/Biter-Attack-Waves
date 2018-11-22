SpawnLocations = {

	--[[
	StateDict.biterWaveSpawnLocationsDict = {
		name (string) = {
			name (string)
			position (position)
			facing (Constants.BiterWaveFacingDict)
		}
	}
	
	StateDict.biterWaveSpawnLocationNameArray = {name}
	]]

	CreateGlobals = function()
		if StateDict.biterWaveSpawnLocationsDict == nil then StateDict.biterWaveSpawnLocationsDict = {} end
	end,
	
	UpdateLocationsList = function()
		local debugging = false
		local locationText = ModSettingsDict.biterWaveSpawnLocationString
		if locationText == nil or locationText == "" or locationText == "{}" then
			Utility.LogPrint("Blank or Empty Spawn Location Setting, nothing will spawn")
			return
		end
		if debugging then Utility.LogPrint(locationText) end
		local success, spawnLocations = pcall(function() return loadstring("return " .. locationText )() end)
		if debugging then Utility.LogPrint(tostring(success) .. " : " .. tostring(spawnLocations)) end
		if not success or type(spawnLocations) ~= "table" or Utility.GetTableLength(spawnLocations) == 0 then
			Utility.LogPrint("Spawn Locations Failed To Process, mod setting not valid table")
			return
		end
		local success, spawnLocations, errorMessage = SpawnLocations.StandardiseNamedLocationsTable(spawnLocations)
		if not success then
			Utility.LogPrint("Spawn Locations Failed To Process: " .. errorMessage)
			return
		end
		if debugging then Utility.LogPrint(Utility.TableContentsToString(spawnLocations, "spawnLocations")) end
		StateDict.biterWaveSpawnLocationsDict = spawnLocations
		StateDict.biterWaveSpawnLocationNameArray = Utility.TableKeyToArray(spawnLocations)
	end,

	StandardiseNamedLocationsTable = function(spawnLocations)
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
				name = newName,
				position = {x = newPositionX, y = newPositionY},
				facing = newFacing
			}
		end
		return true, cleanSpawnLocations
	end,

	GetLocationNameFromText = function(locationText)
		if locationText == nil or locationText == "" then
			game.print("WARNING - No biter spawn supplied in newly queued biters")
			return nil
		elseif StateDict.biterWaveSpawnLocationsDict[locationText] == nil then
			game.print("WARNING - Biters targeting non existent location in newly queued biters")
			return nil
		else
			return locationText
		end
	end

}