if mods["Rampant"] ~= nil then
	data:extend({
		{
			name = "biter-wave-rampant-controls-biters",
			type = "bool-setting",
			default_value = false,
			setting_type = "runtime-global",
			order = "1901"
		},
		{
			name = "biter-wave-rampant-max-group-starting-size",
			type = "int-setting",
			default_value = 0,
			minimum_value = 0,
			setting_type = "runtime-global",
			order = "1902"
		},
		{
			name = "biter-wave-rampant-max-group-increase-quantity",
			type = "int-setting",
			default_value = 0,
			minimum_value = 0,
			setting_type = "runtime-global",
			order = "1903"
		},
		{
			name = "biter-wave-rampant-max-group-size-limit",
			type = "int-setting",
			default_value = 0,
			minimum_value = 0,
			setting_type = "runtime-global",
			order = "1904"
		}
	})
end