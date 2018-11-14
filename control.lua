require("scripts/constants")
require("scripts/utility")
require("scripts/globals")
require("scripts/gui")

require("scripts/settingsmanager")
require("scripts/biterwave")
require("scripts/spawnlocations")

require("scripts/remote")



OnStartup = function()
	Globals.CreateGlobals()
	SettingsManager.UpdateSetting(nil)
	Remote.Register()
end

OnLoad = function()
	Globals.ReferenceGlobals()
	Remote.Register()
end

OnSettingChanged = function(event)
	SettingsManager.UpdateSetting(event.setting)
end

OnPlayerCreated = function(event)
	local player = game.players[event.player_index]
	Gui.PlayerRefreshAll(player)
end

OnPlayerJoinedGame = function(event)
	local player = game.players[event.player_index]
	Gui.PlayerRefreshAll(player)
end

OnGuiClicked = function(event)
	Gui.PlayerGuiClicked(event)
end




script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_configuration_changed(OnStartup)
script.on_event({defines.events.on_player_created}, OnPlayerCreated)
script.on_event({defines.events.on_player_joined_game}, OnPlayerJoinedGame)
script.on_event({defines.events.on_gui_click}, OnGuiClicked)