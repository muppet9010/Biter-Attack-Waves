Remote = {

	Register = function()
		remote.add_interface(
			"BiterAttackWaves",
			{
				FundIncreaseAttackSize = Remote.FundIncreaseAttackSize,
				FundBiterSquad = BiterWave.FundBiterSquad,
				FundIncreaseEvolution = Remote.FundIncreaseEvolution
			}
		)
	end,

	FundIncreaseAttackSize = function(streamerPlayerName, fundingInput, sponsorName)
		funding = tonumber(fundingInput)
		if funding == nil then
			Utility.LogPrint("Remote FundIncreaseAttackSize called with non number funding amount: " .. tostring(fundingInput))
			return
		end
		return BiterWave.FundIncreaseAttackSize(streamerPlayerName, funding, sponsorName)
	end,

	FundBiterSquad = function(streamerPlayerName, fundingInput, spawnLocationText, sponsorName)
		funding = tonumber(fundingInput)
		if funding == nil then
			Utility.LogPrint("Remote FundBiterSquad called with non number funding amount: " .. tostring(fundingInput))
			return
		end
		return BiterWave.FundBiterSquad(streamerPlayerName, funding, spawnLocationText, sponsorName)
	end,

	FundIncreaseEvolution = function(streamerPlayerName, fundingInput, sponsorName)
		funding = tonumber(fundingInput)
		if funding == nil then
			Utility.LogPrint("Remote FundIncreaseEvolution called with non number funding amount: " .. tostring(fundingInput))
			return
		end
		return Evolution.FundIncreaseEvolution(streamerPlayerName, funding, sponsorName)
	end
	
}