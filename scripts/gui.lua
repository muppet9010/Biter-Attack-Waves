require("scripts/guistyle")
require("scripts/guibiterqueue")

Gui = {
	
	--[[
		Only update connected player GUIs. On join/reconnect all old GUIs other than top will be removed. The player can then put them back if desired and this will add new ones. Disconnected players will be left with their old GUIs and data in save file.
		biterWaveFlow = {
			toolbarButton
			toolbarContentsFrame = {
				biterQueueButton
			}
			[OPEN GUIS]
		}
	]]
	
	PlayerGuiClicked = function(event)
		local player = game.players[event.player_index]
		if event.element.name == "toolbarButton" then
			Gui.PlayerToggleToolbarContents(player)
			return
		end
		if GuiBiterQueue.PlayerGuiClicked(event, player) then return end
	end,

	PlayerRefreshAll = function(player)
		Gui.PlayerAddToolbar(player)
		--TODO: Refresh any pinned GUIs
	end,

	PlayerAddToolbar = function(player)
		if player.gui.left.biterWaveFlow then player.gui.left.biterWaveFlow.destroy() end
		GuiPlayerElemDict[player.index] = {}
		GuiPlayerElemDict[player.index]["biterWaveFlow"] = player.gui.left.add{type = "flow", name = "biterWaveFlow", direction = "vertical"}
		GuiStyle.Padding.Left4(GuiPlayerElemDict[player.index]["biterWaveFlow"])
		local toolbarButton = GuiPlayerElemDict[player.index]["biterWaveFlow"].add{type = "button", name = "toolbarButton", caption = {"description.toolbarButton-caption"}, tooltip={"description.toolbarButton-tooltip"}}
		GuiStyle.Padding.All2(toolbarButton)
	end,

	PlayerToggleToolbarContents = function(player)
		if GuiPlayerElemDict[player.index]["toolbarContentsFrame"] then
			Gui.PlayerCloseToolbarContents(player)
		else
			Gui.PlayerAddToolbarContents(player)
		end
	end,

	PlayerAddToolbarContents = function(player)
		GuiPlayerElemDict[player.index]["toolbarContentsFrame"] = GuiPlayerElemDict[player.index]["biterWaveFlow"].add{type = "frame", name = "toolbarContentsFrame", direction = "vertical"}
		GuiStyle.Padding.All8(GuiPlayerElemDict[player.index]["toolbarContentsFrame"])
		GuiBiterQueue.PlayerAddQueueButton(player)
	end,
	
	PlayerCloseToolbarContents = function(player)
		GuiPlayerElemDict[player.index]["toolbarContentsFrame"].destroy()
		GuiPlayerElemDict[player.index]["toolbarContentsFrame"] = nil
		GuiBiterQueue.PlayerCloseQueueManager(player)
	end
}