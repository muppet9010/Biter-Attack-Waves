GuiBiterQueue = {

	--[[
	biterQueueButton
	
	biterQueueManagerFrame = {
		
	}	
	]]

	PlayerGuiClicked = function(event, player)
		if event.element.name == "biterQueueButton" then
			GuiBiterQueue.PlayerToggleBiterQueueManager(player)
			return true
		else
			return false
		end
	end,

	PlayerAddQueueButton = function(player)
		local biterQueueButton = GuiPlayerElemDict[player.index]["toolbarContentsFrame"].add{type = "button", name = "biterQueueButton", caption = {"description.biterQueueButton-caption"}, tooltip={"description.biterQueueButton-tooltip"}}
		GuiStyle.Padding.All2(biterQueueButton)
	end,
	
	PlayerToggleBiterQueueManager = function(player)
		if GuiPlayerElemDict[player.index]["biterQueueManagerFrame"] then
			GuiBiterQueue.PlayerCloseQueueManager(player)
		else
			GuiBiterQueue.PlayerAddBiterQueueManager(player)
		end
	end,

	PlayerAddBiterQueueManager = function(player)
		GuiPlayerElemDict[player.index]["biterQueueManagerFrame"] = GuiPlayerElemDict[player.index]["toolbarContentsFrame"].add{type = "frame", name = "biterQueueManagerFrame", direction = "vertical"}
		GuiPlayerElemDict[player.index]["biterQueueManagerFrame"].add{type = "label", name = "test", caption = {"description.test"}}
	end,
	
	PlayerCloseQueueManager = function(player)
		if GuiPlayerElemDict[player.index]["biterQueueManagerFrame"] then GuiPlayerElemDict[player.index]["biterQueueManagerFrame"].destroy() end
		GuiPlayerElemDict[player.index]["biterQueueManagerFrame"] = nil
	end

}