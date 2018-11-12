SettingsManager = {}

SettingsManager.UpdateSetting = function(settingName)
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
end

SettingsManager.UpdatedBiterWaveGameStartSafetySetting = function()
	ModSettings.biterWaveGameStartSafetyTicks = tonumber(settings.global["biter-wave-game-start-safety-seconds"].value) * 60
end

SettingsManager.UpdatedBiterWaveCooldownSetting = function()
	ModSettings.biterWaveCooldownTicks = tonumber(settings.global["biter-wave-cooldown-seconds"].value) * 60
end

SettingsManager.UpdatedBiterWavePlayerDeathSafetySetting = function()
	ModSettings.biterWavePlayerDeathSafetyTicks = tonumber(settings.global["biter-wave-player-death-safety-seconds"].value) * 60
end

SettingsManager.UpdatedBiterWaveMinSizeSetting = function()
	ModSettings.biterWaveMinSize = tonumber(settings.global["biter-wave-minimum-size"].value)
end

SettingsManager.UpdatedBiterWaveStartingMaxSizeSetting = function()
	ModSettings.biterWaveStartingMaxSize = tonumber(settings.global["biter-wave-starting-max-size"].value)
end

SettingsManager.UpdatedBiterWaveGroupMaxSizeSetting = function()
	ModSettings.biterWaveGroupMaxSize = tonumber(settings.global["biter-wave-group-max-size"].value)
end

SettingsManager.UpdatedBiterWaveMaxGroupsWideSetting = function()
	ModSettings.biterWaveMaxGroupsWide = tonumber(settings.global["biter-wave-max-groups-wide"].value)
end

SettingsManager.UpdatedBiterWaveSpawnLocationsSetting = function()
	local debugging = false
	local locationText = settings.global["biter-wave-spawn-locations"].value
	if locationText == nil or locationText == "" or locationText == "{}" then
		Utility.LogPrint("Blank or Empty Spawn Location Setting, nothing will spawn")
		return
	end
	if debugging then Utility.LogPrint(locationText) end
	local success, spawnLocations = pcall(function() return loadstring("return " .. locationText )() end)
	if debugging then Utility.LogPrint(tostring(success) .. " : " .. tostring(spawnLocations)) end
	if success and type(spawnLocations) == "table" and Utility.GetTableLength(spawnLocations) > 0 then
		if debugging then Utility.LogPrint(Utility.TableContentsToString(spawnLocations, "spawnLocations")) end
		ModSettings.biterWaveSpawnLocations = spawnLocations
	else
		Utility.LogPrint("Spawn Locations Failed To Process, invalid mod setting value")
		return
	end
end