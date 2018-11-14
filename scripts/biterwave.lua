BiterWave = {

	CreateGlobals = function()
		StateDict.completedBiterQueuedID = 0
		StateDict.nextEntriesBiterQueuedID = 1
	end,
		
	AddQueuedBiters = function(quantity, spawnLocationText, sponsorName)
		local spawnLocationName = SpawnLocations.GetLocationNameFromText(spawnLocationText)
		BitersQueuedDict[StateDict.nextEntriesBiterQueuedID] = {
			completed = false,
			fullyQueued = false,
			quantity = quantity,
			quantityDone = 0,
			spawnLocationName = spawnLocationName,
			spawnLocationText = spawnLocationText,
			sponsorName = sponsorName
		}
		StateDict.nextEntriesBiterQueuedID = StateDict.nextEntriesBiterQueuedID + 1
		return true
	end,

	GetCurrentBiterWaveMaxSize = function()
		return ModSettingsDict.currentBiterWaveMaxSize()
	end,

	SetCurrentBiterWaveMaxSize = function(amount)
		ModSettingsDict.currentBiterWaveMaxSize = amount
		return ModSettingsDict.currentBiterWaveMaxSize()
	end,

	IncreaseCurrentBiterWaveMaxSize = function(amount)
		ModSettingsDict.currentBiterWaveMaxSize = ModSettingsDict.currentBiterWaveMaxSize + amount
		return ModSettingsDict.currentBiterWaveMaxSize()
	end

}