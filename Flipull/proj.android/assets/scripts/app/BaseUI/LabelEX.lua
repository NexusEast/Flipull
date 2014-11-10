--[[example begin
local strNeedParsed = "#block@text:受寒dsgwsgwgwrgwrsgsggreg%100@callback:uuu@exatr:button#block@type:newline#block@color:r=255,g=0,b=7@type:string@text:当repl为字符串时,所有成功配对的子字符串均会被替换成指定的repl字串@count:1@exatr:button@pority:1@callback:www2#block@type:newline#block@color:r=0,g=255,b=7@type:string@text:begin------开始结束----end"
    local callbackTable=
        {
            ["uuu"] = function()
            echoInfo("I am Button uuu")
            end,
            ["www2"] = function()
                echoInfo("I am Button www2")
            end,
        }
    local llEXins = classLabelEX.new({
        width = 200,
        x = 800,
        y = 500,
        tblCallback = callbackTable,
        strSrc = strNeedParsed,
        responseRect = CCRect(0,0,display.width,display.height),

        --font = "res/TestRichText/simhei.ttf",
        --size = 20,
        --hspace = 40,
    }):addTo(self)
 example end]]--


local LabelEX = class("LabelEX",function()
    return CCNodeExtend.extend(CCNode:create())
end)

LabelEX.ASCII_NUM_MAX = 127
LabelEX.STR_EMPTY = ""
LabelEX.DEFAULT_FONT = "Airal"
LabelEX.DEFAULT_FONT_COLOR = ccc3(0, 0, 0)

LabelEX.CONSTANT_STR_BLOCK = "block"
LabelEX.CONSTANT_STR_TYPE = "type"
LabelEX.CONSTANT_STR_TYPE_TEXT = "text"
LabelEX.CONSTANT_STR_COLOR = "color"
LabelEX.CONSTANT_STR_SHADOW = "shadow"
LabelEX.CONSTANT_STR_OUTLINE = "outline"
LabelEX.CONSTANT_STR_COUNT = "count"
LabelEX.CONSTANT_STR_EXATR = "exatr"
LabelEX.CONSTANT_STR_CALLBACK = "callback"


function LabelEX.isAsciiChar(strNumber)
    local byteNumber = string.byte(strNumber)
    if byteNumber and byteNumber >= 0 and byteNumber <= LabelEX.ASCII_NUM_MAX then
        return true
    end
    return false
end


function LabelEX.split(str, delim, maxNb)
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0 -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function LabelEX:getLinesCount()
    return self.linesCount
end

function LabelEX.parse(strSrc)
    local tblDest = {}
    local arrBlocks = LabelEX.split(strSrc, "#block")
    arrBlocks = arrBlocks or {}
    local itemCur = {}
    local function getRetFind(strInput, strKey)
        return string.find(strInput, strKey)
    end


    -- echoInfo("strSrc=%s", tostring(strSrc))
    for i, v in ipairs(arrBlocks) do
        -- echoInfo("arrBlocks item =%s", tostring(v))
        if v and string.len(v) > 0 then
            local arrElements = LabelEX.split(v, "@")
            arrElements = arrElements or {}
            local tblItem = {}
            for i1, v1 in ipairs(arrElements) do

                local retFind1, retFind2
                -- echoInfo("v1=%s", tostring(v1))
                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_TYPE .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.type = string.sub(v1, retFind2 + 1, string.len(v1))
                else
                    tblItem.type = "string"
                end

                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_TYPE_TEXT .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.text = string.sub(v1, retFind2 + 1, string.len(v1))
                else
                    --tblItem.text = ""
                end


                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_COUNT .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.count = tonumber(string.sub(v1, retFind2 + 1, string.len(v1))) or 1
                else
                    --tblItem.count = "string"
                end


                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_EXATR .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.exatr = string.sub(v1, retFind2 + 1, string.len(v1)) or ""
                else
                    --tblItem.count = "string"
                end


                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_OUTLINE .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.outline = string.sub(v1, retFind2 + 1, string.len(v1)) or ""
                else
                    --tblItem.count = "string"
                end


                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_CALLBACK .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    tblItem.callback = string.sub(v1, retFind2 + 1, string.len(v1)) or ""
                else
                    --tblItem.count = "string"
                end







                retFind1, retFind2 = getRetFind(v1, LabelEX.CONSTANT_STR_COLOR .. ":")
                if retFind1 and retFind2 and retFind1 == 1 then
                    local strColor = string.sub(v1, retFind2 + 1, string.len(v1))
                    local arrColor = LabelEX.split(strColor, ",")
                    arrColor = arrColor or {}
                    local r, g, b
                    for ic, vc in ipairs(arrColor) do
                        local retCCC1, retCCC2 = getRetFind(vc, "r=")
                        if retCCC1 and retCCC2 then
                            r = tonumber(string.sub(vc, retCCC2 + 1, string.len(vc))) or 255
                        end
                        retCCC1, retCCC2 = getRetFind(vc, "g=")
                        if retCCC1 and retCCC2 then
                            g = tonumber(string.sub(vc, retCCC2 + 1, string.len(vc))) or 255
                        end
                        retCCC1, retCCC2 = getRetFind(vc, "b=")
                        if retCCC1 and retCCC2 then
                            b = tonumber(string.sub(vc, retCCC2 + 1, string.len(vc))) or 255
                        end
                    end
                    -- echoInfo("r=%s,g=%s,b=%s", tostring(r), tostring(g), tostring(b))
                    tblItem.color = ccc3(r,g,b)
                else
                    --tblItem.type = "string"
                end
            end
            if tblItem then
                table.insert(tblDest, tblItem)
            end
        end
    end

    -- dump(tblDest)
    return tblDest
end


function LabelEX:createLabelByItem(tblItem)
    local labelRet
    if tblItem.exatr and tblItem.exatr == "button" then

        local tblParams = {
            text = tblItem.text,
            font = self.font,
            size = self.size,
            x = tblItem.x,
            y = tblItem.y,
            color = tblItem.color,
            listener = tblItem.callbackfunc
        }
        if tblItem.outline and tblItem.outline == "1" then
            labelRet = baseUI.newTTFLabelMenuItem(tblParams)
        else
            labelRet = baseUI.newTTFLabelMenuItem(tblParams)
        end

        labelRet:setAnchorPoint(ccp(0, 0.5))
    else
        local tblParams = {
            text = tblItem.text,
            font = self.font,
            size = self.size,
            x = tblItem.x,
            y = tblItem.y,
            color = tblItem.color,
        }
        if tblItem.outline and tblItem.outline == "1" then
            labelRet = baseUI.newTTFLabelWithOutline(tblParams)
        else
            labelRet = baseUI.newTTFLabel(tblParams)
        end


    end

    local posRet = ccp(labelRet:getPositionX(),labelRet:getPositionY())
    posRet.x = posRet.x-self.xOriginal
    posRet.y = posRet.y-self.yOriginal
    return labelRet,posRet
end


function LabelEX:setPosition(x,y)
    for _,v in pairs(self.labelsCollections) do
        if v.label and tolua.cast(v.label,"CCNode") then
            --echoInfo("LabelEX:setPosition")
            v.label:setPosition(x+v.posOffest.x,y+v.posOffest.y)
        end
    end
end

function LabelEX:ctor(params)
    self.labelsInfo = {}
    self.childNodeCollections = {}
    self.labelsCollections = {}
    self.menuItemCollections = {}
    self.linesCount = 1
    local x = params.x or 0
    local y = params.y or display.size.height
    local width = params.width or display.size.width
    local height = params.height or display.size.height
    local xBegin, yBegin, xOriginal, yOriginal = x, y, clone(x), clone(y)
    --local tblLabels = params.tblLabels or {}
    self.xOriginal,self.yOriginal = xOriginal,yOriginal
    local tblCallback = params.tblCallback or {}
    self.pos = { x = x, y = y }
    self.contentSize = CCSize(width, height)
    self.responseRect = params.responseRect or CCRect(0,0,display.width,display.height)

    self.size = params.size or 20
    self.font = params.font or LabelEX.DEFAULT_FONT
    self.hspace = params.hspace or (self.size + 2)
    self.strSrc = params.strSrc or ""
    self.Priority = params.Priority or kCCMenuHandlerPriority
    local tblLabels = LabelEX.parse(self.strSrc) or {}



    local widthAscii = self.size / 2
    local widthHan = self.size

    local lenWordCur = 0
    local strSingleCur = LabelEX.STR_EMPTY
    local color = LabelEX.DEFAULT_FONT_COLOR



    for i, v in ipairs(tblLabels) do
        if not v.type or (v.type and v.type == "string") then
            local lenCharCur = 0
            color = v.color
            for charCur in string.gfind(v.text, "[%z\1-\127\194-\244][\128-\191]*") do

                local result = LabelEX.isAsciiChar(charCur)
                if result then
                    lenCharCur = widthAscii
                else
                    lenCharCur = widthHan
                end
                --echoInfo("charCur=" .. charCur .. " result=" .. tostring(result) .. " lenCharCur=" .. lenCharCur)

                if lenWordCur + lenCharCur > width then
                    --oldline
                    local callbackfunc
                    if v.callback then
                        callbackfunc = tblCallback[v.callback]
                    end
                    local tblItem = { text = strSingleCur, x = xBegin, y = yBegin, color = color, exatr = v.exatr ,callbackfunc=callbackfunc,outline=v.outline}
                    local labelCur,posRet = self:createLabelByItem(tblItem)
                    tblItem.item = labelCur
                    table.insert(self.labelsInfo, tblItem)
                    --table.insert(self.labelsCollections,labelCur)
                    table.insert(self.labelsCollections,{
                        label = labelCur,
                        posOffest = posRet,
                    })
                    --newline
                    strSingleCur = charCur
                    lenWordCur = lenCharCur
                    xBegin = xOriginal
                    yBegin = yBegin - self.hspace
                    self.linesCount = self.linesCount+1
                    --echoInfo("here!!")
                else
                    strSingleCur = strSingleCur .. charCur
                    lenWordCur = lenWordCur + lenCharCur
                end
                --echoInfo("lenWordCur=" .. lenWordCur)
            end

            local callbackfunc
            if v.callback then
                -- echoInfo("v.callback=%s",tostring(v.callback))
                callbackfunc = tblCallback[v.callback]
            end

            local tblItem = { text = strSingleCur, x = xBegin, y = yBegin, color = color, exatr = v.exatr ,callbackfunc=callbackfunc,outline=v.outline}
            local labelCur,posRet = self:createLabelByItem(tblItem)
            tblItem.item = labelCur
            table.insert(self.labelsInfo, tblItem)
            table.insert(self.labelsCollections,{
               label = labelCur,
               posOffest = posRet,
            })

            xBegin = xBegin + labelCur:getContentSize().width
            strSingleCur = LabelEX.STR_EMPTY
        elseif v.type and v.type == "newline" then
            local countLines = 1
            if v.count then
                countLines = v.count
            end
            yBegin = yBegin - self.hspace * countLines
            self.linesCount = self.linesCount+countLines
            --echoInfo("here22!!%s",tostring(countLines))
            xBegin = xOriginal
            strSingleCur = LabelEX.STR_EMPTY
            lenWordCur = 0
        end
    end

    self.contentSize.height = math.abs(yBegin - yOriginal) + self.hspace

    --dump(self.labelsCollections)
    --dump(self.labelsInfo)

    for i, v in pairs(self.labelsInfo) do
        if v.item and v.exatr and v.exatr == "button" then
            table.insert(self.menuItemCollections,v.item)
        else
            table.insert(self.childNodeCollections,v.item)
            self:addChild(v.item)
        end
    end

    local menu = baseUI.newRectMenu(self.menuItemCollections,self.Priority,self.responseRect)
    menu:setPosition(0, 0)
    menu:setJudgeMoved(true)
    table.insert(self.childNodeCollections,menu)
    self:addChild(menu)


end


function LabelEX:getContentSize()
    return self.contentSize
end

return LabelEX