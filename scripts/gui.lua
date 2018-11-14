require("scripts/guistyle")
require("scripts/guibiterqueuemanager")

Gui = {
	
	--[[
		Only update connected player GUIs. On join/reconnect all old GUIs other than top will be removed. The player can then put them back if desired and this will add new ones. Disconnected players will be left with their old GUIs and data in save file.
		
		biterWaveModButtonFlow (vertical) = {
			biterWaveModButton
		}
		biterWaveModFlow (horizontal) = {
			biterWaveMenuFrame = {
				[GUI SECTION MENU BUTTONS]
			}
			GUI FRAME OPENED BY SPECIFIC GUI)
		}
	]]
	
	PlayerGuiClicked = function(event)
		local player = game.players[event.player_index]
		if event.element.name == "biterWaveModButton" then
			Gui.PlayerToggleModFlow(player)
			return
		end
		if GuiBiterQueueManager.PlayerGuiClicked(event, player) then return end
	end,
	
	

	PlayerRefreshAll = function(player)
		Gui.PlayerReplaceBiterWaveGui(player)
		--TODO: Refresh any pinned GUIs
	end,

	PlayerReplaceBiterWaveGui = function(player)
		if player.gui.left.biterWaveModButtonFlow then player.gui.left.biterWaveModButtonFlow.destroy() end
		GuiPlayerElemDict[player.index] = {}
		GuiPlayerElemDict[player.index]["biterWaveModButtonFlow"] = player.gui.left.add{type = "flow", name = "biterWaveModButtonFlow", direction = "vertical"}
		GuiStyle.Padding.Left4(GuiPlayerElemDict[player.index]["biterWaveModButtonFlow"])
		local biterWaveModButton = GuiPlayerElemDict[player.index]["biterWaveModButtonFlow"].add{type = "button", name = "biterWaveModButton", caption = {"description.biterWaveModButton-caption"}, tooltip={"description.biterWaveModButton-tooltip"}}
		GuiStyle.Padding.All2(biterWaveModButton)
	end,

	
	
	PlayerToggleModFlow = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveModFlow"] then
			Gui.PlayerCloseModFlow(player)
		else
			Gui.PlayerAddModFlow(player)
		end
	end,

	PlayerAddModFlow = function(player)
		GuiPlayerElemDict[player.index]["biterWaveModFlow"] = player.gui.left.add{type = "flow", name = "biterWaveModFlow", direction = "horizontal"}
		GuiStyle.Padding.Left4(GuiPlayerElemDict[player.index]["biterWaveModFlow"])
		Gui.PlayerAddMenuFrame(player)
	end,
	
	PlayerCloseModFlow = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveModFlow"] then GuiPlayerElemDict[player.index]["biterWaveModFlow"].destroy() end
		GuiPlayerElemDict[player.index]["biterWaveModFlow"] = nil
		Gui.PlayerCloseMenuFrame(player)
		Gui.PlayerCloseOpenContents(player)
	end,
	
	
	
	PlayerAddMenuFrame = function(player)
		GuiPlayerElemDict[player.index]["biterWaveMenuFrame"] = GuiPlayerElemDict[player.index]["biterWaveModFlow"].add{type = "frame", name = "biterWaveMenuFrame", direction = "vertical"}
		GuiStyle.Padding.All8(GuiPlayerElemDict[player.index]["biterWaveMenuFrame"])
		GuiBiterQueueManager.PlayerAddQueueManagerButton(player)
	end,
	
	PlayerCloseMenuFrame = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveMenuFrame"] then GuiPlayerElemDict[player.index]["biterWaveMenuFrame"].destroy() end
		GuiPlayerElemDict[player.index]["biterWaveMenuFrame"] = nil
	end,
	
	
	
	PlayerCloseOpenContents = function(player)
		if GuiPlayerElemDict[player.index]["CloseOpenContents"] then GuiPlayerElemDict[player.index]["CloseOpenContents"](player) end
	end
}