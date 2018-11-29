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
		StateDict.enemyForce = game.forces["enemy"]
		if StateDict.biterGroups == nil then StateDict.biterGroups = {} end
		if StateDict.biterWaveTargetPosition == nil then StateDict.biterWaveTargetPosition = {x = 0, y = 0} end
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
			if debugging then Utility.LogPrint("Missing a Biter Setting, NO Biter Squad Size Update done") end
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
		if StateDict.nextWaveDispatchTick == nil or StateDict.nextWaveDispatchTick > StateDict.currentTick then return end
		
		BiterWave.CreateBiterWave()
		
		StateDict.lastWaveDispatchedTick = StateDict.currentTick
		StateDict.playerDeathsThisWave = 0
		BiterWave.CalculateNextWaveDispatchTiming()
	end,
	
	CalculateNextWaveDispatchTiming = function()
		local debugging = false
		if debugging then Utility.LogPrint(tostring(ModSettingsDict.biterWaveGameStartSafetyTicks) .. " - " .. tostring(ModSettingsDict.biterWaveCooldownTicks) .. " - " .. tostring(ModSettingsDict.biterWavePlayerDeathSafetyTicks)) end
		if ModSettingsDict.biterWaveGameStartSafetyTicks == nil or ModSettingsDict.biterWaveCooldownTicks == nil or ModSettingsDict.biterWavePlayerDeathSafetyTicks == nil then
			if debugging then Utility.LogPrint("Missing a Biter Wave Timer Setting, NO Biter Wave Dispatch Check Done") end
			return
		end
	
		local nextWaveTick = StateDict.lastWaveDispatchedTick
		if StateDict.lastWaveDispatchedTick == 0 then
			nextWaveTick = nextWaveTick + ModSettingsDict.biterWaveGameStartSafetyTicks
		end
		nextWaveTick = nextWaveTick + ModSettingsDict.biterWaveCooldownTicks
		nextWaveTick = nextWaveTick + (StateDict.playerDeathsThisWave * ModSettingsDict.biterWavePlayerDeathSafetyTicks)
		StateDict.nextWaveDispatchTick = nextWaveTick
	end,
	
	CreateBiterWave = function()
		local rawBiterLocationSquads = BiterWave.GetWholelyFundedBiterSquadsByLocation()
		if Utility.GetTableLength(rawBiterLocationSquads) == 0 then return end
		local standardisedBiterLocationSquads = BiterWave.StandardiseBiterLocationSquads(rawBiterLocationSquads)
		
		local triggerTick = StateDict.currentTick + 120
		for location, squadCount in pairs(standardisedBiterLocationSquads) do
			local biterCount = squadCount * StateDict.biterSquadCurrentSize
			local biterGroupMax = math.ceil(biterCount / ModSettingsDict.biterWaveGroupMaxSize)
			local biterWaveGroupsWide = ModSettingsDict.biterWaveMaxGroupsWide
			if biterGroupMax < biterWaveGroupsWide then
				biterWaveGroupsWide = biterGroupMax
			end
			local biterGroupSize = math.ceil(biterCount / biterGroupMax)
			local biterGroupTileWidth = 20
			local biterGroupTileLength = math.sqrt(ModSettingsDict.biterWaveGroupMaxSize)
			if biterGroupMax > 20 then
				game.print("too many attack groups will lag the game - stopped")
				return
			end
			
			local waveWidthCount = 0
			local waveDepthCount = 0
			for i=1, biterGroupMax do
				local thisGroupStartPos = BiterWave.GetSpecificGroupLocationForGeneralLocation(StateDict.biterWaveSpawnLocationsDict[location].position, StateDict.biterWaveSpawnLocationsDict[location].facing, waveDepthCount, biterGroupTileLength, waveWidthCount, biterWaveGroupsWide, biterGroupTileWidth)				
				local biterGroup = BiterWave.CreateBiterGroup(thisGroupStartPos)
				local groupMembers = BiterWave.SpawnBitersInGroup(biterGroup, thisGroupStartPos, biterGroupSize)
				if ModSettingsDict.rampantControlBiterWave then
					remote.call("rampant", "registerUnitGroup", biterGroup)
				else
					BiterWave.BiterGroupAttackMoveArea(biterGroup, BiterWave.GetSpecificGroupLocationForGeneralLocation(StateDict.biterWaveTargetPosition, StateDict.biterWaveSpawnLocationsDict[location].facing, waveDepthCount, biterGroupTileLength, waveWidthCount, biterWaveGroupsWide, biterGroupTileWidth), StateDict.biterWaveTargetPosition)
					table.insert(StateDict.biterGroups, {triggerTick = triggerTick, group = biterGroup, startPos = thisGroupStartPos, members = groupMembers})
				end
				
				waveWidthCount = waveWidthCount + 1
				if waveWidthCount == biterWaveGroupsWide then
					waveWidthCount = 0
					waveDepthCount = waveDepthCount + 1
				end
			end
			if not ModSettingsDict.rampantControlBiterWave then
				script.on_nth_tick(triggerTick, BiterWave.MonitorBiterGroups)
			end
		end
	end,
	
	GetWholelyFundedBiterSquadsByLocation = function()
		local debug = false
		local biterSquadsCount = 0
		local partialBiterSquadFunding = {} -- {funding dict Id = amount}
		local partialFundingAmount = 0
		local completeBiterSquads = {} -- {location name = squad count}
		if debug then Utility.LogPrint(Utility.TableContentsToString(StateDict.fundedBitersQueuedDict, "StateDict.fundedBitersQueuedDict")) end
		for id, fundingEntry in pairs(StateDict.fundedBitersQueuedDict) do
			if debug then Utility.LogPrint("id: " .. id) end
			if debug then Utility.LogPrint("completed: " .. tostring(fundingEntry.completed)) end
			if not fundingEntry.completed then
				local fundingAvailable = fundingEntry.funding - fundingEntry.fundingDone
				if debug then Utility.LogPrint("fundingAvailable: " .. fundingAvailable) end
				local whollyFunded = math.floor(fundingAvailable / ModSettingsDict.biterSquadCost)
				if debug then Utility.LogPrint("whollyFunded: " .. whollyFunded) end
				if whollyFunded > 0 then
					for whollyFundedCount=1, whollyFunded do
						if debug then Utility.LogPrint("whollyFundedCount: " .. whollyFundedCount) end
						if BiterWave.BiterSquadCountBelowLimits(biterSquadsCount) then
							if debug then Utility.LogPrint("BiterSquadCountBelowLimits: true") end
							local location = fundingEntry.spawnLocationName
							if location == nil then location = Constants.randomLocation end
							if debug then Utility.LogPrint("location: " .. location) end
							if completeBiterSquads[location] == nil then completeBiterSquads[location] = 0 end
							completeBiterSquads[location] = completeBiterSquads[location] + 1
							if debug then Utility.LogPrint("completeBiterSquads[location]: " .. completeBiterSquads[location]) end
							biterSquadsCount = biterSquadsCount + 1
							fundingEntry.fundingDone = fundingEntry.fundingDone + ModSettingsDict.biterSquadCost
							if fundingEntry.fundingDone == fundingEntry.funding then
								fundingEntry.completed = true
							end
						else
							if debug then Utility.LogPrint("BiterSquadCountBelowLimits: false") end
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
		if debug then Utility.LogPrint(Utility.TableContentsToString(completeBiterSquads, "completeBiterSquads")) end
		return completeBiterSquads
	end,
	
	StandardiseBiterLocationSquads = function(completeBiterSquads)
		if completeBiterSquads[Constants.randomLocation] ~= nil then
			local largestLocationName = nil
			local largestLocationCount = 0
			for name, count in pairs(completeBiterSquads) do
				if name ~= Constants.randomLocation and count > largestLocationCount then
					largestLocationName = name
					largestLocationCount = count
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
		end
		return completeBiterSquads
	end,
	
	BiterSquadCountBelowLimits = function(biterSquadsCount)
		if ModSettingsDict.biterWaveMaxSquads > 0 and biterSquadsCount >= ModSettingsDict.biterWaveMaxSquads then return false end
		if ModSettingsDict.biterWaveMaxUnits > 0 and (biterSquadsCount * StateDict.biterSquadCurrentSize) >= ModSettingsDict.biterWaveMaxUnits then return false end
		return true
	end,
	
	GetSpecificGroupLocationForGeneralLocation = function(position, facing, waveDepthCount, biterGroupTileLength, waveWidthCount, maxWaveWidth, biterGroupTileWidth)
		local forwards = 0 - (waveDepthCount * 6 * biterGroupTileLength)
		local right = (0 - (maxWaveWidth/2) + waveWidthCount) * biterGroupTileWidth
		local offset = Utility.GetNormalisedOffsetForOrientationOffset(facing, forwards, right)
		local newPos = {
			x = position.x + offset.x,
			y = position.y + offset.y 
		}
		return newPos
	end,

	FindAttackAreaTarget = function(location, groupCount)
		local groupTargetBasePos = StateDict.biterWaveTargetPosition
		local facing = StateDict.biterWaveSpawnLocationsDict[location].facing
		local offset = Utility.GetNormalisedOffsetForOrientationOffset(facing, groupCount, 0)
		return {
			x = groupTargetBasePos.x + offset.x,
			y = groupTargetBasePos.y + offset.y
		}
	end,
	
	CreateBiterGroup = function(groupPosition)
		return StateDict.surface.create_unit_group{position = groupPosition, force = StateDict.enemyForce}
	end,

	SpawnBitersInGroup = function(unitGroup, spawnCenterPos, groupSize)
		local members = {}
		for i=1, groupSize do
			local biterType = Evolution.GetBiterType()
			local spawnPos = StateDict.surface.find_non_colliding_position(biterType, spawnCenterPos, 0, 1)
			local biter = StateDict.surface.create_entity{
				name = biterType,
				position = spawnPos,
				force = StateDict.enemyForce
			}
			if not biter then
				Utility.LogPrint("creation of biter" .. i .. "failed")
			else
				unitGroup.add_member(biter)
				table.insert(members, biter)
			end
		end
		return members
	end,
		
	GetBiterGroupAttackAreaCommand = function(targetPos)
		return {
			type = defines.command.attack_area,
			destination = targetPos,
			radius = 10,
			distraction = defines.distraction.by_anything
		}
	end,

	GetBiterGroupMoveCommand = function(moveToPos)
		return {
			type = defines.command.go_to_location,
			destination = moveToPos,
			distraction = defines.distraction.by_anything
		}
	end,

	BiterGroupAttackMoveArea = function(unitGroup, moveToPos, targetPos)
		local command = {
			type = defines.command.compound,
			structure_type = defines.compound_command.return_last,
			commands = {
				BiterWave.GetBiterGroupMoveCommand(moveToPos),
				BiterWave.GetBiterGroupAttackAreaCommand(targetPos)
			}
		}
		unitGroup.set_command(command)
		unitGroup.start_moving()
	end,

	MonitorBiterGroups = function()
		Globals.UpdateGameTick()
		script.on_nth_tick(StateDict.currentTick, nil)
		for i, groupDetails in ipairs(StateDict.biterGroups) do
			if groupDetails.triggerTick <= StateDict.currentTick then
				if not groupDetails.group.valid or groupDetails.group.state ~= defines.group_state.moving then
					BiterWave.RecreateGroupAndAttackTargetDirectly(groupDetails)
				end
				StateDict.biterGroups[i] = nil
			end
		end
	end,

	RecreateGroupAndAttackTargetDirectly = function(groupDetails)
		local groupSize = #groupDetails.members
		local groupStartingPos = groupDetails.startPos
		if groupDetails.group.valid then
			groupDetails.group.destroy()
		end
		for _, member in pairs(groupDetails.members) do
			member.destroy()
		end
		
		local biterGroup = BiterWave.CreateBiterGroup(groupStartingPos)
		BiterWave.SpawnBitersInGroup(biterGroup, groupStartingPos, groupSize)
		biterGroup.set_command(BiterWave.GetBiterGroupAttackAreaCommand(StateDict.biterWaveTargetPosition))
		biterGroup.start_moving()
	end,

	UpdateTargetPosition = function()
		local debugging = false
		local positionText = ModSettingsDict.biterWaveTargetPositionString
		if positionText == nil or positionText == "" or positionText == "{}" then
			Utility.LogPrint("Blank or Empty Biter Wave Target Position Setting, nothing will spawn")
			return
		end
		if debugging then Utility.LogPrint(positionText) end
		local success, position = pcall(function() return loadstring("return " .. positionText )() end)
		if debugging then Utility.LogPrint(tostring(success) .. " : " .. tostring(position)) end
		if not success or type(position) ~= "table" or Utility.GetTableLength(position) == 0 then
			Utility.LogPrint("Biter Wave Target Position Failed To Process, mod setting not valid table")
			return
		end
		local success, position, errorMessage = BiterWave.StandardiseTargetPositionTable(position)
		if not success then
			Utility.LogPrint("Biter Wave Target Position Failed To Process: " .. errorMessage)
			return
		end
		if debugging then Utility.LogPrint(Utility.TableContentsToString(position, "position")) end
		StateDict.biterWaveTargetPosition = position
	end,
	
	StandardiseTargetPositionTable = function(position)
		local cleanPosition = {}
		for key, value in pairs(position) do
			if key == "x" or key == 1 then
				cleanPosition.x = value
			elseif key == "y" or key == 2 then
				cleanPosition.y = value
			else
				return false, nil, "entry " .. tostring(key) .. " invalid value: ".. tostring(value)
			end
		end
		
		if cleanPosition.x == nil then
			return false, nil, "no x coordinate extracted from setting"
		end
		if cleanPosition.y == nil then
			return false, nil, "no y coordinate extracted from setting"
		end
		
		return true, cleanPosition
	end,
	
}