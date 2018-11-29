data:extend({

	{
		name = "biter-wave-streamer-list",
		type = "string-setting",
		default_value = "{ 'Streamer 1 Name', 'Streamer 2 Name'}",
		allow_blank = false,
		setting_type = "runtime-global",
		order = "0001"
	},



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
		name = "biter-wave-max-squads",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1004"
	},
	{
		name = "biter-wave-max-units",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1005"
	},
	{
		name = "biter-wave-spawn-locations",
		type = "string-setting",
		default_value = "{}",
		allow_blank = false,
		setting_type = "runtime-global",
		order = "1006"
	},
	{
		name = "biter-wave-increase-quantity-cost",
		type = "double-setting",
		default_value = 1,
		minimum_value = 0.000001,
		setting_type = "runtime-global",
		order = "1007"
	},
	{
		name = "biter-wave-evolution-scale",
		type = "string-setting",
		default_value = "",
		allow_blank = true,
		setting_type = "runtime-global",
		order = "1008"
	},
	{
		name = "biter-wave-target-position",
		type = "string-setting",
		default_value = "{0,0}",
		allow_blank = false,
		setting_type = "runtime-global",
		order = "1008"
	},
	
	
	
	{
		name = "biter-squad-starting-units",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1101"
	},
	{
		name = "biter-squad-max-units",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1102"
	},
	{
		name = "biter-squad-increase-quantity",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1103"
	},
	{
		name = "biter-squad-cost",
		type = "double-setting",
		default_value = 1,
		minimum_value = 0.000001,
		setting_type = "runtime-global",
		order = "1104"
	},
	
	
	
	{
		name = "biter-group-max-units",
		type = "int-setting",
		default_value = 100,
		minimum_value = 10,
		setting_type = "runtime-global",
		order = "1201"
	},
	{
		name = "biter-group-deployment-width",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1202"
	},
	
	
	
	{
		name = "biter-wave-vanilla-max-group-starting-size",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1802"
	},
	{
		name = "biter-wave-vanilla-max-group-increase-quantity",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1803"
	},
	{
		name = "biter-wave-vanilla-max-group-size-limit",
		type = "int-setting",
		default_value = 0,
		minimum_value = 0,
		setting_type = "runtime-global",
		order = "1804"
	}
	
})