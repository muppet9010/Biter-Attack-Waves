GuiBiterQueueManager = {

	--[[
	biterQueueButton
	
	biterWaveQueueManagerFrame = {
		biterWaveQueueManagerTitle
		biterWaveQueueManagerQueueScroll = {
			biterWaveQueueManagerQueueTable = {
				
			}
		}
	}	
	]]

	PlayerGuiClicked = function(event, player)
		if event.element.name == "biterQueueManagerButton" then
			GuiBiterQueueManager.PlayerToggleBiterQueueManager(player)
			return true
		else
			return false
		end
	end,

	PlayerAddQueueManagerButton = function(player)
		local biterQueueManagerButton = GuiPlayerElemDict[player.index]["biterWaveMenuFrame"].add{type = "button", name = "biterQueueManagerButton", caption = {"description.biterQueueManagerButton-caption"}, tooltip={"description.biterQueueManagerButton-tooltip"}}
		GuiStyle.Padding.All2(biterQueueManagerButton)
	end,
	
	PlayerToggleBiterQueueManager = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"] then
			GuiBiterQueueManager.PlayerCloseQueueManager(player)
		else
			Gui.PlayerCloseOpenContents(player)
			GuiBiterQueueManager.PlayerAddBiterQueueManager(player)
		end
	end,

	PlayerAddBiterQueueManager = function(player)
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"] = GuiPlayerElemDict[player.index]["biterWaveModFlow"].add{type = "frame", name = "biterWaveQueueManagerFrame", direction = "vertical"}
		GuiPlayerElemDict[player.index]["CloseOpenContents"] = GuiBiterQueueManager.PlayerCloseQueueManager
		local biterWaveQueueManagerTitle = GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"].add{type = "label", name = "biterWaveQueueManagerTitle", caption = {"description.biterWaveQueueManagerTitle-caption"}}
		local biterWaveQueueManagerQueueScroll = GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"].add{type = "scroll-pane", name = "biterWaveQueueManagerQueueScroll", horizontal_scroll_policy = "never", vertical_scroll_policy = "auto"}
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"].style.maximal_width = 400
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"].style.maximal_height = 400
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"] = biterWaveQueueManagerQueueScroll.add{type = "table", name = "biterWaveQueueManagerQueueTable", column_count = 5}
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].style.cell_spacing = 8
		GuiBiterQueueManager.PlayerUpdateQueueManagerQueueTableContents(player)
	end,
	
	PlayerCloseQueueManager = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"] then GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"].destroy() end
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerFrame"] = nil
		GuiPlayerElemDict[player.index]["CloseOpenContents"] = nil
		GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"] = nil
	end,
	
	PlayerUpdateQueueManagerQueueTableContents = function(player)
		if GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"] == nil then return end
		for i, elm in pairs(GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].children) do
			elm.destroy()
		end
		local headerState = GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_header_state", caption = {"description.biterWaveQueueManagerTableState-caption"}, tooltip={"description.biterWaveQueueManagerTableState-tooltip"}}
		GuiStyle.Font.NormalBold(headerState)
		local headerTargetPlayerName = GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_header_targetPlayerName", caption = {"description.biterWaveQueueManagerTableTargetPlayer-caption"}}
		GuiStyle.Font.NormalBold(headerTargetPlayerName)
		local headerFunding = GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_header_quantity", caption = {"description.biterWaveQueueManagerTableFunding-caption"}, tooltip={"description.biterWaveQueueManagerTableFunding-tooltip"}}
		GuiStyle.Font.NormalBold(headerFunding)
		local headerSpawnLocationName = GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_header_spawnLocationName", caption = {"description.biterWaveQueueManagerTableSpawnLocation-caption"}}
		GuiStyle.Font.NormalBold(headerSpawnLocationName)
		local headerSponsorName = GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_header_sponsorName", caption = {"description.biterWaveQueueManagerTableSponsor-caption"}}
		GuiStyle.Font.NormalBold(headerSponsorName)
		for id, queuedDetails in pairs(StateDict.fundedBitersQueuedDict) do
			GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_" .. id .. "_state", caption = tostring(queuedDetails.completed)}
			GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_" .. id .. "_targetPlayerName", caption = tostring(queuedDetails.targetPlayerName)}
			GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_" .. id .. "_quantity", caption = tostring(queuedDetails.funding) .. "(" .. tostring(queuedDetails.fundingDone) .. ")"}
			GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_" .. id .. "_spawnLocationName", caption = tostring(queuedDetails.spawnLocationName)}
			GuiPlayerElemDict[player.index]["biterWaveQueueManagerQueueTable"].add{type = "label", name = "biterWaveQueue_" .. id .. "_sponsorName", caption = tostring(queuedDetails.sponsorName)}
		end
	end

}