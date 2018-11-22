Evolution = {

	--[[
	StateDict.fundedEvolutionDict = {
		id (int) = {
			id (int)
			streamerPlayerName (string)
			funding (int)
			sponsorName (string)
		}
	}
	
	StateDict.evolutionScaleArray = {
		maxEvo (double)
		cost (double)
		increase (double)
	}
	]]
	
	CreateGlobals = function()
		if StateDict.fundedEvolutionDict == nil then StateDict.fundedEvolutionDict = {} end
		if StateDict.evolutionScaleArray == nil then StateDict.evolutionScaleArray = {} end
		if StateDict.currentFundedEvolution == nil then StateDict.currentFundedEvolution = 0 end
	end,
	
	UpdateEvolutionScale = function()
		local debugging = false
		local evolutionText = ModSettingsDict.biterWaveEvolutionString
		if evolutionText == nil or evolutionText == "" or evolutionText == "{}" then
			if debugging then Utility.LogPrint("Blank or Empty Evolution Setting, will not override vanilla") end
			StateDict.currentFundedEvolution = -1
			return
		end
		if debugging then Utility.LogPrint(evolutionText) end
		local success, evolutionScale = pcall(function() return loadstring("return " .. evolutionText )() end)
		if debugging then Utility.LogPrint(tostring(success) .. " : " .. tostring(evolutionScale)) end
		if not success or type(evolutionScale) ~= "table" or Utility.GetTableLength(evolutionScale) == 0 then
			Utility.LogPrint("Evolution Scale Failed To Process, mod setting not valid table")
			StateDict.currentFundedEvolution = -1
			return
		end
		local success, evolutionScale, errorMessage = Evolution.StandardiseEvolutionScaleTable(evolutionScale)
		if not success then
			Utility.LogPrint("Evolution Scale Failed To Process: " .. errorMessage)
			StateDict.currentFundedEvolution = -1
			return
		end
		if debugging then Utility.LogPrint(Utility.TableContentsToString(evolutionScale, "evolutionScale")) end
		StateDict.evolutionScaleDict = evolutionScale
		Evolution.CalculateFundedEvolution()
	end,
	
	StandardiseEvolutionScaleTable = function(evolutionScale)
		local cleanEvolutionScale = {}
		for i, data in pairs(evolutionScale) do
			local newMaxEvo = tonumber(data.maxEvo)
			if newMaxEvo == nil then
				return false, nil, "entry " .. tostring(i) .. " maxEvo not number: ".. tostring(data.maxEvo)
			end
			
			local newCost = tonumber(data.cost)
			if newCost == nil then
				return false, nil, "entry " .. tostring(i) .. " cost not number: ".. tostring(data.cost)
			end
			
			local newIncrease = tonumber(data.increase)
			if newIncrease == nil then
				return false, nil, "entry " .. tostring(i) .. " increase not number: ".. tostring(data.increase)
			end
			
			table.insert(cleanEvolutionScale, {
				maxEvo = newMaxEvo,
				cost = newCost,
				increase = newIncrease
			})
		end
		return true, cleanEvolutionScale
	end,

	FundIncreaseEvolution = function(streamerPlayerName, funding, sponsorName)
		local id = Utility.GetMaxKey(StateDict.fundedEvolutionDict) + 1
		local streamerName = Streamer.GetStreamNameFromText(streamerPlayerName, " Fund Increase Evolution")
		table.insert(StateDict.fundedEvolutionDict, {
			id = id,
			streamerPlayerName = streamerName,
			funding = funding,
			sponsorName = sponsorName
		})
		Evolution.CalculateFundedEvolution()
	end,
	
	CalculateFundedEvolution = function()
		if StateDict.currentFundedEvolution == -1 then return end
		local debugging = false
		local sharedEvolution = 0
		
		for streamerPlayerName, placeHolder in pairs(StateDict.streamerNameDict) do
			local totalFunding = Evolution.GetFundingTotalForStreamer(streamerPlayerName)
			local remainingFunding = totalFunding
			local playerEvolution = 0
			if debugging then Utility.LogPrint("streamerPlayerName: " .. streamerPlayerName .. " - totalFunding: " .. totalFunding) end
			if remainingFunding > 0 then
				for i, evolutionScale in pairs(StateDict.evolutionScaleDict) do
					if debugging then Utility.LogPrint("maxEvo: " .. evolutionScale.maxEvo .. " - cost: " .. evolutionScale.cost .. " - increase: " .. evolutionScale.increase) end
					local evoScaleRange = evolutionScale.maxEvo - playerEvolution
					local evoScaleMaxUnits = evoScaleRange / evolutionScale.increase
					if debugging then Utility.LogPrint("evoScaleMaxUnits: " .. evoScaleMaxUnits) end 
					if remainingFunding > (evolutionScale.cost * evoScaleMaxUnits) then
						playerEvolution = evolutionScale.maxEvo
						remainingFunding = remainingFunding - (evolutionScale.cost * evoScaleMaxUnits)
						if debugging then Utility.LogPrint("full range funding, remainingFunding: " .. remainingFunding) end
					else
						local potentialUnitsFunded = math.floor(remainingFunding / evolutionScale.cost)
						local unitsFunded = math.min(potentialUnitsFunded, evoScaleMaxUnits)
						playerEvolution = playerEvolution + (unitsFunded * evolutionScale.increase)
						if debugging then Utility.LogPrint("partial funding, unitsFunded: " .. unitsFunded .. " - playerEvolution: " .. playerEvolution) end
						break
					end
				end
				sharedEvolution = sharedEvolution + playerEvolution
			end
		end
		
		StateDict.currentFundedEvolution = sharedEvolution
		if debugging then Utility.LogPrint("sharedEvolution: " .. sharedEvolution) end
		Evolution.ApplyFundedEvolution()
	end,
	
	GetFundingTotalForStreamer = function(streamerPlayerName)
		local totalFunding = 0
		for i, fundEntry in pairs(StateDict.fundedEvolutionDict) do
			if fundEntry.streamerPlayerName == streamerPlayerName then
				totalFunding = totalFunding + fundEntry.funding
			end
		end
		return totalFunding
	end,
	
	ApplyFundedEvolution = function()
		if StateDict.currentFundedEvolution == -1 then return end
		game.forces.enemy.evolution_factor = StateDict.currentFundedEvolution
	end
	
}