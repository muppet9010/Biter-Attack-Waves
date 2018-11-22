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
		if StateDict.lastWaveDispatchedTick == nil then StateDict.lastWaveDispatchedTick = 0 end
		if StateDict.nextWaveDispatchTick == nil then StateDict.nextWaveDispatchTick = 0 end
		if StateDict.playerDeathsThisWave == nil then StateDict.playerDeathsThisWave = 0 end
	end,
		
	FundBiterSquad = function(targetPlayerName, funding, spawnLocationText, sponsorName)
		local spawnLocationName = SpawnLocations.GetLocationNameFromText(spawnLocationText)
		local id = Utility.GetMaxKey(StateDict.fundedBitersQueuedDict) + 1
		local streamerName = Streamer.GetStreamNameFromText(targetPlayerName, " Fund Biter Squad Attack")
		StateDict.fundedBitersQueuedDict[id] = {
			id = id,
			completed = false,
			targetPlayerName = streamerName,
			funding = funding,
			fundingDone = 0,
			spawnLocationName = spawnLocationName,
			spawnLocationText = spawnLocationText,
			sponsorName = sponsorName
		}
		return true
	end,
	
	UpdateBiterSizes = function()
		BiterWave.UpdateCurrentBiterSquadSize()
		--TODO do vanilla & Rampant group sizes as well
	end,

	UpdateCurrentBiterSquadSize = function()
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
		local streamerName = Streamer.GetStreamNameFromText(streamerPlayerName, " Fund Increase Attack Group Size")
		table.insert(StateDict.fundedBiterGroupSizeDict, {
			id = id,
			streamerPlayerName = streamerName,
			funding = funding,
			sponsorName = sponsorName
		})
		BiterWave.UpdateBiterSizes()
	end,
	
	CheckBiterWaveDispatchTiming = function()
		if StateDict.nextWaveDispatchTick == nil or StateDict.nextWaveDispatchTick > game.tick then return end
		
		BiterWave.CreateBiterWave()
		
		StateDict.lastWaveDispatchedTick = game.tick
		StateDict.playerDeathsThisWave = 0
		BiterWave.CalculateNextWaveDispatchTiming()
	end,
	
	CalculateNextWaveDispatchTiming = function()
		local nextWaveTick = StateDict.lastWaveDispatchedTick
		if StateDict.lastWaveDispatchedTick == 0 then
			nextWaveTick = nextWaveTick + ModSettingsDict.biterWaveGameStartSafetyTicks
		end
		nextWaveTick = nextWaveTick + ModSettingsDict.biterWaveCooldownTicks
		nextWaveTick = nextWaveTick + (StateDict.playerDeathsThisWave * ModSettingsDict.biterWavePlayerDeathSafetyTicks)
		StateDict.nextWaveDispatchTick = nextWaveTick
	end,
	
	CreateBiterWave = function()
		local biterLocationSquads = BiterWave.GetBiterLocationSquadsForWave()
	
		for location, squadCount in pairs(biterLocationSquads) do
		--TODO
		--[[
			_surface = game.player.surface
			local maxBiterGroups = math.ceil(biterCount / ModSettingsDict.biterWaveGroupMaxSize)
			local biterWaveGroupsWide = ModSettingsDict.biterWaveMaxGroupsWide
			if maxBiterGroups < biterWaveGroupsWide then
				biterWaveGroupsWide = maxBiterGroups
			end
			local biterGroupSize = math.ceil(biterCount / maxBiterGroups)
			local biterGroupTileWidth = 20
			local biterGroupTileLength = math.sqrt(ModSettingsDict.biterWaveGroupMaxSize)
			local groupStartPos = FindBiterGatherPoint()
			if maxBiterGroups > 20 then
				game.print("too many attack groups will lag the game - stopped")
				return
			end
			
			local waveWidthCount = 0
			local waveDepthCount = 0
			local triggerTick = game.tick + _monitorBiterGroupsCheckTickDelay
			CalculateBiterSelectionProbabilities()
			for i=1, maxBiterGroups do
				local thisGroupStartPos = {
					x = groupStartPos.x - (waveDepthCount * 6 * biterGroupTileLength),
					y = groupStartPos.y + (waveWidthCount * biterGroupTileWidth)
				}
				
				local biterGroup = CreateBiterGroup(thisGroupStartPos)
				local groupMembers = SpawnBitersInGroup(biterGroup, thisGroupStartPos, biterGroupSize)
				if _usingRampantAI then
					remote.call("rampant", "registerUnitGroup", biterGroup)
				else
					local finalAttackAreaTarget = FindAttackAreaTarget(waveWidthCount)
					BiterGroupAttackMoveArea(biterGroup, FindMoveTarget(waveWidthCount, waveDepthCount), finalAttackAreaTarget)
					table.insert(BiterGroups, {triggerTick = triggerTick, group = biterGroup, startPos = thisGroupStartPos, members = groupMembers})
				end
				
				waveWidthCount = waveWidthCount + 1
				if waveWidthCount == biterWaveGroupsWide then
					waveWidthCount = 0
					waveDepthCount = waveDepthCount + 1
				end
			end
			if not _usingRampantAI then
				script.on_nth_tick(triggerTick, function() MonitorBiterGroups() end)
			end
		]]
		end
	end,
	
	GetBiterLocationSquadsForWave = function()
		--get how many biter squads are to be in this wave and mark them as done on the funded biters list
		local biterSquadsCount = 0
		local partialBiterSquadFunding = {} -- {funding dict Id = amount}
		local partialFundingAmount = 0
		local completeBiterSquads = {} -- {location name = squad count}
		for id, fundingEntry in pairs(StateDict.fundedBitersQueuedDict) do
			if not fundingEntry.completed then
				local fundingAvailable = fundingEntry.funding - fundingEntry.fundingDone
				local whollyFunded = math.floor(fundingAvailable / ModSettingsDict.biterSquadCost)
				if whollyFunded > 0 then
					for whollyFundedCount=1, whollyFunded do
						if BiterWave.BiterSquadCountBelowLimits(biterSquadsCount) then
							local location = fundEntity.spawnLocationName
							if location == nil then location = Constants.randomLocation
							completeBiterSquads[location] = completeBiterSquads[location] + 1
							biterSquadsCount = biterSquadsCount + 1
							fundingEntry.fundingDone = fundingEntry.fundingDone + ModSettingsDict.biterSquadCost
							if fundingEntry.fundingDone == fundingEntry.funding then
								fundingEntry.completed = true
							end
						else
							break
						end
					end
				end
				if not BiterWave.BiterSquadCountBelowLimits(biterSquadsCount) then break end
				local partialFunding = fundingAvailable % ModSettingsDict.biterSquadCost
				if partialFunding > 0 then
					partialFundingAmount = partialFundingAmount + partialFunding
					if partialFundingAmount >= ModSettingsDict.biterSquadCost then
						for fundingId, amount in pairs(partialBiterSquadFunding) do
							local partialFundingEntity = StateDict.fundedBitersQueuedDict[fundingId]
							partialFundingEntity.fundingDone = partialFundingEntity.fundingDone + amount
							if partialFundingEntity.fundingDone == partialFundingEntity.funding then
								partialFundingEntity.completed = true
							end
						end
						biterSquadsCount = biterSquadsCount + 1
						completeBiterSquads[Constants.randomLocation] = completeBiterSquads[Constants.randomLocation] + 1
						partialFundingAmount = partialFundingAmount - ModSettingsDict.biterSquadCost
						local thispartialFundingEntity = StateDict.fundedBitersQueuedDict[id]
						thispartialFundingEntity.fundingDone = thispartialFundingEntity.fundingDone + (partialFunding - partialFundingAmount)
						if thispartialFundingEntity.fundingDone == thispartialFundingEntity.funding then
							thispartialFundingEntity.completed = true
						end
					end
					partialBiterSquadFunding[id] = partialFunding
				end
				if not BiterWave.BiterSquadCountBelowLimits(biterSquadsCount) then break end
			end
		end
		
		--make random to join location with largest squad number, otherwise all squads to a randomly selected location
		local largestLocationName = nil
		local largestLocationCount = 0
		for name, count in pairs(completeBiterSquads) do
			if name ~= Constants.randomLocation and count > largestLocationCount then
				largestLocationName = name
			end
		end
		if largestLocationName ~= nil then
			completeBiterSquads[largestLocationName] = completeBiterSquads[largestLocationName] + completeBiterSquads[Constants.randomLocation]
			completeBiterSquads[Constants.randomLocation] = nil
		else
			largestLocationName = StateDict.biterWaveSpawnLocationNameArray[math.random(#StateDict.biterWaveSpawnLocationNameArray)]
			completeBiterSquads[largestLocationName] = biterSquadsCount
			completeBiterSquads[Constants.randomLocation] = nil
		end
		
		return completeBiterSquads
	end,
	
	BiterSquadCountBelowLimits = function(biterSquadsCount)
		if biterSquadsCount >= ModSettingsDict.biterWaveMaxSquads then return false end
		if (biterSquadsCount * StateDict.biterSquadCurrentSize) >= ModSettingsDict.biterWaveMaxUnits then return false end
		return true
	end,
	
	FindBiterGatherPoint = function()
		--TODO
		--get the location for the squads
	end
}


garry.hawksworth@icloud.com