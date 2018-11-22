BiterWave = {

	--[[
	StateDict.fundedBitersQueuedDict = {
		id (int) = {
			id (int)
			completed (bool)
			targetPlayerName (string)
			funding (int)
			fundingDone (int)
			spawnLocationName (entries name in StateDict.biterWaveSpawnLocationsDict or nil)
			spawnLocationText (string - text from request)
			sponsorName (string)
		}
	}
	
	StateDict.fundedBiterGroupSizeDict = {
		id (int) = {
			id (int)
			streamerPlayerName (string)
			funding (int)
			sponsorName (string)
		}
	}
	]]

	CreateGlobals = function()
		if StateDict.biterSquadCurrentSize == nil then StateDict.biterSquadCurrentSize = 0 end
		if StateDict.fundedBiterGroupSizeDict == nil then StateDict.fundedBiterGroupSizeDict = {} end
		if StateDict.fundedBitersQueuedDict == nil then StateDict.fundedBitersQueuedDict = {} end
	end,
		
	FundBiterSquad = function(targetPlayerName, funding, spawnLocationText, sponsorName)
		local spawnLocationName = SpawnLocations.GetLocationNameFromText(spawnLocationText)
		local id = Utility.GetMaxKey(StateDict.fundedBitersQueuedDict) + 1
		StateDict.fundedBitersQueuedDict[id] = {
			id = id,
			completed = false,
			targetPlayerName = targetPlayerName,
			funding = funding,
			fundingDone = 0,
			spawnLocationName = spawnLocationName,
			spawnLocationText = spawnLocationText,
			sponsorName = sponsorName
		}
		return true
	end,

	UpdatedCurrentBiterSquadSize = function()
		local debugging = false
		if debugging then Utility.LogPrint(tostring(ModSettingsDict.biterWaveIncreaseCost) .. " - " .. tostring(ModSettingsDict.biterSquadIncreaseQuantity) .. " - " .. tostring(ModSettingsDict.biterSquadMaxUnits) .. " - " .. tostring(ModSettingsDict.biterSquadStartingUnits)) end
		if ModSettingsDict.biterWaveIncreaseCost == nil or ModSettingsDict.biterSquadIncreaseQuantity == nil or ModSettingsDict.biterSquadMaxUnits == nil or ModSettingsDict.biterSquadStartingUnits == nil then
			if debugging then Utility.LogPrint("Missing Biter Setting, NO Biter Squad Size Update done") end
			return
		end
		local totalFunding = BiterWave.GetFundingTotal()
		if debugging then Utility.LogPrint("totalFunding: " .. totalFunding) end
		local fundedBitersDouble = (totalFunding / ModSettingsDict.biterWaveIncreaseCost) * ModSettingsDict.biterSquadIncreaseQuantity
		if debugging then Utility.LogPrint("fundedBitersDouble: " .. fundedBitersDouble) end
		local biterSquadFundedSize = math.floor(fundedBitersDouble)
		if ModSettingsDict.biterSquadMaxUnits > 0 then 
			biterSquadFundedSize = math.min(biterSquadFundedSize, ModSettingsDict.biterSquadMaxUnits)
		end
		if debugging then Utility.LogPrint("limited biterSquadFundedSize: " .. biterSquadFundedSize) end
		StateDict.biterSquadCurrentSize = ModSettingsDict.biterSquadStartingUnits + biterSquadFundedSize
		if debugging then Utility.LogPrint("StateDict.biterSquadCurrentSize: " .. StateDict.biterSquadCurrentSize) end
	end,
	
	GetFundingTotal = function()
		local totalFunding = 0
		for i, fundEntry in pairs(StateDict.fundedBiterGroupSizeDict) do
			totalFunding = totalFunding + fundEntry.funding
		end
		return totalFunding
	end,
	
	FundIncreaseAttackSize = function(streamerPlayerName, funding, sponsorName)
		local id = Utility.GetMaxKey(StateDict.fundedBiterGroupSizeDict) + 1
		table.insert(StateDict.fundedBiterGroupSizeDict, {
			id = id,
			streamerPlayerName = streamerPlayerName,
			funding = funding,
			sponsorName = sponsorName
		})
		BiterWave.UpdatedCurrentBiterSquadSize()
	end
	
}