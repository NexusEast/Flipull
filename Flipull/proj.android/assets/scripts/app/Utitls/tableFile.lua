
 luautil = {}

function luautil.serialize(t, sort_parent, sort_child)
    local mark={}
    local assign={}
    
    local function ser_table(tbl,parent)
        mark[tbl]=parent
        local tmp={}
        local sortList = {};
        for k,v in pairs(tbl) do
            sortList[#sortList + 1] = {key=k, value=v};
        end

        if tostring(parent) == "ret" then
            if sort_parent then table.sort(sortList, sort_parent); end
        else
            if sort_child then table.sort(sortList, sort_child); end
        end

        for i = 1, #sortList do
            local info = sortList[i];
            local k = info.key;
            local v = info.value;
            local key= type(k)=="number" and "["..k.."]" or k;
            if type(v)=="table" then
                local dotkey= parent..(type(k)=="number" and key or "."..key)
                if mark[v] then
                    table.insert(assign,dotkey.."="..mark[v])
                else
                    table.insert(tmp, "\n"..key.."="..ser_table(v,dotkey))
                end
            else
                if type(v) == "string" then
                    table.insert(tmp, key..'="'..v..'"');
                else
                    table.insert(tmp, key.."="..tostring(v));
                end
            end
        end

        return "{"..table.concat(tmp,",").."}";
    end
 
    return "do local ret=\n\n"..ser_table(t,"ret")..table.concat(assign," ").."\n\n return ret end"
end

function luautil.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

function luautil.writefile(str, file)
    os.remove(file);
    local file=io.open(file,"ab");

    local len = string.len(str);
    local tbl = luautil.split(str, "\n");
    for i = 1, #tbl do
        file:write(tbl[i].."\n");
    end
    file:close();
end