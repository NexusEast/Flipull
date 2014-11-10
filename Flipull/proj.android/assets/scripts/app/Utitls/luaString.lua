--
-- Author: moon
-- Date: 2014-05-23 10:58:35
-- info:字符串操作封装 暂时只有分割 按需求添加
function lua_string_split(str, split_char)
	local sub_str_tab = {}
	local i = 0
	local j = 0
	while true do
		j = string.find(str, split_char,i+1)
		if j == nil then
			table.insert(sub_str_tab,string.sub(str,i+1,#str))
			break
		end
		if i+1 <= j-1 then
			table.insert(sub_str_tab,string.sub(str,i+1,j-1))
		end
		i = j
		if i == #str then
			break
		end
	end
	return sub_str_tab
end

function lua_string_to_table( string )
	local text = 'return {' .. string .. '}'
    local fn = loadstring( text )
    if fn == nil then
        return nil
    end

    return fn()
end

function getTableNum( tbl )
	local num = 0
	for _,_ in pairs( tbl ) do
		num = num + 1
	end
	return num
end

function sortTableByKey( srcTable )
	local keys = {}
	local sortTable = {}
	for key,_ in pairs( srcTable ) do 
		table.insert( keys, key )
	end
	table.sort(keys)
	for  _,key in pairs( keys ) do
		sortTable[key] = srcTable[key]
	end
	return sortTable
end
