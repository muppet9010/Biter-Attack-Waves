Globals = {

	--[[
	ModSettingsDict = {
		settingName (string) = value (varies)
	}
	ModSettingsDict.biterWaveSpawnLocationsDict = {
		name (string) = {
			position (position)
			facing (Constants.BiterWaveFacingDict)
		}
	}

	StateDict = {
		stateName (string) = value (varies)
	}

	GuiPlayerElemDict = {
		player_index (int) = {
			guiElemName (string) = guiElem (GuiElement)
		}
	}

	BitersQueuedDict = {
		id (int) = {
			completed (bool)
			quantityToDo (int)
			quantityDone (int)
			spawnLocationName (entries name in ModSettingsDict.biterWaveSpawnLocationsDict or nil)
			spawnLocationText (string - text from request)
			sponsorName (string)
		}
	}

	BiterWavesSentDict = {}
	]]

	CreateGlobals = function()
		if global.ModSettingsDict == nil then global.ModSettingsDict = {} end
		if global.BiterWavesSentDict == nil then global.BiterWavesSentDict = {} end
		if global.BitersQueuedDict == nil then global.BitersQueuedDict = {} end
		if global.StateDict == nil then global.StateDict = {} end
		if global.GuiPlayerElemDict == nil then global.GuiPlayerElemDict = {} end
		Globals.ReferenceGlobals()
		
		BiterWave.CreateGlobals()
	end,

	ReferenceGlobals = function()
		ModSettingsDict = global.ModSettingsDict
		BiterWavesSentDict = global.BiterWavesSentDict
		BitersQueuedDict = global.BitersQueuedDict
		StateDict = global.StateDict
		GuiPlayerElemDict = global.GuiPlayerElemDict
	end

}