
local pub = {}

local MsgPack = require("msgpack")
local Resource = require("app.Misc.Resource")
pub.COLOR_BLACK = ccc3(0, 0, 0)
pub.COLOR_BLUE = ccc3(0, 0, 255)
pub.COLOR_RED = ccc3(255, 0, 0)
pub.COLOR_WHITE = ccc3(255, 255, 255)
pub.COLOR_YELLOW = ccc3(255, 255, 0)
pub.COLOR_SETTING_TITLE = ccc3(159,138,23)
pub.COLOR_BTN_TEXT = pub.COLOR_SETTING_TITLE

pub.COLOR_ORANGE = pub.COLOR_BLACK

--pub.COLOR_BG_GREY = ccc4(13, 13, 25, 255 * 0.75 )
pub.COLOR_BG_GREY = ccc4(13, 13, 25, 100)
pub.COLOR_BG_EMPTY = ccc4(255, 255, 255, 0 )
pub.COLOR_NAME = ccc3(228,185,164)
pub.COLOR_TEXT_NORMAL = ccc3(194,190,126)
function pub.setVisible(node, isVisible)
    if node and tolua.cast(node, "CCNode") then
        if isVisible then
            if node:isVisible() == false then
                node:setVisible(isVisible)
            end
        else
            if node:isVisible() == true then
                node:setVisible(isVisible)
            end
        end
    else
        echoInfo("pub.setVisible error param!")
    end
end


function pub.createEnumTable(tbl, index)
    local enumTable = {}
    local enumIndex = index or -1
    for i, v in ipairs(tbl) do
        enumTable[v] = enumIndex + i
    end
    return enumTable
end

function pub.readFileFromTable(file)
    local f = io.open(file, "r")
    if not f then
        echoInfo("file not exist file=%s", tostring(file))
        return {}
    end
    local content = f:read("*a")
    f:close()
    return json.decode(content)
end

--写文件
function pub.writeTableToFile(file, tableData, mode)
    local f = io.open(file, mode or "w")
    if f then
        local json_data =json.encode(tableData)
        f:write(json_data)
        f:flush()
        f:close()
        return true
    end
    return false
end
--unpake
function pub.readFileFromTableByMSG(file)
    local f = io.open(file, "r")
    if not f then
        echoInfo("file not exist file=%s", tostring(file))
        return {}
    end
    local content = f:read("*a")
    f:close()
    return MsgPack.unpack(content)
end

--m.pake
function pub.writeTableToFileByMSG(file, tableData, mode)
    local f = io.open(file, mode or "w")
    if f then
        --pub.dump(tableData,"tableData") 
        local json_data = MsgPack.pack(tableData)--luautil.serialize(tableData)--json.encode(tableData)
        --echoInfo("json_data %s",json_data)
        f:write(json_data)
        f:flush()
        f:close()
        return true
    end
    return false
end
function pub.randomTable(tblSrc)
    local tblRet = {}
    local tblClone = clone(tblSrc)
    local nSum = #tblClone
    local nSelect
    math.randomseed(os.time())
    for i = 1, nSum do
        nSelect = math.random(#tblClone)
        table.insert(tblRet, tblClone[nSelect])
        table.remove(tblClone, nSelect)
    end
    return tblRet
end

function pub.removeElementFromTable(tblSrc,funcRemove)
    local tblRemain = {}
    local tblRemove = {}
    for i,v in ipairs(tblSrc) do
        if funcRemove(v) then
            table.insert(tblRemove,v)
        else
            table.insert(tblRemain,v)
        end
    end
    return tblRemain,tblRemove
end



function pub.createPngFromSprite(node,dir,filename)
    echoInfo("pub.createPngFromNode  111")

    local baseDir = require("app.Utitls.DirBase")..dir.."/"
    echoInfo("baseDir=%s",tostring(baseDir))
    require "lfs"

    if lfs.mkdir(baseDir) then
        CCLuaLog("path create OK------> "..baseDir)
    end

    local size = node:getContentSize()
    local x = node:getPositionX()
    local y = node:getPositionY()

    rt = CCRenderTexture:create(size.width,size.height,kCCTexture2DPixelFormat_RGBA8888);


    node:setPosition(size.width/2,size.height/2)
    rt:beginWithClear(0, 0, 0, 0)
    node:visit()

    rt:endToLua()

    node:setPosition(x,y)

    local path = baseDir..filename..".png"
    echoInfo("path=%s",tostring(path))
    local bRet = rt:saveToFile(path,kCCImageFormatPNG)
    echoInfo("bRet=%s",tostring(bRet))


end

function pub.getCurrentTime()
    return CCTime:getCurrentTime()
end

function pub.print(...)
    printsimple(...)
end
function pub.formatTimeBySec(time_)--时间段
    local tblRet = {
        day=0,
        hour=0,
        min=0,
        sec=0,
    }
    local time = toint(time_)
    local daySec = 60*60*24
    local hourSec = 60*60
    local minSec = 60
    local LeftSec = time
    tblRet.day = math.floor(LeftSec/daySec)
    LeftSec=LeftSec-tblRet.day*daySec

    tblRet.hour = math.floor(LeftSec/hourSec)
    LeftSec=LeftSec-tblRet.hour*hourSec

    tblRet.min = math.floor(LeftSec/minSec)
    LeftSec=LeftSec-tblRet.min*minSec

    tblRet.sec=LeftSec

    return tblRet
end

--    "day"   = 29
--Cocos2d: [555.5925] -     "hour"  = 11
--Cocos2d: [555.5925] -     "isdst" = false
--Cocos2d: [555.5925] -     "min"   = 28
--Cocos2d: [555.5925] -     "month" = 9
--Cocos2d: [555.5926] -     "sec"   = 31
--Cocos2d: [555.5926] -     "wday"  = 2
--Cocos2d: [555.5926] -     "yday"  = 272
--Cocos2d: [555.5926] -     "year"  = 2014
function pub.createTimeString(time_)
    local strRet = "**时间"
    local tblDate = os.date("*t", tonumber(time_))
    strRet = tostring(tblDate.year).."年"..tostring(tblDate.month).."月"..tostring(tblDate.day).."日"..tostring(tblDate.hour).."时"..tostring(tblDate.min).."分"..tostring(tblDate.sec).."秒"
    return strRet
end


function pub.getTransNodePosition(nodeDst,nodeSrc)
    local xRet,yRet,wRet,hRet = -10000,-10000,0,0
    if tolua.cast(nodeDst, "CCNode") and tolua.cast(nodeSrc, "CCNode") and  nodeDst:getParent() then
        local  style = 1
        ----------style1-------------
        --[[]]--
        local node1,node2 = nodeSrc,nodeDst:getParent()
        local ptTrans = node1:convertToNodeSpaceAR(ccp(node2:getPositionX(),node2:getPositionY()))
        echoInfo("style=111")
        xRet,yRet = -ptTrans.x,-ptTrans.y

        ------------style1---------

        ------------style2-----------
        --[[
        local node1,node2 = nodeDst,nodeSrc
        local ptTrans = node1:convertToNodeSpace(ccp(node2:getPositionX(),node2:getPositionY()))
        xRet,yRet = -ptTrans.x,ptTrans.y
]]--


--        local aptNode1 = node1:getAnchorPoint()
--        echoInfo("aptNode1 x=%s y=%s",tostring(aptNode1.x),tostring(aptNode1.y))
--        echoInfo("style=222")

        -------------style2-------------
        local sizeNodeSrc = nodeSrc:getContentSize()
        wRet,hRet = sizeNodeSrc.width,sizeNodeSrc.height
    else
        echoInfo("pub.getTransNodePosition error params")
    end
--    echoInfo("pub.getTransNodePosition ptRet x=%s,y=%s,w=%s,h=%s",tostring(xRet),tostring(yRet),tostring(wRet),
--        tostring(hRet))
    return xRet,yRet,wRet,hRet
end

function pub.dump(object, label, isReturnContents, nesting)
    echoInfo("pub.dump ing..............")
    local traceback = string.split(debug.traceback("", 2), "\n")
    echo("dump from: " .. string.trim(traceback[3]))
    if object then
        if type(object) == "table" then
            pub.dumpnew(object, label, isReturnContents, nesting)
        elseif type(object) == "number" or type(object) == "string" then
            pub.print(tostring(object))
        else
            echoInfo("pub.dump invalid params")
        end
    else
        echoInfo("pub.dump invalid params = nil")
    end
end
function pub.dumpnew(object, label, isReturnContents, nesting)
    if type(nesting) ~= "number" then nesting = 999 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        elseif type(v) == "number" then
            v = "["..tostring(v).."]"
        end
        return tostring(v)
    end

    local function _v_key(v)
        if type(v) == "string" then
            v = "[".."\"" .. v .. "\"".."]"
        elseif type(v) == "number" then
            v = "["..tostring(v).."]"
        end
        return tostring(v)
    end

    local function _v_value(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

--    local traceback = string.split(debug.traceback("", 2), "\n")
--    echo("dump from: " .. string.trim(traceback[3]))

    local function _dump(object, label, indent, nest, keylen)
        label = label or "<var>"
        IAM_A_SPC = ""
        if type(keylen) == "number" then
            IAM_A_SPC = string.rep(" ", keylen - string.len(_v(label)))
        end
        if type(object) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s,", indent, _v_key(label), IAM_A_SPC, _v_value(object))
        elseif lookupTable[object] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, label, IAM_A_SPC)
        else
            lookupTable[object] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, label)
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v_key(label))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(object) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s},", indent)
            end
        end
    end

    echoInfo("count = %s",tostring(#result))


    _dump(object, label, "", 1)

    if isReturnContents then
        return table.concat(result, "\n")
    end

    if #result > 0 then
        result[#result] = string.sub(result[#result],1,-2)
    end

    for i, line in ipairs(result) do
        pub.print(line)
    end
end





function pub.getAllChildArray(node_)
    local tblRetFinal = {}
    local funRecu,funGetSubArr
    funRecu = function (arrSub)
        if arrSub then
            local count = arrSub:count()
            if count > 0 then
                for i=0,count-1 do
                    local node = arrSub:objectAtIndex(i)
                    if node then
                        local tmpArrSub = funGetSubArr(node)
                        funRecu(tmpArrSub)
                        --table.insert(tblRetFinal,tmpArrSub)
                    end
                end
                table.insert(tblRetFinal,arrSub)
            else
                --table.insert(tblRetFinal,arrSub)
            end
        else

        end
    end

    funGetSubArr = function(nodeParent)
        local arrRet
        if tolua.cast(nodeParent,"CCNode") then
            arrRet = nodeParent:getChildren()
        end
        return  arrRet
    end


    local tblTemp = funGetSubArr(node_)
    funRecu(tblTemp)

    return tblRetFinal
end

return pub