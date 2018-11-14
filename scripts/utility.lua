Utility = {}

Utility.PositionToString = function(position)
	return "(" .. position.x .. ", " .. position.y ..")"
end

Utility.tablesLogged = {}
Utility.TableContentsToString = function(target_table, name, indent, stop_traversing)
	indent = indent or 1
	local indentstring = string.rep(" ", (indent * 4))
	local table_id = string.gsub(tostring(target_table), "table: ", "")
	Utility.tablesLogged[table_id] = "logged"
	local table_contents = ""
	if Utility.GetTableLength(target_table) > 0 then
		for k,v in pairs(target_table) do
			local key, value = "", ""
			if type(k) == "string" or type(k) == "number" or type(k) == "boolean" then
				key = '"' ..tostring(k) .. '"'
			elseif type(k) == "nil" then
				key = '"nil"'
			elseif type(k) == "table" then
				local sub_table_id = string.gsub(tostring(k), "table: ", "")
				if stop_traversing == true then 
					key = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if Utility.tablesLogged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					key = '{\r\n' .. Utility.TableContentsToString(k, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(k) == "function" then
				key = '"' .. tostring(k) .. '"'
			else
				key = '"unhandled type: ' .. type(k) .. '"'
			end
			if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
				value = '"' .. tostring(v) .. '"'
			elseif type(v) == "nil" then
				value = '"nil"'
			elseif type(v) == "table" then
				local sub_table_id = string.gsub(tostring(v), "table: ", "")
				if stop_traversing == true then 
					value = '"CIRCULAR LOOP TABLE'
				else
					local sub_stop_traversing = nil
					if Utility.tablesLogged[sub_table_id] ~= nil then
						sub_stop_traversing = true
					end
					value = '{\r\n' .. Utility.TableContentsToString(v, name, indent + 1, sub_stop_traversing) .. '\r\n' .. indentstring .. '}'
				end
			elseif type(v) == "function" then
				value = '"' .. tostring(v) .. '"'
			else
				value = '"unhandled type: ' .. type(v) .. '"'
			end
			if table_contents ~= "" then table_contents = table_contents .. ',' .. '\r\n' end
			table_contents = table_contents .. indentstring .. key .. ':' .. value
		end
	else
		table_contents = indentstring .. '"empty"'
	end
	if indent == 1 then
		Utility.tablesLogged = {}
		return '"' .. name .. '":{' .. '\r\n' .. table_contents .. '\r\n' .. '}'
	else
		return table_contents
	end
end

Utility.Log = function(text)
	if game ~= nil then
		game.write_file("Biter_Attack_Waves_logOutput.txt", tostring(text) .. "\r\n", true)
	end
end

Utility.LogPrint = function(text)
	if game ~= nil then
		game.print(tostring(text))
	end
	Utility.Log(text)
end

Utility.GetTableLength = function(table)
	local count = 0
	for k,v in pairs(table) do
		 count = count + 1
	end
	return count
end

Utility.GetTableNonNilLength = function(table)
	local count = 0
	for k,v in pairs(table) do
		if v ~= nil then
			count = count + 1
		end
	end
	return count
end

Utility.GetMaxKey = function(table)
	local max_key = 0
	for k, v in pairs(table) do
		if k > max_key then
			max_key = k
		end
	end
	return max_key
end

Utility.RoundNumberToDecimalPlaces = function(num, numDecimalPlaces)
	local result
	if numDecimalPlaces and numDecimalPlaces > 0 then
		local mult = 10 ^ numDecimalPlaces
		result =  math.floor(num * mult + 0.5) / mult
	else
		result = math.floor(num + 0.5)
	end
	if result == "nan" then
		result = 0
	end
	return result
end