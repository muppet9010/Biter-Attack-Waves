require("scripts/constants")
require("scripts/utility")
require("scripts/globals")
require("scripts/gui")

require("scripts/settingsmanager")
require("scripts/biterwave")
require("scripts/spawnlocations")
require("scripts/evolution")
require("scripts/streamer")
require("scripts/bitersquad")

require("scripts/remote")



local OnStartup = function()
	Globals.CreateGlobals()
	SettingsManager.UpdateSetting(nil)
	Remote.Register()
end

local OnLoad = function()
	Globals.ReferenceGlobals()
	Remote.Register()
end

local OnSettingChanged = function(event)
	SettingsManager.UpdateSetting(event.setting)
end

local OnPlayerCreated = function(event)
	local player = game.players[event.player_index]
	Gui.PlayerRefreshAll(player)
end

local OnPlayerJoinedGame = function(event)
	local player = game.players[event.player_index]
	Gui.PlayerRefreshAll(player)
end

local OnGuiClicked = function(event)
	Gui.PlayerGuiClicked(event)
end

local On1Second = function()
	Evolution.ApplyFundedEvolution()
	BiterWave.CheckBiterWaveDispatchTiming()
end

local OnPlayerDied = function()
	StateDict.playerDeathsThisWave = StateDict.playerDeathsThisWave + 1
end




script.on_init(OnStartup)
script.on_load(OnLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_configuration_changed(OnStartup)
script.on_nth_tick(60, function() On1Second() end)
script.on_event({defines.events.on_player_created}, OnPlayerCreated)
script.on_event({defines.events.on_player_joined_game}, OnPlayerJoinedGame)
script.on_event({defines.events.on_gui_click}, OnGuiClicked)
script.on_event({defines.events.on_player_died}, OnPlayerDied)