--
-- Author: yyj
-- Date: 2014-06-23 14:21:48
--

local TipLayer = class("TipLayer", function()
		return require("app.BaseUI.PushLayer").new()
	end)
local Resource = require("app.Misc.Resource")


local tag_tip = 101
function TipLayer:ctor(size,message,bgFile)

	bgFile = bgFile or Resource.Tip.tipBg
	local bg = display.newScale9Sprite(bgFile)
	if size then bg:setContentSize(size) end
	bg:setPosition(display.cx, display.cy)
	self:addChild(bg)
	self.bg = bg
	if message then self:setMessage(message) end
end

function TipLayer:setMessage(message,fontSize)
	if not message or string.len(message)<=0 then echoInfo("message invalid") return end

	local fsize = fontSize or 20
	local size = self.bg:getContentSize()
	size=CCSize(size.width*0.8, size.height*0.8)
	local text = self:getChildByTag(tag_tip)
	if text then 
		text = tolua.cast(text, "CCLabelTTF")
		text:setString(message)
	else
		text = CCLabelTTF:create(message, baseUI.DEFAULT_FONT, fsize,
                                             size, kCCTextAlignmentLeft, kCCVerticalTextAlignmentCenter)
		text:setColor(BaseFontColor.cc3_COLOR_TIP_CONTENT)
		text:setAnchorPoint(ccp(0.5, 0.5))
		text:setPosition(display.cx,display.cy)
		text:setTag(tag_tip)
		self:addChild(text)
	end
end

function TipLayer:setOKButton(callfunc)
	local item = baseUI.newImageMenuItem({
        image = Resource.UI.Button.btn07,
        imageSelected = Resource.UI.Button.btn07Select,
        text = "确定",
        x=0,y=0,
        listener = function()
            ------------------
            if self.guideType  and self.guideType == WindowType.TipLayer then
                Newbie:nextNumAndCleanByActiveItem(self.guideType,"ITEM_TaskAwardGet")
                self:broadcastMessage({
                    clsName = WND_NAME.TASK_SYSTEM,
                },WM_MSG_ID.TIPLAYER_CLOSE,{})
            end
            -----------------
            if not callfunc then
            	self:onClose()
            else
            	callfunc()
            end
        end
    })
    local menu = baseUI.newRectMenu({item},self:getTouchPriority())
    item:setPosition(self.bg:getContentSize().width/2, item:getContentSize().height/2) 
    item:setScale(0.7)
    self.bg:addChild(menu)

    if self.guideType  and self.guideType == WindowType.TipLayer then
    self.NewbieItems["ITEM_TaskAwardGet"] = item
    end
end
function TipLayer:setTitle(title)
	local label = baseUI.newTTFLabel({
            text = title,
            color = BaseFontColor.yellow,
            align = ui.TEXT_ALIGN_CENTER,
        	x = self.bg:getContentSize().width/2,
        	y = self.bg:getContentSize().height-30,
            size = 20,
    }) :addTo(self.bg)
end

--[[
rewardList 奖励列表= {
	id,
	num,
}
parentType : "system" 系统任务 "daily"  日常任务
]]
function TipLayer.showRewardTip(title,rewardList,parent,parentType)
	echoInfo("titile "..title)
	dump(rewardList)
	if rewardList and parent then 
		local size = CCSize(480, 180)
		if #rewardList>1 then size.height = size.height + 40*(#rewardList-1) end
		local tip = TipLayer.new(size,nil,Resource.Scale9Sprite.messageBoxBG)
		tip:setOCAnimation(true)
        --确定按钮
        echoInfo("parentType=%s",tostring(parentType))
        if parentType and  parentType == "system" then
            tip.guideType = WindowType.TipLayer
            tip.parentType = parentType
        end
        tip:setOKButton(nil,parentType)
        if parentType and  parentType == "system" then
--            tip:performWithDelay(function()
                Newbie:startStep(tip.guideType,tip)
--            end,2.0)

        end

		parent:addChild(tip)



		-- tip:setTitle(title)
		local titleBg = display.newSprite(Resource.Titles.tipTitle, tip.bg:getContentSize().width/2, 
			tip.bg:getContentSize().height-30):addTo(tip.bg)
		local label = baseUI.newTTFLabel({
            text = title,
            color = BaseFontColor.cc3_COLOR_TIP_TITLE,
            align = ui.TEXT_ALIGN_CENTER,
        	x = titleBg:getContentSize().width/2,
        	y = titleBg:getContentSize().height/2,
            size = 20,
    }) :addTo(titleBg)
		--奖励
		if #rewardList == 0 then return end
		local startY = tip.bg:getContentSize().height-80
		-- if #rewardList == 2 then startY = startY *1.3 end
		local RichLabel= require("app.BaseUI.RichLabel")
		for i=1,#rewardList do 
			local reward = rewardList[i]
			local params = {}
			local icon = nil 
			if tostring(reward.id) =="money" then 
				icon = display.newSprite(Resource.mainScreenCoin)
				-- icon:setScale(0.9)
			elseif tostring(reward.id) =="exp" then 
				icon = display.newSprite(Resource.UI.Icons.expIcon)
				-- icon:setScale(0.9)
			elseif tostring(reward.id) =="diamond" then 
				icon = display.newSprite(Resource.mainScreenGem)
				-- icon:setScale(0.9)
			elseif tostring(reward.id) == "strength" then 
				icon = display.newSprite(Resource.mainScreenStrength)
			else 
				icon = getItemSpriteByID(tonumber(reward.id))
                icon:setScale(0.35)
			end

			params[1] = { type = RichLabel.Type.SPRITE,
            				content = icon,}
            params[2] = {content = "  x"..reward.num,color = BaseFontColor.cc3_COLOR_TIP_CONTENT}
            local richLabel = require("app.BaseUI.RichLabel").new(params)
            richLabel:setPosition(tip.bg:getContentSize().width/2-50, startY)
            tip.bg:addChild(richLabel)
            startY = startY -40
		end
	end
end


function TipLayer.showPureTip(size,message,parent)
	if size and message and parent then 
		local tip = TipLayer.new(size,message,Resource.Scale9Sprite.tipBg)
		tip:setTouchClosed(true, CCRect(0, 0, 0, 0))
		tip:setOCAnimation(true)
		parent:addChild(tip)
		return tip
	end
end

return TipLayer