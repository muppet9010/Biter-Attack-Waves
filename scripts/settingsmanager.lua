SettingsManager = {
--[[
biter-wave-vanilla-max-group-starting-size=Native Biter Attack Groups Starting Maximum Size
biter-wave-vanilla-max-group-increase-quantity=Native Biter Attack Groups Growth rate
biter-wave-vanilla-max-group-size-limit=Native Biter Attack Groups Upper Maximum Size

biter-wave-rampant-controls-biters=Rampant Mod Controls Biter Waves
biter-wave-rampant-max-group-starting-size=Rampant Biter Attack Groups Starting Maximum Size
biter-wave-rampant-max-group-increase-quantity=Rampant Biter Attack Groups Growth rate
biter-wave-rampant-max-group-size-limit=Rampant Biter Attack Groups Upper Maximum Size
]]
	UpdateSetting = function(settingName)
		if settingName == "biter-wave-streamer-list" or settingName == nil then
			SettingsManager.UpdatedStreamerNameListSetting()
		end
		if settingName == "biter-wave-game-start-safety-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWaveGameStartSafetySetting()
		end
		if settingName == "biter-wave-cooldown-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWaveCooldownSetting()
		end
		if settingName == "biter-wave-player-death-safety-seconds" or settingName == nil then
			SettingsManager.UpdatedBiterWavePlayerDeathSafetySetting()
		end
		if settingName == "biter-wave-spawn-locations" or settingName == nil then
			SettingsManager.UpdatedBiterWaveSpawnLocationsSetting()
		end
		if settingName == "biter-wave-max-squads" or settingName == nil then
			SettingsManager.UpdatedBiterWaveMaxSquadsSetting()
		end
		if settingName == "biter-wave-max-units" or settingName == nil then
			SettingsManager.UpdatedBiterWaveMaxUnitsSetting()
		end
		if settingName == "biter-wave-increase-quantity-cost" or settingName == nil then
			SettingsManager.UpdatedBiterWaveIncreaseCostSetting()
		end
		if settingName == "biter-wave-evolution-scale" or settingName == nil then
			SettingsManager.UpdatedBiterEvolutionSetting()
		end
		
		if settingName == "biter-squad-starting-units" or settingName == nil then
			SettingsManager.UpdatedBiterSquadStartingUnitsSetting()
		end
		if settingName == "biter-squad-max-units" or settingName == nil then
			SettingsManager.UpdatedBiterSquadMaxUnitsSetting()
		end
		if settingName == "biter-squad-increase-quantity" or settingName == nil then
			SettingsManager.UpdatedBiterSquadIncreaseQuantitySetting()
		end
		if settingName == "biter-squad-cost" or settingName == nil then
			SettingsManager.UpdatedBiterSquadCostSetting()
		end
		
		if settingName == "biter-group-max-units" or settingName == nil then
			SettingsManager.UpdatedBiterWaveGroupMaxSizeSetting()
		end
		if settingName == "biter-group-deployment-width" or settingName == nil then
			SettingsManager.UpdatedBiterWaveMaxGroupsWideSetting()
		end
	end,
	
	UpdatedStreamerNameListSetting = function()
		ModSettingsDict.streamerNameListString = settings.global["biter-wave-streamer-list"].value
		Streamer.UpdateStreamerNameList()
	end,

	UpdatedBiterWaveGameStartSafetySetting = function()
		ModSettingsDict.biterWaveGameStartSafetyTicks = tonumber(settings.global["biter-wave-game-start-safety-seconds"].value) * 60
		BiterWave.CalculateNextWaveDispatchTiming()
	end,

	UpdatedBiterWaveCooldownSetting = function()
		ModSettingsDict.biterWaveCooldownTicks = tonumber(settings.global["biter-wave-cooldown-seconds"].value) * 60
		BiterWave.CalculateNextWaveDispatchTiming()
	end,

	UpdatedBiterWavePlayerDeathSafetySetting = function()
		ModSettingsDict.biterWavePlayerDeathSafetyTicks = tonumber(settings.global["biter-wave-player-death-safety-seconds"].value) * 60
		BiterWave.CalculateNextWaveDispatchTiming()
	end,

	UpdatedBiterWaveGroupMaxSizeSetting = function()
		ModSettingsDict.biterWaveGroupMaxSize = tonumber(settings.global["biter-group-max-units"].value)
	end,

	UpdatedBiterWaveMaxGroupsWideSetting = function()
		ModSettingsDict.biterWaveMaxGroupsWide = tonumber(settings.global["biter-group-deployment-width"].value)
	end,

	UpdatedBiterWaveSpawnLocationsSetting = function()
		ModSettingsDict.biterWaveSpawnLocationString = settings.global["biter-wave-spawn-locations"].value
		SpawnLocations.UpdateLocationsList()
	end,

	UpdatedBiterWaveMaxSquadsSetting = function()
		ModSettingsDict.biterWaveMaxSquads = tonumber(settings.global["biter-wave-max-squads"].value)
	end,

	UpdatedBiterWaveMaxUnitsSetting = function()
		ModSettingsDict.biterWaveMaxUnits = tonumber(settings.global["biter-wave-max-units"].value)
	end,

	UpdatedBiterWaveIncreaseCostSetting = function()
		ModSettingsDict.biterWaveIncreaseCost = tonumber(settings.global["biter-wave-increase-quantity-cost"].value)
		BiterWave.UpdateBiterSizes()
	end,

	UpdatedBiterEvolutionSetting = function()
		ModSettingsDict.biterWaveEvolutionString = settings.global["biter-wave-evolution-scale"].value
		Evolution.UpdateEvolutionScale()
	end,

	UpdatedBiterSquadStartingUnitsSetting = function()
		ModSettingsDict.biterSquadStartingUnits = tonumber(settings.global["biter-squad-starting-units"].value)
		BiterWave.UpdateBiterSizes()
	end,

	UpdatedBiterSquadMaxUnitsSetting = function()
		ModSettingsDict.biterSquadMaxUnits = tonumber(settings.global["biter-squad-max-units"].value)
		BiterWave.UpdateBiterSizes()
	end,

	UpdatedBiterSquadIncreaseQuantitySetting = function()
		ModSettingsDict.biterSquadIncreaseQuantity = tonumber(settings.global["biter-squad-increase-quantity"].value)
		BiterWave.UpdateBiterSizes()
	end,

	UpdatedBiterSquadCostSetting = function()
		ModSettingsDict.biterSquadCost = tonumber(settings.global["biter-squad-cost"].value)
	end
}