require("scripts/utility")
require("scripts/globals")
require("scripts/settingsmanager")



OnStartup = function()
	Globals.CreateGlobals()
	Globals.ReferenceGlobals()
	SettingsManager.UpdateSetting(nil)
end

OnLoad = function()
	Globals.ReferenceGlobals()
end

OnSettingChanged = function(event)
	SettingsManager.UpdateSetting(event.setting)
end




script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_configuration_changed(OnStartup)