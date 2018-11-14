SettingsManager = {

	UpdateSetting = function(settingName)
		if settingName == "biter-wave-game-start-safety-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWaveGameStartSafetySetting()
		end
		if settingName == "biter-wave-cooldown-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWaveCooldownSetting()
		end
		if settingName == "biter-wave-player-death-safety-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWavePlayerDeathSafetySetting()
		end
		if settingName == "biter-wave-minimum-size" or settingName == nil then
			SettingsManager.UpdatedBiterWaveMinSizeSetting()
		end
		if settingName == "biter-wave-starting-max-size" or settingName == nil then
			SettingsManager.UpdatedBiterWaveStartingMaxSizeSetting()
		end
		if settingName == "biter-wave-group-size" or settingName == nil then
			SettingsManager.UpdatedBiterWaveGroupMaxSizeSetting()
		end
		if settingName == "biter-wave-groups-width" or settingName == nil then
			SettingsManager.UpdatedBiterWaveMaxGroupsWideSetting()
		end
		if settingName == "biter-wave-spawn-locations" or settingName == nil then
			SettingsManager.UpdatedBiterWaveSpawnLocationsSetting()
		end
	end,

	UpdatedBiterWaveGameStartSafetySetting = function()
		ModSettingsDict.biterWaveGameStartSafetyTicks = tonumber(settings.global["biter-wave-game-start-safety-seconds"].value) * 60
	end,

	UpdatedBiterWaveCooldownSetting = function()
		ModSettingsDict.biterWaveCooldownTicks = tonumber(settings.global["biter-wave-cooldown-seconds"].value) * 60
	end,

	UpdatedBiterWavePlayerDeathSafetySetting = function()
		ModSettingsDict.biterWavePlayerDeathSafetyTicks = tonumber(settings.global["biter-wave-player-death-safety-seconds"].value) * 60
	end,

	UpdatedBiterWaveMinSizeSetting = function()
		ModSettingsDict.biterWaveMinSize = tonumber(settings.global["biter-wave-minimum-size"].value)
	end,

	UpdatedBiterWaveStartingMaxSizeSetting = function()
		local biterWaveStartingMaxSize = tonumber(settings.global["biter-wave-starting-max-size"].value)
		if ModSettingsDict.currentBiterWaveMaxSize == nil then
			ModSettingsDict.currentBiterWaveMaxSize = biterWaveStartingMaxSize
		end
	end,

	UpdatedBiterWaveGroupMaxSizeSetting = function()
		ModSettingsDict.biterWaveGroupMaxSize = tonumber(settings.global["biter-wave-group-max-size"].value)
	end,

	UpdatedBiterWaveMaxGroupsWideSetting = function()
		ModSettingsDict.biterWaveMaxGroupsWide = tonumber(settings.global["biter-wave-max-groups-wide"].value)
	end,

	UpdatedBiterWaveSpawnLocationsSetting = function()
		local debugging = false
		if ModSettingsDict.biterWaveSpawnLocationsDict == nil then ModSettingsDict.biterWaveSpawnLocationsDict = {} end
		local locationText = settings.global["biter-wave-spawn-locations"].value
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
		ModSettingsDict.biterWaveSpawnLocationsDict = spawnLocations
	end

}