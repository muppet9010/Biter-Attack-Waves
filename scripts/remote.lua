Remote = {

	Register = function()
		remote.add_interface(
			"Biter Attack Waves",
			{
				IncreaseMaxBiterWaveSize = Remote.IncreaseMaxBiterWaveSize,
				GetBiterWaveMaxSize = Remote.GetBiterWaveMaxSize,
				SetBiterWaveMaxSize = Remote.SetBiterWaveMaxSize,
				AddQueuedBiters = BiterWave.AddQueuedBiters
			}
		)
	end,

	IncreaseMaxBiterWaveSize = function(amountInput)
		amount = tonumber(amountInput)
		if amount == nil then
			Utility.LogPrint("Remote IncreaseMaxBiterWaveSize called with non number: " .. tostring(amountInput))
			return
		end
		amount = Utility.RoundNumberToDecimalPlaces(amount, 0)
		return BiterWave.IncreaseCurrentBiterWaveMaxSize(amount)
	end,

	GetBiterWaveMaxSize = function()
		return BiterWave.GetCurrentBiterWaveMaxSize()
	end,

	SetBiterWaveMaxSize = function(amountInput)
		amount = tonumber(amountInput)
		if amount == nil then
			Utility.LogPrint("Remote SetCurrentBiterWaveMaxSize called with non number: " .. tostring(amountInput))
			return
		end
		amount = Utility.RoundNumberToDecimalPlaces(amount, 0)
		return BiterWave.SetCurrentBiterWaveMaxSize(amount)
	end,

	AddQueuedBiters = function(quantityInput, spawnLocationText, sponsorName)
		quantity = tonumber(quantityInput)
		if quantity == nil then
			Utility.LogPrint("Remote AddQueuedBiters called with non number: " .. tostring(quantityInput))
			return
		end
		return BiterWave.AddQueuedBiters(quantity, spawnLocationText, sponsorName)
	end
	
}