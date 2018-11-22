Streamer = {

	CreateGlobals = function()
		if StateDict.streamerNameList == nil then StateDict.streamerNameList = {} end
	end,
	
	UpdateStreamerNameList = function()
		local debugging = false
		local streamerText = ModSettingsDict.streamerNameListString
		if streamerText == nil or streamerText == "" or streamerText == "{}" then
			if debugging then Utility.LogPrint("Blank or Empty Streamer Name Setting, no funding will work") end
			return
		end
		if debugging then Utility.LogPrint(streamerText) end
		local success, streamerNameList = pcall(function() return loadstring("return " .. streamerText )() end)
		if debugging then Utility.LogPrint(tostring(success) .. " : " .. tostring(streamerNameList)) end
		if not success or type(streamerNameList) ~= "table" or Utility.GetTableLength(streamerNameList) == 0 then
			Utility.LogPrint("Streamer Name List Failed To Process, mod setting not valid table")
			return
		end
		local success, streamerNameList, errorMessage = Streamer.StandardiseNameListTable(streamerNameList)
		if not success then
			Utility.LogPrint("Evolution Scale Failed To Process: " .. errorMessage)
			return
		end
		if debugging then Utility.LogPrint(Utility.TableContentsToString(streamerNameList, "streamerNameList")) end
		StateDict.streamerNameList = streamerNameList
	end,
	
	StandardiseNameListTable = function(streamerNameList)
		for i, name in pairs(streamerNameList) do
			if name == nil or name == "" then
				return false, nil, "entry " .. tostring(i) .. " name blank: ".. tostring(name)
			end
		end
		return true, streamerNameList
	end

}