--
-- Author: yyj
-- Date: 2014-06-20 16:07:37
--

local Resource = require("app.Misc.Resource")


local RichLabel = class("RichLabel", 
	function()
		return display.newNode()
		end)


RichLabel.Type = {
	LABEL = 1,
	SPRITE = 2,
}

--[[
paramTbl = {
	{
		type = RichLabel.Type.LABEL
		content = "内容",
		color = ccc3(r,g,b), 字体颜色
		size = 20, //字体大小
	},
	{
		type = RichLabel.Type.SPRITE
		content = filePath,
	},
	...
}
可构造出一个文字一个图片的序列
]]
function RichLabel:ctor(paramTbl)
	if not paramTbl or type(paramTbl )~="table" then echoInfo("RichLabel : invalid paramTbl ")  return end

	self.paramTbl  = paramTbl 

	local curX = 0
	for i=1,#paramTbl do
		local ele = paramTbl [i]
		if ele then 
			local eleType = ele.type or RichLabel.Type .LABEL
			local content = ele.content
			local color = ele.color or BaseFontColor.cc3_COLOR_ON_YELLOW_BG
			local size = ele.size or 20
			if eleType == RichLabel.Type .LABEL then 
				local label = baseUI.newTTFLabel({
           			text = content,
           			color = color,
           			align = ui.TEXT_ALIGN_LEFT,
           			size = size,
           			}) :addTo(self)
				label:setTag(i)
				label:setAnchorPoint(ccp(0,0.5))
				label:setPosition(curX, 0)
				curX = curX + label:getContentSize().width
			else
				local sprite = nil
				if type(content)=="string" then 
					sprite = display.newSprite(content)
				else
					sprite = content
				end
				sprite:setAnchorPoint(ccp(0, 0.5))
				sprite:setPosition(curX,0)
				sprite:setTag(i)
				self:addChild(sprite)
				curX = curX + sprite:getContentSize().width * sprite:getScaleX()
			end
		end

	end

end

--更新文字
function RichLabel:setLabelStringByIndex(index,content)
	if self.paramTbl [index] then 
		local ele = self.paramTbl [index]
		local eleNode = self:getChildByTag(index)
		if eleNode then 
			local eleType = ele.type or RichLabel.Type .LABEL
			
			if eleType == RichLabel.Type .LABEL then 
				eleNode = tolua.cast(eleNode, "CCLabelTTF")
				if eleNode then 
					eleNode:setString(content)
					self:_updatePosition()
				end
			end
		end
	end
end

--index为元素所属的位置
--content 为CCSprite 或者 图片路径
function RichLabel:setSpriteByIndex(index,content)
	if self.paramTbl [index] then 
		local ele = self.paramTbl [index]
		local eleNode = self:getChildByTag(index)
		if eleNode then 
			local eleType = ele.type or RichLabel.Type .LABEL
			
			if eleType == RichLabel.Type .SPRITE then 
				eleNode = tolua.cast(eleNode, "CCSprite")
				if type(content) == "string" then
					eleNode:setDisplayFrame(display.newSprite(content):getDisplayFrame())
				else
					eleNode:removeFromParentAndCleanup(true)
					content:setAnchorPoint(ccp(0, 0.5))
					content:setTag(index)
					self:addChild(content)
				end
				self:_updatePosition()
			end
		end
	end
end

--更新位置
function RichLabel:_updatePosition()
	local curX = 0
	for i=1,#self.paramTbl do 
		local ele = self.paramTbl[i]

		local eleNode = self:getChildByTag(i)
		if eleNode then 
			eleNode:setPositionX(curX)
			curX = curX + eleNode:getContentSize().width*eleNode:getScaleX()
		end
	end
end


return RichLabel