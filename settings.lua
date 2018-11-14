data:extend({
	{
		name = "biter-wave-game-start-safety-seconds",
		type = "int-setting",
		default_value = 1800,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1001"
	},
	{
		name = "biter-wave-cooldown-seconds",
		type = "int-setting",
		default_value = 300,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1002"
	},
	{
		name = "biter-wave-player-death-safety-seconds",
		type = "int-setting",
		default_value = 60,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1003"
	},
	
	
	{
		name = "biter-wave-minimum-size",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1101"
	},
	{
		name = "biter-wave-starting-max-size",
		type = "int-setting",
		default_value = -1,
		minimum_value = -1,
		setting_type = "runtime-global",
		order = "1102"
	},
	{
		name = "biter-wave-group-max-size",
		type = "int-setting",
		default_value = 100,
		minimum_value = 10,
		setting_type = "runtime-global",
		order = "1103"
	},
	{
		name = "biter-wave-max-groups-wide",
		type = "int-setting",
		default_value = -1,
		minimum_value = -1,
		setting_type = "runtime-global",
		order = "1104"
	},
	{
		name = "biter-wave-spawn-locations",
		type = "string-setting",
		default_value = "{}",
		allow_balnk = false,
		setting_type = "runtime-global",
		order = "1105"
	},
})



if mods["Rampant"] ~= nil then
	data:extend({
		{
			name = "biter-wave-rampant-controls-biters",
			type = "bool-setting",
			default_value = false,
			setting_type = "runtime-global",
			order = "1901"
		},
	})
end